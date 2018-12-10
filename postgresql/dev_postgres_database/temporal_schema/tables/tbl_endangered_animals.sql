--DROP TABLE IF EXISTS temporal_schema.tbl_endangered_animals;
CREATE TABLE temporal_schema.tbl_endangered_animals (
	id_endangered_animals SERIAL NOT NULL,
	name VARCHAR(255),
	id_categories INTEGER,
	is_active BOOLEAN DEFAULT true,
	is_deleted BOOLEAN DEFAULT false,
    last_modified_date timestamp with time zone NOT NULL,
    created_date timestamp with time zone DEFAULT NOW(),
	PRIMARY KEY (id_endangered_animals,id_categories)
);
/*CREATE TRIGGER trigger_endangered_animals_insert BEFORE UPDATE OR DELETE ON temporal_schema.tbl_endangered_animals
	FOR EACH ROW 
		EXECUTE PROCEDURE udt_general_tables_insert();
*/