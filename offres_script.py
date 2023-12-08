import pandas as pd
import psycopg
from prettytable import PrettyTable

USER_BDAV = "devi"
PASSWORD_BDAV = "123456"
HOST_BDAV = "localhost"
PORT_BDAV = "5432"
DATABASE_BDAV = "bdav"
CONNECTION_URL = f"postgresql://{USER_BDAV}:{PASSWORD_BDAV}@{HOST_BDAV}:{PORT_BDAV}/{DATABASE_BDAV}?application_name=psyco"
FILE_PATH_CSV = "data/offres-demploi.csv"
SCHEMA_SQL = "sql/offres_schema.sql"
DATASET_SQL = "sql/offres_dataset.sql"

def table_exists(table_name, conn):
    try:
        with conn.cursor() as cur:
            cur.execute(f"SELECT EXISTS (SELECT FROM information_schema.tables WHERE table_name = '{table_name}');")
            return cur.fetchone()[0]
    except psycopg.DatabaseError as e:
        # Gérer l'erreur SQL et retourner une réponse appropriée
        print(f"Erreur lors de la vérification de l'existence de la table {table_name} : {e}")
        return False


def create_table_from_csv(file_path, table_name, conn):
    try:
        # Vérifier si la table existe déjà
        if table_exists(table_name, conn):
            return f"La table {table_name} existe déjà."

        # Lire le fichier CSV pour extraire les en-têtes des colonnes
        df = pd.read_csv(file_path)
        columns = df.columns.tolist()

        # Générer la commande SQL pour créer la table
        create_table_command = f"CREATE TABLE {table_name} (\n"
        for col in columns:
            create_table_command += f"{col} TEXT,\n"
        create_table_command = create_table_command.rstrip(',\n') + "\n);"

        # Créer la table
        with conn.cursor() as cur:
            cur.execute(create_table_command)
            conn.commit()
            return f"La table {table_name} a été créée.\n"

    except psycopg.DatabaseError as e:
        # Gérer l'erreur SQL
        return f"Erreur lors de la création de la table {table_name} -> {e}\n"


def insert_data_from_csv(file_path, table_name, conn):
    try:
        df = pd.read_csv(file_path)

        # Remplacer les valeurs NaN par NULL
        df = df.where(pd.notna(df), None)

        # Générer la commande SQL pour insérer les données
        columns = [col for col in df.columns]
        placeholders = ", ".join(["%s" for _ in df.columns])
        insert_query = f"INSERT INTO {table_name} ({', '.join(columns)}) VALUES ({placeholders})"

        # Vider la table avant l'insertion
        with conn.cursor() as cur:
            cur.execute(f"TRUNCATE TABLE {table_name};")
            conn.commit()

            # Insérer les données
            cur.executemany(insert_query, [tuple(row) for row in df.to_numpy()])
            conn.commit()

            # Retourner le nombre de lignes insérées
            rows_inserted = cur.rowcount
            return (f"Les données ont été insérées avec succès dans la table {table_name}. "
                    f"Nombre de lignes insérées -> {rows_inserted}")

    except psycopg.DatabaseError as e:
        # Gérer l'erreur SQL et effectuer un rollback
        conn.rollback()
        return f"Erreur lors de l'insertion des données dans la table {table_name} -> {e}"


def execute_sql_file(file_path, conn):
    try:
        with open(file_path, 'r') as file:
            sql_script = file.read()

        with conn.cursor() as cur:
            cur.execute(sql_script)

            if cur.description:  # Si le résultat est une requête SELECT
                # Création d'un tableau avec des en-têtes de colonnes
                table = PrettyTable([column[0] for column in cur.description])
                for row in cur.fetchall():
                    table.add_row(row)

                print(table)  # Affiche le tableau
            else:
                conn.commit()
                return f"Le script SQL {file_path} a été exécuté avec succès -> {cur.statusmessage}"

    except Exception as e:
        return f"Erreur lors de l'exécution du script SQL : {e}"


if __name__ == "__main__":
    with psycopg.connect(CONNECTION_URL) as the_conn:
        # Création et insertion des données du fichier CSV
        print("\n--- Import des données ---")
        print(execute_sql_file(SCHEMA_SQL, the_conn))
        print(create_table_from_csv(FILE_PATH_CSV, "source_csv", the_conn))
        print(insert_data_from_csv(FILE_PATH_CSV, "source_csv", the_conn))
        print(execute_sql_file(DATASET_SQL, the_conn))
        print("--- Import des données terminé ---\n")

        print("--- Résultat de la requête 1 : Top 3 des compétences les plus demandées par expérience ---")
        print(execute_sql_file("sql/offres_requete1.sql", the_conn))
        print("\n--- Résultat de la requête 2 : Nombre d'offres par commune et par type de contrat ---")
        print(execute_sql_file("sql/offres_requete2.sql", the_conn))
        print("\n--- Résultat de la requête 3 : Métiers polyglothes ---")
        print(execute_sql_file("sql/offres_requete3.sql", the_conn))
        print("\n--- Résultat de la requête 4 : Métiers couvrant toutes les zones de déplacement ---")
        print(execute_sql_file("sql/offres_requete4.sql", the_conn))
        print("\n--- Résultat de la requête 5 : Niveaux de formation demandé en NC ---")
        print(execute_sql_file("sql/offres_requete5.sql", the_conn))