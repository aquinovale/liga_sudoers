#!/bin/bash
set -e

# Aguarda o PostgreSQL iniciar
echo "Iniciando o banco liga_sudoers..."
until pg_isready -h localhost -p 5432 -U sudoers; do
  echo "Aguardando o PostgreSQL iniciar..."
  sleep 5
done

# Executar o script de DDL
psql -U sudoers -d liga_sudoers -f /docker-entrypoint-initdb.d/liga_sudoers.sql

# Manter o processo principal do PostgreSQL ativo
#exec docker-entrypoint.sh postgres
