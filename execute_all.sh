psql -U postgres -a -f ./postgresql/main_database.sql
psql -U postgres -d dev_postgres_database -a -f ./postgresql/dev_postgres_database/public/functions/udf_kill_connections_pg3.sql
psql -U postgres -d dev_postgres_database -a -f ./postgresql/dev_postgres_database/public/functions/udf_kill_connections_pg4.sql
psql -U postgres -d dev_postgres_database -a -f ./postgresql/dev_postgres_database/public/functions/udf_check_value.sql
psql -U postgres -d dev_postgres_database -a -f ./postgresql/dev_postgres_database/public/functions/udf_adjust_sequence.sql
psql -U postgres -d dev_postgres_database -a -f ./postgresql/dev_postgres_database/public/tables/places.sql
psql -U postgres -d dev_postgres_database -a -f ./postgresql/dev_postgres_database/public/data/places.sql