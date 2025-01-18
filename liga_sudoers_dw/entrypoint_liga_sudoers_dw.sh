#!/bin/bash
set -e

# Inicia o PostgreSQL em segundo plano
docker-entrypoint.sh postgres &

# Aguarda o PostgreSQL estar pronto
until pg_isready -h localhost -p 5432 -U sudoers; do
  echo "Aguardando o PostgreSQL iniciar..."
  sleep 5
done

# Executa o script SQL atualizado
psql -U sudoers -f /docker-entrypoint-initdb.d/liga_sudoers_dw.sql

# Mantém o processo principal do PostgreSQL rodando
wait