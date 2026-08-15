import pandas as pd
import mysql.connector


def carregar_dados():
    conexao = mysql.connector.connect(
        host="localhost",
        user="root",
        password="",
        database="inteligencia_compras"
    )

    query = """
        SELECT *
        FROM vw_inteligencia_compras
    """

    df = pd.read_sql(query, conexao)

    conexao.close()

    return df

if __name__ == "__main__":
    df = carregar_dados()

    print("\n=== DADOS EXTRAÍDOS DO MYSQL ===")
    print(df.head())

    print("\n=== DIMENSÕES ===")
    print(df.shape)

    print("\n=== COLUNAS ===")
    print(df.columns.tolist())

    print("\n=== TIPOS ===")
    print(df.dtypes)


