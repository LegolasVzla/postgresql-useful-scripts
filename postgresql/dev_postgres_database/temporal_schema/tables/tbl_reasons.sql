--DROP TABLE IF EXISTS temporal_schema.tbl_reasons;
CREATE TABLE temporal_schema.tbl_reasons (
	id_reasons SERIAL NOT NULL PRIMARY KEY,
	description VARCHAR(255),
	is_active BOOLEAN DEFAULT true,
	is_deleted BOOLEAN DEFAULT false,
    last_modified_date timestamp with time zone NOT NULL
);
/*CREATE TRIGGER trigger_reasons_insert BEFORE UPDATE OR DELETE ON temporal_schema.tbl_reasons
	FOR EACH ROW 
		EXECUTE PROCEDURE udt_general_tables_insert();
*/