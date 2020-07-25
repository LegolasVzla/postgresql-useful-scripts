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

Files are contained inside of the dev_postgres_database folder, with the follow structure: dev_postgres_database -> schema -> functions.

1. dba_scripts.sql:

- Display actives connections
- Display the activity of your database
- Display connections by client_addr
- Display usaged size on disk by database
- Display usaged size of a specific table
- Display usaged size of tables by schemas

2. udf_check_value.sql, udf_adjust_sequence.sql: scripts to adjust sequences.

3. udf_kill_connections_pg3.sql, udf_kill_connections_pg4.sql: scripts used to controll the excessive number of queries windows opened in pgadmin 3 and 4.

4. useful_structure_queries.sql: several useful querys related with schemas, sequences, tables, columns, triggers, constraints, functions and pg_notify channels.

5. udf_generate_entity_database_commments: is a simple script to generate the comment template for tables, columns and functions related with a schema list that you supply.

- List schemas names
- List all sequences information
- Display all the information about an specific sequence
- List sequences comments
- List all the tables names of an schema
- List all the tables of your database with their primary keys
- List all the tables indexs 
- List all columns for a specified table
- List all columns for a specified table (another option)
- Search an specific column excluding postgres pg_catalogs
- List all the triggers
- List all the triggers of a schema
- List all the foreign keys
- List all the functions including postgres
- List all the functions of a schema
- Search (functions, tables, colums...) in all the functions (Great function!)
- List function comments of a schema
- List current channels listening
- List information for data dictionary

5. useful_postgis_queries.sql: several useful querys related with geolocation using postgis extension.

- Distance between 2 points (longitude latitude) based on WGS 84
- Get X,Y coordinates from geometry point
- Get geometry value from text (longitude latitude) 
- Find intersection based on WGS 84
- Find near by places within X km from a current position(longitude,latitude)

6. useful_fts_queries.sql: examples of how to do full text search with different case of searches, given stop words, upper or lower cases, accents, white spaces, multiple strings, incomplete strings or multiple incomplete strings. 

Contributions
-----------------------

All work to improve performance is good

Enjoy it!
