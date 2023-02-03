#!/bin/bash -exu

# Handling permissions due Docker volume
chown -R postgres:postgres /var/lib/postgresql/${POSTGRES_VERSION}/main
chmod -R 700 /var/lib/postgresql/${POSTGRES_VERSION}/main

su postgres -c "/usr/lib/postgresql/${POSTGRES_VERSION}/bin/postgres \
    -d ${POSTGRES_LOG_LEVEL} \
    -p ${POSTGRES_PORT} \
    -h 0.0.0.0 \
    -D /var/lib/postgresql/${POSTGRES_VERSION}/main \
    -c config_file=/etc/postgresql/${POSTGRES_VERSION}/main/postgresql.conf"
