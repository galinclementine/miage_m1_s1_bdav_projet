import pandas as pd
import psycopg

FILE_PATH_CSV = "data/offres-demploi.csv"
CONNECTION_URL = "postgresql://devi:123456@localhost/bdav?application_name=psyco"
SCHEMA_SQL = "sql/schema.sql"

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
            create_table_command += f"    \"{col}\" TEXT,\n"
        create_table_command = create_table_command.rstrip(',\n') + "\n);"

        # Créer la table
        with conn.cursor() as cur:
            cur.execute(create_table_command)
            conn.commit()
            return f"La table {table_name} a été créée."

    except psycopg.DatabaseError as e:
        # Gérer l'erreur SQL
        return f"Erreur lors de la création de la table {table_name} : {e}"


def insert_data_from_csv(file_path, table_name, conn):
    try:
        df = pd.read_csv(file_path)

        # Entourer les noms de colonnes de guillemets doubles pour conserver la casse
        columns = ['"' + col + '"' for col in df.columns]
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
            return f"Les données ont été insérées avec succès dans la table {table_name}. Nombre de lignes insérées : {rows_inserted}."

    except psycopg.DatabaseError as e:
        # Gérer l'erreur SQL et effectuer un rollback
        conn.rollback()
        return f"Erreur SQL : {e}"


def execute_sql_file(file_path, conn):
    try:
        with open(file_path, 'r') as file:
            sql_script = file.read()

        with conn.cursor() as cur:
            cur.execute(sql_script)
            conn.commit()
            return "Le script SQL a été exécuté avec succès."
    except Exception as e:
        return f"Erreur lors de l'exécution du script SQL : {e}"


if __name__ == "__main__":
    with psycopg.connect(CONNECTION_URL) as the_conn:
        #print(create_table_from_csv(FILE_PATH_CSV, "offre_temp", the_conn))
        #print(insert_data_from_csv(FILE_PATH_CSV, "offre_temp", the_conn))
        print(execute_sql_file(SCHEMA_SQL, the_conn))