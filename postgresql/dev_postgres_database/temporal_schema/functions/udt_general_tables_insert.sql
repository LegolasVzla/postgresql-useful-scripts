--INSERT INTO temporal_schema.tbl_categories (name,last_modified_date) VALUES ('Reptile3',NOW());
--UPDATE temporal_schema.tbl_categories set name = 'Reptile2222' where id_categories = 2;

CREATE OR REPLACE FUNCTION udt_general_tables_insert() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

DECLARE

	local_columns_list_data JSON;
	local_columns_list_iterator RECORD;
	local_columns_list_auxiliar TEXT = '';
	local_columns_list_values TEXT = '';
	local_tg_table_name_auxiliar VARCHAR;

BEGIN
	-- Get the columns name list of the current triggered table in a temporal table (columns_list)
	CREATE TEMP TABLE IF NOT EXISTS columns_list (	
		column_name CHARACTER VARYING(250)
	);

	INSERT INTO columns_list(
		column_name
	)
	SELECT	
		column_name 
	FROM 
		information_schema.columns
	WHERE 
		table_schema = TG_TABLE_SCHEMA
	  	AND 
	  	table_name = TG_TABLE_NAME;

	-- Convert the columns_list in a string
	FOR local_columns_list_iterator IN (
		SELECT
			column_name
		FROM
			columns_list
	) LOOP

		local_columns_list_auxiliar = local_columns_list_auxiliar || local_columns_list_iterator.column_name || ',';

	END LOOP;

	-- Clean the last ','
	local_columns_list_auxiliar = rtrim(local_columns_list_auxiliar,',');
	RAISE NOTICE 'columns list of triggered table: %',local_columns_list_auxiliar;

	-- Generate a columns_list for the value statement of the INSERT
	local_columns_list_values = ',' || local_columns_list_auxiliar;
	local_columns_list_values = replace(local_columns_list_values, ',', ', old.');
	local_columns_list_values = ltrim(local_columns_list_values,',');
	RAISE NOTICE 'columns list values of triggered table: %',local_columns_list_values;

	local_tg_table_name_auxiliar = replace(TG_TABLE_NAME,'tbl_','tbl_log_');

	-- Detect if the trigger operation was a "DELETE" statement
	IF TG_OP = 'DELETE' THEN

		-- Make the dynamic Sql to insert in the log or history table of the current triggered table
		-- Note: remember, this part works good, only if the log or history table of the current triggered table already exists, and if it has the general structure for the log or history table (including the prefix name "tb_log". So if the structure of your log or history tables is different, you must add in the next Execute dynamic SQL, the columns according of your log or history tables.
		EXECUTE
			'INSERT INTO ' || TG_TABLE_SCHEMA || '.' || local_tg_table_name_auxiliar || ' (' || local_columns_list_auxiliar || '
				,ip_user 
				,last_modified_by
				,update_or_deleted_date
				)
			VALUES (' ||
			local_columns_list_values || '
				,inet_client_addr()
				,user
				,CURRENT_TIMESTAMP
				)';
			RETURN OLD;

	-- Detect if the trigger operation was an "UPDATE" statement
	ELSEIF TG_OP = 'UPDATE' THEN

		EXECUTE
			'INSERT INTO ' || TG_TABLE_SCHEMA || '.' || local_tg_table_name_auxiliar || ' (' || local_columns_list_auxiliar || ' 
				,ip_user 
				,last_modified_by
				,update_or_deleted_date
				)
			VALUES (' ||
				local_columns_list_values || '
				,inet_client_addr()
				,user
				,CURRENT_TIMESTAMP
				)';
			RETURN NEW;

	END IF;

	DROP TABLE IF EXISTS columns_list;

END;

$$;

ALTER FUNCTION public.udt_general_tables_insert() OWNER TO postgres;

--
-- TOC entry 6389 (class 0 OID 0)
-- Dependencies: 1702
-- Name: FUNCTION udt_general_tables_insert(); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION udt_general_tables_insert() IS 'This is a general function trigger generator, that detects changes (inserts, updates or deletes) over a table, and insert in the table log (table history) of the current triggered table';
