--DROP TABLE IF EXISTS temporal_schema.tbl_relation_endangered_reasons;
CREATE TABLE temporal_schema.tbl_relation_endangered_reasons (
	id_endangered_reasons_relation SERIAL,
	id_endangered_animals INTEGER NOT NULL,
	id_categories INTEGER NOT NULL,
	id_reasons INTEGER NOT NULL,
	is_active BOOLEAN DEFAULT true,
	is_deleted BOOLEAN DEFAULT false,
    last_modified_date timestamp with time zone NOT NULL,
    created_date timestamp with time zone DEFAULT NOW(),
	PRIMARY KEY (id_endangered_reasons_relation,id_categories,id_endangered_animals,id_reasons)
);
ALTER TABLE temporal_schema.tbl_relation_endangered_reasons ADD CONSTRAINT tbl_relation_endangered_reasons_tbl_reasons
	FOREIGN KEY (id_reasons) REFERENCES temporal_schema.tbl_reasons (id_reasons)
ON UPDATE CASCADE;
ALTER TABLE temporal_schema.tbl_relation_endangered_reasons ADD CONSTRAINT tbl_relation_endangered_reasons_tbl_endangered_animals
	FOREIGN KEY (id_endangered_animals,id_categories) REFERENCES temporal_schema.tbl_endangered_animals (id_endangered_animals,id_categories)
ON UPDATE CASCADE;
/*CREATE TRIGGER trigger_relation_endangered_reasons_insert BEFORE UPDATE OR DELETE ON temporal_schema.tbl_relation_endangered_reasons
	FOR EACH ROW 
		EXECUTE PROCEDURE udt_general_tables_insert();
*/