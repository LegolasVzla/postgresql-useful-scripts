--DROP TABLE IF EXISTS temporal_schema.tbl_categories;
CREATE TABLE temporal_schema.tbl_categories (
	id_categories SERIAL NOT NULL PRIMARY KEY,
	name VARCHAR(255),
	is_active BOOLEAN DEFAULT true,
	is_deleted BOOLEAN DEFAULT false,
    last_modified_date timestamp with time zone NOT NULL
);
/*CREATE TRIGGER trigger_categories_insert BEFORE UPDATE OR DELETE ON temporal_schema.tbl_categories 
	FOR EACH ROW 
		EXECUTE PROCEDURE udt_general_tables_insert();
*/