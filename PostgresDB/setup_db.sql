\set ON_ERROR_STOP on

CREATE USER tomaramosuandes WITH
LOGIN
PASSWORD 'tomaramosuandes'
CREATEDB
NOSUPERUSER;

CREATE DATABASE tomaramosuandes_development OWNER tomaramosuandes;
CREATE DATABASE tomaramosuandes_test OWNER tomaramosuandes;
CREATE DATABASE tomaramosuandes_production OWNER tomaramosuandes;
