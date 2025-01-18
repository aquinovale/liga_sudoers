#!/bin/bash
set -e

host="$1"
shift
cmd="$@"

apt-get update && apt-get install -y postgresql-client

until pg_isready -h "$host" -p 5432 -U sudoers; do
  >&2 echo "PostgreSQL ainda não está pronto - aguardando..."
  sleep 5
done

>&2 echo "PostgreSQL está pronto - executando comando."

echo $cmd
exec $cmd
