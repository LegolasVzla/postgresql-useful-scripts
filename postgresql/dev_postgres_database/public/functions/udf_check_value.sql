-- DROP FUNCTION udf_check_value(TEXT, BOOLEAN);
CREATE OR REPLACE FUNCTION udf_check_value(
	i_query TEXT,
	i_result BOOLEAN
	)
RETURNS INT AS
$BODY$
DECLARE
	d_value INT := 0;
BEGIN
	/*
	To test:
		SELECT udf_check_value('SELECT last_value FROM seqname_id_seq', TRUE);
	*/

	IF i_result THEN
		EXECUTE i_query INTO d_value;
	ELSE
		EXECUTE i_query;
	END IF;

	RETURN d_value;

END;
$BODY$
	LANGUAGE plpgsql VOLATILE
	COST 100;
ALTER FUNCTION udf_check_value(TEXT, BOOLEAN)
	OWNER TO postgres;
COMMENT ON FUNCTION udf_check_value(TEXT, BOOLEAN) IS 'Returns the last value of a sequence';



