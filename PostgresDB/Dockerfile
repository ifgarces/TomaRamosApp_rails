# --------------------------------------------------------------------------------------------------
# Postgresql for the Django application.
# --------------------------------------------------------------------------------------------------

ARG UBUNTU_VERSION
FROM ubuntu:${UBUNTU_VERSION}

ARG POSTGRES_VERSION

ARG DEBIAN_FRONTEND=noninteractive

# Installing PostgreSQL server
RUN apt-get update --quiet && apt-get install --quiet -y \
        wget \
        gnupg \
        ca-certificates \
        nano \
        language-pack-es \
        postgresql-${POSTGRES_VERSION}

COPY setup_db.sql .

# Configuring database
RUN /etc/init.d/postgresql start \
    && su postgres -c "psql --file=./setup_db.sql"

# Allowing all external connections
RUN echo "\
host    all     	all     0.0.0.0/0    md5 \n\
host    all         all     ::/0         md5 \n\
" >> /etc/postgresql/${POSTGRES_VERSION}/main/pg_hba.conf

COPY entrypoint.sh .
RUN chmod +x ./entrypoint.sh

ENV POSTGRES_VERSION=${POSTGRES_VERSION}

ENTRYPOINT [ "./entrypoint.sh" ]
