import random
import psycopg2
from faker import Faker

from datetime import datetime, timedelta

def gerar_pessoas(cursor, qtd):
    fake = Faker('pt_BR')
    pessoas = []
    for _ in range(qtd):
        id_pessoa = random.randint(10000000000, 99999999999)
        nome = fake.name()
        sexo = 'F' if nome.split()[0][-1] == 'a' else 'M'
        dt_nasc = fake.date_of_birth(minimum_age=18, maximum_age=60)
        created_at = datetime.now()
        pessoas.append((id_pessoa, nome, sexo, dt_nasc, created_at))

    insert_query = "INSERT INTO pessoas (id, nome, sexo, dt_nasc, created_at) VALUES (%s, %s, %s, %s, %s);"
    cursor.executemany(insert_query, pessoas)


def get_produtos(cursor, categorias):    
    query = f"SELECT id, descricao, valor_unit FROM produtos WHERE id_categoria in ({','.join(map(str, categorias))}) order by random() limit {random.randint(1, 5)};"    
    cursor.execute(query)
    produtos = cursor.fetchall()

    return produtos

def gera_pedido(cursor, pessoa, produtos, streaming: bool = False):        
    dt_venda = datetime.now() - timedelta(days=random.randint(1, 180)) if not streaming else datetime.now()
    total = sum([produto[2] for produto in produtos])  
        
    insert_query = "INSERT INTO pedidos (id_pessoa, dt_venda, valor_total) VALUES (%s, %s, %s) RETURNING id;"
    cursor.execute(insert_query, (pessoa, dt_venda, total))
    pedido_id = cursor.fetchone()[0]

    insert_itens = "INSERT INTO itens_pedidos VALUES (%s, %s, 1, %s);"
    for produto in produtos:
        id, _, valor_unit = produto                
        cursor.execute(insert_itens, (pedido_id, id, valor_unit))

    
    return pedido_id

def gera_auditoria(cursor, pedido_id, pessoa, fraude: bool = False, is_print: bool = False):
    id, _, sexo, dt_nasc = pessoa
    data_nascimento = datetime.strptime(str(dt_nasc), '%Y-%m-%d')
    idade = datetime.now().year - data_nascimento.year - ((datetime.now().month, datetime.now().day) < (data_nascimento.month, data_nascimento.day))               

    telefone = str(id)[-9:]
    
    if sexo == 'M' and idade < 35:
        geohash = random.choice(['6gyf', '6gyc', '7h2y', '7h2z', '7h2w', '75cm', '75cn'])
        dispositivo = 'Samsung'
    elif sexo == 'M' and idade >= 35:
        geohash = random.choice(['6gyf', '6gyc'])
        dispositivo = 'Samsung'
    elif sexo == 'F' and idade < 35:
        geohash = random.choice(['6gyf', '6gyc', '75cm', '75cn'])
        dispositivo = 'Iphone'
    elif sexo == 'F' and idade >= 35:
        geohash = random.choice(['7h2y', '7h2z', '7h2w'])
        dispositivo = 'Iphone'

    if fraude:
        fraude_option = random.choice(['dispositivo', 'geohash'])
        if is_print:
            print(f"\t Registro com fraude no {fraude_option} foi adicionado.")
                    
        if fraude_option == 'dispositivo':
            dispositivo = random.choice(['Xaomi', 'Motorola', 'Nokia'])
        else:    
            geohash = random.choice(['7h6v', '6v2n', '6m3p'])

    insert = f"INSERT INTO auditoria_pedidos VALUES (%s, %s, %s, %s);"
    cursor.execute(insert, (pedido_id, dispositivo, geohash, telefone))    


def cria_database(db_config):
  # Ler e executar o arquivo .sql
    sql_file_path = 'liga_sudoers.sql'
    print('Criando Database.')
    conn = psycopg2.connect(**db_config)
    cursor = conn.cursor()
    with open(sql_file_path, 'r') as sql_file:
        sql_commands = sql_file.read()
        cursor.execute(sql_commands)
        conn.commit()

    cursor.close()
    conn.close()        
    print('Database criado com sucesso!')