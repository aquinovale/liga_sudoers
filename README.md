# Liga Sudoers - Projeto de Simulação de Dados

Este repositório contém scripts Python para geração e manipulação de dados em um banco de dados PostgreSQL. O projeto inclui simulação de um banco de dados que contém dados históricos e em tempo real de um banco transacional. 
Ao executar o liga_sudoers_historico.py o mesmo irá gerar os dados históricos, ao rodar o liga_sudoers_streaming.py o mesmo irá gerar dados em tempo real. O código está ajustado para gerar fraude em 5% para streaming e 1% para histórico sendo ou geohash ou dispositivo para cada registro inserido. 

A fraude é usada para treinar o modelo de Machine Learning que será usado para identificar fraudes em tempo real. O ambiente dimensional (DataWarehouse) extrai os dados via ETL e popula as informações em outro database para ser usado como ambiente analitico. 

## Estrutura do Projeto

- `functions.py`: Funções reutilizáveis para manipulação de banco de dados e geração de dados.
- `liga_sudoers.sql`: Script SQL para criação do banco de dados e tabelas.
- `liga_sudoers_historico.py`: Gera dados históricos e os insere no banco de dados.
- `liga_sudoers_streaming.py`: Gera dados para simulação de streaming de forma contínua.

## Pré-requisitos

- Python 3.x
- PostgreSQL
- Biblioteca `psycopg2`
- Biblioteca `Faker`

### Instalação das dependências:
```bash
pip install psycopg2 faker
```

## Configuração do Banco de Dados

O banco de dados é configurado no arquivo `functions.py`:
```python
# Configuração de conexão
 db_config = {
    'dbname': 'database_name',
    'user': 'username',
    'host': 'localhost',
    'port': '5432'
}
```
Certifique-se de ajustar essas credenciais para refletir seu ambiente.

## Antes de Executar

### Dar permissão de execução
```bash
chmod +x entrypoint_liga_sudoers.sh entrypoint_liga_sudoers_dw.sh
```

### Instalação do Docker Compose
```bash
sudo apt update
sudo apt install docker-compose-plugin
```

### Verificação da Versão
```bash
docker compose version
```

### Parar o PostgreSQL se estiver usando na máquina local
```bash
sudo systemctl stop postgresql
```


## Como Executar

### Iniciar Docker pela primeira vez
```bash
docker compose up --build
```

### Iniciar Docker pela segunda vez
```bash
docker compose up 
```


### Validar se as bases de dados foram criadas corretamente
```bash
docker exec -it postgres_liga_sudoers psql -U user -d liga_sudoers -c "\dt"
docker exec -it postgres_liga_sudoers_dw psql -U user -d liga_sudoers_dw -c "\dt"
```

### Parar o Docker Compose caso esteja rodando
```bash
docker compose down -v
```

## Rodando inserção dos dados

### Inserção de dados Históricos
```bash
python3 liga_sudoers_historico.py <qtde_registros> 
```

qtde_registros é 10 por padrão, que é pouco, tente usar algo em torno de 10000 para gerar uma massa grande de dados

### Inserção de dados Streaming
```bash
python3 liga_sudoers_streaming.py
```

Esse python roda infinitamente, caso queira finalizá-lo será necessário executar o comando CTRL+C

## Rodar Apache Hop
```bash
localhost:8080
```
user: cluster
password: cluster


Ao abrir a UI será necessário importar as conexões do acessos ao postgreSQL

## Copie as conexões para dentro do container
```bash
docker cp postgres_liga_sudoers etl_scripts:/usr/local/tomcat/webapps/ROOT/config/projects/default/metadata/rdbms/postgres_liga_sudoers.json

docker cp postgres_liga_sudoers_dw etl_scripts:/usr/local/tomcat/webapps/ROOT/config/projects/default/metadata/rdbms/postgres_liga_sudoers_dw.json
```

## Rodar o ETl
Abra o arquivo move_pessoas, move_produtos ou move_pedidos e execute o pipeline. Os arquivos .hpl (pipelines) estão localizados no diretório /files



## Contribuição

Contribuições são bem-vindas! Sinta-se à vontade para abrir issues ou enviar pull requests.

## Licença

Este projeto está licenciado sob a Licença SUDOERS.

