# Liga Sudoers - Dados Transacionais e Dados Dimensionais

Este repositório visa mostrar o processo trandicional de geração de dados em ambiente transacionais e ETL para ambiente analiticos. Ao subir os containeres serão:
  * 1 ambiente PostgreSQL com modelagem transacional, usando 3 forma normal (3FN)
  * 1 ambiente PostgreSQL com modelagem dimensional. usando star schema. 
  * 1 ambiente com Apache Hop para processos de ETL entre os servidores PostgreSQL. 
  * 1 ambiente com Metabase para construção de dashboards que serão usados para analytics. 
  
  Dentro do repositório teremos os scripts em Python que irão simular a entrada de dados:
  * liga_sudoers_historico.py - Gera dados históricos com pedidos com data retroativas, não gera novos produtos nem novos clientes. Gera 1% de dados que serão considerados fraude para treinamento do modelo. 
  * liga_sudoers_streaming.py - Gera dados streamind com pedidos com data atual, gera novos clientes e registra novos pedidos. Gera 5% de dados que serão considerados fraude para treinamento do modelo. 

  [Vídeo Explicativo](https://www.youtube.com/watch?v=_52m-Md9VXU)


## Estrutura da Fraude

A fraude é usada para treinar o modelo de Machine Learning que será usado para identificar fraudes em tempo real. O ambiente dimensional (DataWarehouse) extrai os dados via ETL (Apache Hop) e popula as informações em outro database para ser usado como ambiente analitico. Esse é um processo tradicional de manipulação de dados.

A fraude é encontrada no geohash (Lat/Lon) da pessoa que fez o pedido. Será considerado fraude qualquer posição geohash fora dos estados de SP, MG e RJ. Ou seja, caso a compra seja de uma posição fora dos estados, deverá ser marcada como fraude. 

A fraude é encontrar no dispositivo da pessoa que fez o pedido. Será considerado fraude qualquer pedido que tenha um dispositivo diferente dos anteriores na hora da compra. Ou seja, se a pessoas comprou anteriormente com Iphone, e agora tentou comprar com um Samsung o pedido será marcado como fraude. 

## Estrutura do Projeto

├── data_simulator
│   ├── `functions.py`: Funções reutilizáveis para manipulação de banco de dados e geração de dados.
│   ├── __init__.py
│   ├── `liga_sudoers_historico.py`: Gera dados históricos e os insere no banco de dados.
│   └── `liga_sudoers_streaming.py`: Gera dados para simulação de streaming de forma contínua.
├── datawarehouse_simulator
    ├── `datawarehouse_extern.sql`: Gera fluxos para criação do ETL externo
    ├── `datawarehouse_local.sql`: Gera fluxos para criação do ETL interno
    └── README.md: Detalhes de como executar as etapas 
├── ddl
│   ├── `liga_sudoers_dw.sql`: Script SQL para criação do banco de dados e tabelas do dimensional.
│   ├── `liga_sudoers.sql`: Script SQL para criação do banco de dados e tabelas do transacional.
│   └── `modelagem.txt`: Diagrama Entidade Relacionamento que foi desenvolvido usando o [dbdiagram.io](https://dbdiagram.io/)
└── README.md: Detalhes de como executar as etapas 
├── docker-compose.yml
├── etl_sudoers
│   ├── `move_pedidos.hpl`: Pipeline para ETL da tabelas pedidos
│   ├── `move_pessoas.hpl`: Pipeline para ETL da tabelas pessoas
│   ├── `move_produtos.hpl`: Pipeline para ETL da tabelas produtos
│   ├── `postgres_liga_sudoers_dw.json`: Conexão para banco PostgreSQL DataWahouse (OLAP)
│   └── `postgres_liga_sudoers.json`: Conexão para banco PostgreSQL Transacional (OLTP)
└── README.md: Detalhes de como executar as etapas 
├── liga_sudoers
│   ├── entrypoint_liga_sudoers.sh
│   └── entrypoint.sh
├── liga_sudoers_dw
│   ├── entrypoint_liga_sudoers_dw.sh
│   └── entrypoint.sh
├── README.md
└── Virada-AWS.excalidraw

## Perfil e responsabilidades

Perfis de profissionais e suas responsabilidades no dia a dia dos processos mostrados.
 - Database Administrator (DBA) ou Data Architect
 - Data Warehouse Specialist ou Data Architect
 - Data Engineer
 - Data Analyst ou Business Intelligence (BI) Analyst

### Database Administrator (DBA) ou Data Architect
Modelagem de Banco de Dados Transacional

    Profissional: Database Administrator (DBA) ou Data Architect
        Responsabilidades:
            Planejar e implementar a estrutura de bancos de dados relacionais.
            Garantir normalização, integridade referencial e alta performance em operações transacionais.
            Criar índices, restrições, triggers e stored procedures para otimizar operações.
            Monitorar e otimizar o desempenho do banco. 

### Data Warehouse Specialist ou Data Architect            
Modelagem Dimensional

    Profissional: Data Warehouse Specialist ou Data Architect
        Responsabilidades:
            Projetar esquemas dimensionais como Star Schema e Snowflake Schema.
            Criar tabelas de fato e dimensão para facilitar consultas analíticas.
            Trabalhar com conceitos como surrogate keys, granularidade e hierarquias.
            Garantir que os modelos atendam às necessidades de relatórios e análises.


### Data Engineer
Profissional: Data Engineer

    Responsabilidades:
        Desenvolver processos de ETL/ELT para extrair, transformar e carregar dados em Data Warehouses ou Data Lakes.
        Automação e orquestração de fluxos de dados usando ferramentas como Apache Airflow, Apache Hop, Talend ou Python.
        Integrar dados de múltiplas fontes e garantir qualidade e consistência.
        Monitorar e corrigir falhas nos pipelines para garantir alta disponibilidade.

### Data Analyst ou Business Intelligence (BI) Analyst
Criação de Dashboards

    Profissional: Data Analyst ou Business Intelligence (BI) Analyst
        Responsabilidades:
            Criar visualizações e relatórios interativos para tomada de decisão.
            Utilizar ferramentas de BI como Power BI, Tableau, Looker ou Metabase.
            Definir métricas e KPIs com base nos requisitos de negócios.
            Trabalhar diretamente com as partes interessadas para transformar dados em insights acionáveis.

## Pré-requisitos

- Python 3.x
- Biblioteca `psycopg2`
- Biblioteca `Faker`

### Instalação das dependências:
```bash
pip install psycopg2 faker
```

## Antes de Executar

### Dar permissão de execução
```bash
chmod +x liga_sudoers/*.sh liga_sudoers_dw/*.sh
```

### Instalação do Docker Compose
```bash
sudo apt update
sudo apt install docker-compose-plugin
```

### Verificação da Versão (opcional)
```bash
docker compose version
```

### Parar o PostgreSQL se estiver usando na máquina local (opcional)
```bash
sudo systemctl stop postgresql
```


## Como Executar

### Iniciar Docker pela primeira vez (somente a primeira vez que rodar o processo)
```bash
docker compose up --build
```

### Iniciar Docker pela segunda vez
```bash
docker compose up 
```


### Validar se as bases de dados foram criadas corretamente
```bash
docker exec -it postgres_liga_sudoers psql -U sudoers -d liga_sudoers -c "\dt"
docker exec -it postgres_liga_sudoers_dw psql -U sudoers -d liga_sudoers_dw -c "\dt"
```

### Parar o Docker Compose caso esteja rodando
```bash
docker compose down -v
```

## Rodando inserção dos dados

### Inserção de dados Históricos
```bash
#python3 data_simulator/liga_sudoers_historico.py <qtde_registros> 
python3 data_simulator/liga_sudoers_historico.py 100
```

`<qtde_registros>` é 10 por padrão, que é pouco, tente usar algo em torno de 1000 para gerar uma massa grande de dados. 1000 registros podem demorar até 5 minutos para gerar todos os dados. E na execução do ETL pode demorar mais tempo ainda devido a movimentação inicial do histórico, então use esse valor com sabedoria. 

### Inserção de dados Streaming (opcional)
```bash
python3 data_simulator/liga_sudoers_streaming.py 1
```

Esse python roda infinitamente, caso queira finalizá-lo será necessário executar o comando CTRL+C

## Rodar Apache Hop
### Rodar Apache Hop na interface UI
```bash
localhost:8080
ou 
127.0.0.1:8080
```
`user: cluster`
`password: cluster`


## Copie as conexões para dentro do container
Ao abrir a UI será necessário importar as conexões do acessos ao postgreSQL

```bash
docker cp etl_sudoers/postgres_liga_sudoers.json etl_scripts:/usr/local/tomcat/webapps/ROOT/config/projects/default/metadata/rdbms/postgres_liga_sudoers.json

docker cp etl_sudoers/postgres_liga_sudoers_dw.json etl_scripts:/usr/local/tomcat/webapps/ROOT/config/projects/default/metadata/rdbms/postgres_liga_sudoers_dw.json
```

### Rodar o ETl na interface UI
Abra o arquivo move_pessoas, move_produtos ou move_pedidos dentro do `/files` e execute o pipeline. Os arquivos .hpl (pipelines) estão localizados no diretório `/files`. Executar o move_pedidos por último, e executar os processos pelo menos 2 vezes seguidas. 

### Rodar Apache Hop no terminal
```bash
docker exec -it etl_scripts bash
/usr/local/tomcat/webapps/ROOT/hop-run.sh -f /files/move_pessoas.hpl --project default --runconfig local
/usr/local/tomcat/webapps/ROOT/hop-run.sh -f /files/move_produtos.hpl --project default --runconfig local
/usr/local/tomcat/webapps/ROOT/hop-run.sh -f /files/move_pedidos.hpl --project default --runconfig local
# 2x 
/usr/local/tomcat/webapps/ROOT/hop-run.sh -f /files/move_pessoas.hpl --project default --runconfig local
/usr/local/tomcat/webapps/ROOT/hop-run.sh -f /files/move_produtos.hpl --project default --runconfig local
/usr/local/tomcat/webapps/ROOT/hop-run.sh -f /files/move_pedidos.hpl --project default --runconfig local
```


### Validar o ETL (Rode o HOP pelo menos 2 vezes)
```bash
docker exec -it postgres_liga_sudoers_dw psql -U sudoers -d liga_sudoers_dw -c "SELECT * FROM dim_pessoas LIMIT 5;"
docker exec -it postgres_liga_sudoers_dw psql -U sudoers -d liga_sudoers_dw -c "SELECT * FROM dim_produtos LIMIT 5;"
docker exec -it postgres_liga_sudoers_dw psql -U sudoers -d liga_sudoers_dw -c "SELECT * FROM fato_pedidos LIMIT 5;"
```

## Datawarehouse

Leia o Readme.md para entender o processo

## Dashboards

### Criar database
```bash
localhost:3000
ou
127.0.0.1:3000

```
`user: contato@sudoers.com.br`
`senha: *liga01`


## Contribuição

Contribuições são bem-vindas! Sinta-se à vontade para abrir issues ou enviar pull requests.

## Licença

Este projeto está licenciado sob a Licença SUDOERS.

