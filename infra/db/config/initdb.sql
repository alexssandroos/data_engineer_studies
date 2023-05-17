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

-- Beltrano Restore
DO $$ begin raise notice 'Starting Beltrano restore scripts.'; end; $$;
CREATE DATABASE beltrano_oltp OWNER postgres;
CREATE DATABASE beltrano_dw OWNER postgres;
\c beltrano_oltp
\i /etc/postgresql/beltrano_oltp_10k_pedidos.backup

\c beltrano_dw
\i /etc/postgresql/beltrano_dw.backup


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

-- metabase database
DO $$ begin raise notice 'Starting Metabase init scripts.'; end; $$;
create DATABASE metabase OWNER postgres;
create user metabase with encrypted password 'metabase';
grant all privileges on database metabase to metabase;

ALTER TABLE beltrano_dw.f_pedidos ADD COLUMN id SERIAL;