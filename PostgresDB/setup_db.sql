\set ON_ERROR_STOP on

-- Just in case we would like to connect to the database as superuser for debugging
ALTER USER postgres WITH
PASSWORD 'postgres';

CREATE USER tomaramosuandes WITH
LOGIN
PASSWORD 'tomaramosuandes'
CREATEDB
NOSUPERUSER;
