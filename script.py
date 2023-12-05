import psycopg
from pprint import pprint
import csv
import psycopg2

CONNECTION_URL = "postgresql://devi:123456@localhost/bdav?application_name=psyco"
QUERY_TEST = "select current_timestamp, version();"
CSV_PATH = "offres-demploi.csv"
OFFRE_TEMP_SQL = "offre_temp.sql"


def sync(conn):
    try:
        cur = conn.execute(QUERY_TEST)
        content = cur.fetchone()
        return content
    except Exception as err:
        print(f"Erreur lors de la requête synchrone : {err}")
        return None


def insert_temp_table(conn, file_csv):
    cur = conn.cursor()
    cur = conn.cursor()

    # Lire les en-têtes du fichier CSV
    with open(file_csv, newline='', encoding='utf-8') as csvfile:
        reader = csv.reader(csvfile)
        headers = next(reader)

        # Création de la requête SQL pour créer une table
        # Toutes les colonnes sont définies comme TEXT
        columns_sql = ', '.join([f'"{header}" TEXT' for header in headers])
        create_table_query = f"CREATE TABLE IF NOT EXISTS offre_temp ({columns_sql});"
        cur.execute(create_table_query)
        conn.commit()

        # Préparation de la requête d'insertion
        placeholders = ', '.join(['%s'] * len(headers))
        insert_query = f"INSERT INTO offre_temp ({', '.join(['\"' + header + '\"' for header in headers])}) VALUES ({placeholders});"

        # Insertion des données
        for row in reader:
            cur.execute(insert_query, row)
        conn.commit()

    cur.close()


def init_temp_table(conn, csv_path):
    cur = conn.cursor()

    # Lire les en-têtes du fichier CSV
    with open(csv_path, newline='', encoding='utf-8-sig') as csvfile:  # 'utf-8-sig' gère le BOM s'il existe
        reader = csv.reader(csvfile)
        headers = next(reader)

        # Création de la requête SQL pour créer une table
        columns_sql = ', '.join([f'"{header}" TEXT' for header in headers])
        create_table_query = f"CREATE TABLE IF NOT EXISTS offre_temp ({columns_sql});"
        cur.execute(create_table_query)
        conn.commit()

        cur.close()
        conn.close()


if __name__ == "__main__":
    print(psycopg.version.__version__)
    with psycopg.connect(CONNECTION_URL) as the_conn:
        pprint(sync(the_conn))
        # init_temp_table(the_conn, CSV_PATH)
        insert_temp_table(the_conn, CSV_PATH)