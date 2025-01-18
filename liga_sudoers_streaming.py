import sys
import time 

import psycopg2
from functions import *

from datetime import datetime

try:
    reference_date =  datetime.strptime(str(sys.argv[1]), '%Y-%m-%d')
except:
    reference_date = datetime.now()


total_registros = 10

# Definindo os parâmetros de conexão
db_config = {
    'dbname': 'liga_sudoers',
    'user': 'sudoers',    
    'password': 'password',
    'host': 'localhost',
    'port': '5434'
}

# Conectando ao banco de dados PostgreSQL
conn = psycopg2.connect(**db_config)
print('Iniciando geração de dados aleatórios para Streaming.')
# Criando um cursor para executar comandos SQL
cursor = conn.cursor()

try:
    # Loop pelos resultados
    while(True):
        print('Gerando dados para Streaming.')
        gerar_pessoas(cursor, total_registros)
        conn.commit()
        # Exemplo de consulta
        cursor.execute(f"SELECT  id, nome, sexo, dt_nasc FROM pessoas ORDER BY random() limit {total_registros};")
        pessoas = cursor.fetchall()

        cat_homens = [1,4,5,6]
        cat_homens_filhos = [1,4,5,6,7,8,9]
        cat_mulheres = [2,4,8,9]
        cat_mulheres_filhos = [1,2,3,4,7,8,9]
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

            pedido_id = gera_pedido(cursor, id, produtos, True)
            conn.commit()
            gera_auditoria(cursor, pedido_id, pessoa, random.random() < 0.05, True)
            conn.commit()
        # Fechando a conexão
        time.sleep(5)    

except Exception as e:
    print(f"Erro ao conectar: {e}")
finally:
    # Fecha a conexão
    if 'conn' in locals() and conn:
        cursor.close()
        conn.close()
        print("Conexão encerrada.")
