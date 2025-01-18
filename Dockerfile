FROM python:3.9-slim

# Define o diretório de trabalho
WORKDIR /app

# Copia os arquivos necessários
COPY requirements.txt requirements.txt

# Instala os módulos Python
RUN pip install --no-cache-dir -r requirements.txt

# Copia os demais arquivos
COPY . .

# Define o comando de espera antes de rodar o script
CMD ["./wait-for-postgres.sh", "postgres_liga_sudoers", "python", "liga_sudoers_historico.py"]
