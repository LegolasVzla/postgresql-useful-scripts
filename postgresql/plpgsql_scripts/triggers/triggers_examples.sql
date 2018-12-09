CREATE TRIGGER trigger_categories_insert BEFORE UPDATE OR DELETE ON temporal_schema.tbl_categories 
	FOR EACH ROW 
		EXECUTE PROCEDURE udt_general_tables_insert();

CREATE TRIGGER trigger_categories_insert BEFORE UPDATE OR DELETE ON temporal_schema.tbl_endangered_animals
	FOR EACH ROW 
		EXECUTE PROCEDURE udt_general_tables_insert();

CREATE TRIGGER trigger_categories_insert BEFORE UPDATE OR DELETE ON temporal_schema.tbl_reasons
	FOR EACH ROW 
		EXECUTE PROCEDURE udt_general_tables_insert();

CREATE TRIGGER trigger_categories_insert BEFORE UPDATE OR DELETE ON temporal_schema.tbl_relation_endangered_reasons
	FOR EACH ROW 
		EXECUTE PROCEDURE udt_general_tables_insert();



