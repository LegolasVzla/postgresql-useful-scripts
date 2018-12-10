--DROP TABLE IF EXISTS temporal_schema.tbl_log_endangered_animals;
CREATE TABLE temporal_schema.tbl_log_endangered_animals (
	id_endangered_animals INTEGER,
	name VARCHAR(255),
	is_active BOOLEAN DEFAULT true,
	is_deleted BOOLEAN DEFAULT false,
    last_modified_date timestamp with time zone NOT NULL,
	last_modified_by CHARACTER VARYING(100),
	ip_user CHARACTER VARYING(100),
	update_or_deleted_date timestamp with time zone NOT NULL
);
ALTER TABLE temporal_schema.tbl_endangered_animals ADD CONSTRAINT tbll_endangered_animals_tb_categories
	FOREIGN KEY (id_categories) REFERENCES temporal_schema.tbl_categories (id_categories)
ON UPDATE CASCADE;