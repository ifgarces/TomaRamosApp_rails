# --------------------------------------------------------------------------------------------------
# Postgresql for the Django application.
# --------------------------------------------------------------------------------------------------

ARG UBUNTU_VERSION
FROM ubuntu:${UBUNTU_VERSION}

ARG DEBIAN_FRONTEND=noninteractive

# Installing PostgreSQL server
RUN apt-get update --quiet && apt-get install --quiet -y \
        wget \
        gnupg \
        ca-certificates \
        nano \
        language-pack-es \
        postgresql-14

COPY setup_db.sql .

# Configuring database
RUN /etc/init.d/postgresql start \
    && su postgres -c "psql --command=\" ALTER USER postgres WITH PASSWORD 'postgres'; \"" \
    && su postgres -c "psql --file=./setup_db.sql"

# Allowing all external connections
RUN echo "\
host    all     	all     0.0.0.0/0    md5 \n\
host    all         all     ::/0         md5 \n\
" >> /etc/postgresql/14/main/pg_hba.conf

USER postgres

CMD [ "/bin/sh", "-exu", "-c", "/usr/lib/postgresql/14/bin/postgres \
    -d ${POSTGRES_LOG_LEVEL} \
    -p ${POSTGRES_PORT} \
    -h 0.0.0.0 \
    -D /var/lib/postgresql/14/main \
    -c config_file=/etc/postgresql/14/main/postgresql.conf" ]


