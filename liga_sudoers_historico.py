import sys

import psycopg2
from functions import *

from datetime import datetime

try:
    total_registros = int(sys.argv[1])
except:
    total_registros = 10

# Definindo os parâmetros de conexão
db_config = {
    'dbname': 'liga_sudoers',
    'user': 'sudoers',    
    'password': 'password',
    'host': 'localhost',
    'port': '5434'
}


try:
    conn = psycopg2.connect(**db_config)

    # Criando um cursor para executar comandos SQL
    cursor = conn.cursor()
    

    # Exemplo de consulta
    cursor.execute("SELECT  id, nome, sexo, dt_nasc FROM pessoas")
    pessoas = cursor.fetchall()

    cat_homens = [1,4,5,6]
    cat_homens_filhos = [1,4,5,6,7,8,9]
    cat_mulheres = [2,4,8,9]
    cat_mulheres_filhos = [1,2,3,4,7,8,9]

    print('Gerando dados aleatórios no banco de dados.')
    for i in range(0, total_registros):
    # Loop pelos resultados
        for pessoa in pessoas:
            id, nome, sexo, dt_nasc = pessoa
            data_nascimento = datetime.strptime(str(dt_nasc), '%Y-%m-%d')
            idade = datetime.now().year - data_nascimento.year - ((datetime.now().month, datetime.now().day) < (data_nascimento.month, data_nascimento.day))               

            if sexo == 'M' and idade < 35:
                produtos = get_produtos(cursor, cat_homens)
            elif sexo == 'M' and idade >= 35:
                produtos = get_produtos(cursor, cat_homens_filhos)            
            elif sexo == 'F' and idade < 35:
                produtos = get_produtos(cursor, cat_mulheres)
            elif sexo == 'F' and idade >= 35:            
                produtos = get_produtos(cursor, cat_mulheres_filhos)
            else:
                print(f"{nome} tem sexo não especificado corretamente.")

            pedido_id = gera_pedido(cursor, id, produtos)
            conn.commit()
            gera_auditoria(cursor, pedido_id, pessoa, random.random() < 0.01)
            conn.commit()
    print('Inserção de dados históricos finalizada.')
except Exception as e:
    print(f"Erro ao conectar: {e}")
finally:
    # Fecha a conexão
    if 'conn' in locals() and conn:
        cursor.close()
        conn.close()
        print("Conexão encerrada.")