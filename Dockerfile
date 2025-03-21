# Servicio PostgreSQL
FROM postgres:latest AS postgres

# Configurar PostgreSQL
ENV POSTGRES_DB=postgres \
    POSTGRES_USER=odoo \
    POSTGRES_PASSWORD=odoo

# Crear usuario con privilegios
RUN set -eux && \
    echo "GRANT ALL PRIVILEGES ON DATABASE postgres TO odoo;" >> /docker-entrypoint-initdb.d/init.sql

# Servicio Odoo
FROM odoo:latest

# Configurar Odoo
ENV HOST=postgres \
    USER=odoo \
    PASSWORD=odoo \
    DB_NAME=postgres

# Instalar dependencias
USER root
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        python3-pip \
        libssl-dev \
        build-essential && \
    rm -rf /var/lib/apt/lists/*


# Exponer puertos
EXPOSE 8069 5432

# Volver al usuario odoo
USER odoo

# Comando para ambos servicios (requiere docker-compose)
CMD ["odoo"]
