# postgresql-useful-scripts

This a repository for useful PostgreSQL scripts and sql querys

## Use

Give permissions to execute_all.sh file:

	chmod +x execute_all.sh

Login as a postgres user:

	sudo -i -u postgres

And execute the execute_all.sh file:

	./execute_all.sh

## Structure:

* dev_postgres_database folder:

Files are contained inside of the dev_postgres_database folder, with the below structure:

a) schema -> useful_queries: 

- dba_scripts.sql: some dba monitoring querys.

- useful_structure_queries.sql: several useful querys related with schemas, sequences, tables, columns, triggers, constraints, functions and pg_notify channels.

b) schema -> functions: several PL/PL/PgSQL functions with useful code (e.g: generating queries with tree json format, killing connections in pgadmin and more).

c) schema -> tables: examples tables to use in the plpgsql_scripts.

d) schema -> data: mock data to use in the plpgsql_scripts.

* etl_examples folder:

Some etl examples developed in PL/PgSQL, with useful code (e.g cursors, data cleaning and more)

Contributions
-----------------------

All work to improve performance is good

Enjoy it!
