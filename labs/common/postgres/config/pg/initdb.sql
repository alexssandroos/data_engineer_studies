-- General Tests 
DO $$ begin raise notice 'Starting General Tests scripts.'; end; $$;
CREATE DATABASE general_test;
\c general_test 
CREATE TABLE test (
	id serial PRIMARY KEY,
    timestamp_field timestamp NOT NULL,
	name VARCHAR(50) NOT NULL
);
INSERT INTO test (timestamp_field, name) values (NOW(), 'Test1');
INSERT INTO test (timestamp_field, name) values (NOW(), 'Test2');
INSERT INTO test (timestamp_field, name) values (NOW(), 'Test3');
DO $$ begin raise notice 'End General Tests scripts.'; end; $$;



-- Beltrano Restore
DO $$ begin raise notice 'Starting Beltrano restore scripts.'; end; $$;
CREATE DATABASE beltrano_oltp OWNER postgres;
CREATE DATABASE beltrano_dw OWNER postgres;

\c beltrano_oltp
\i /etc/postgresql/beltrano_oltp_10k_pedidos.backup

\c beltrano_dw
\i /etc/postgresql/beltrano_dw.backup
create schema if not exists stage ;


-- airflow database
--DO $$ begin raise notice 'Starting crunchbase init scripts.'; end; $$;
--CREATE DATABASE crunchbase OWNER postgres;
--create user dbt with encrypted password 'password1234';
--grant all privileges on database crunchbase to dbt;
--grant all privileges on database postgres to dbt;
-- Connect to the target PostgreSQL database

--\c crunchbase
--\i /etc/postgresql/crunchbase.gz

-- airflow database
DO $$ begin raise notice 'Starting Airflow init scripts.'; end; $$;
create DATABASE airflow OWNER postgres;
create user airflow with encrypted password 'airflow';
grant all privileges on database airflow to airflow;

-- cube database
DO $$ begin raise notice 'Starting Cube init scripts.'; end; $$;
create DATABASE cubejs OWNER postgres;
create user cubejs with encrypted password 'cubejs';
grant all privileges on database cubejs to cubejs;
-- cube tables require id 
--ALTER TABLE beltrano_dw.f_pedidos ADD COLUMN id SERIAL;

-- metabase database
DO $$ begin raise notice 'Starting Metabase init scripts.'; end; $$;
create DATABASE metabase OWNER postgres;
create user metabase with encrypted password 'metabase';
grant all privileges on database metabase to metabase;

--airbyte database
DO $$ begin raise notice 'Starting Airbyte init scripts.'; end; $$;
create DATABASE airbytedb OWNER postgres;
create user airbyte with encrypted password 'airbyte';
grant all privileges on database airbytedb to airbyte;
ALTER USER airbyte CREATEDB;
