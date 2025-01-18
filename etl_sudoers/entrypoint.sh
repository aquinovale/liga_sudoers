#!/bin/bash

# Função para aguardar o Tomcat subir
wait_for_tomcat() {
  echo "Aguardando o Tomcat iniciar..."
  while ! curl -s http://localhost:8080 > /dev/null; do
    echo "Tomcat ainda não está pronto. Aguardando..."
    sleep 2
  done
  echo "Tomcat está pronto!"
}

# Aguarda o Tomcat estar acessível
wait_for_tomcat

# Move o arquivo do volume para o destino
cp /files/postgres_liga_sudoers*.json /usr/local/tomcat/webapps/ROOT/config/projects/default/metadata/rdbms/


echo "Arquivo movido com sucesso."

# Inicia o processo padrão do container
exec "$@"


