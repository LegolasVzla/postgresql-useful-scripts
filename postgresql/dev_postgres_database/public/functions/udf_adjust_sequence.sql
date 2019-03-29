-- DROP FUNCTION udf_adjust_sequence);
CREATE OR REPLACE FUNCTION udf_adjust_sequence()
RETURNS INT AS
$BODY$
DECLARE
	d_seq_list record;

BEGIN

	-- If the column value is greater than the sequence
	FOR d_seq_list IN (

		WITH tmp_sequence_list AS (

			SELECT
				c.table_schema || '.'||  c.table_name table_name,
				c.column_name,
				substring(c.column_default FROM position('(' in c.column_default) + 2 FOR (position('::' in c.column_default) - (position('(' in c.column_default) + 3)) ) column_default
			FROM
				information_schema.columns c
			WHERE
				c.data_type = 'integer' 
				AND table_schema NOT IN ('pg_catalog', 'pg_toast','pgagent','information_schema') 
				AND c.column_default ~~ 'nextval%' 
				AND c.column_default ~~ '%_seq%'
			ORDER BY c.table_schema, c.table_name

		), tmp_values AS (

			SELECT
				column_default,
				(
					SELECT 
						udf_check_value('SELECT last_value FROM '|| column_default, TRUE)) sequence_value,
						coalesce((SELECT udf_check_value('SELECT max(' || column_name || ') FROM '|| table_name, TRUE)), 0) column_value
			FROM tmp_sequence_list
		)
			SELECT *
			FROM 
				tmp_values
			WHERE  
				(column_value > sequence_value) or (sequence_value > (column_value+1))
	)
	LOOP

		PERFORM udf_check_value('ALTER SEQUENCE ' ||  d_seq_list.column_default || ' RESTART WITH ' ||  (d_seq_list.column_value + 1), FALSE);

	END LOOP;

	RETURN 1;

END;

$BODY$
LANGUAGE plpgsql VOLATILE
COST 100;

ALTER FUNCTION udf_adjust_sequence()
	OWNER TO postgres;
COMMENT ON FUNCTION udf_adjust_sequence() IS 'Adjust all the Sequence which name ends with "_seq" in all the tables in all the schemas (excluding postgres)';
