-- DROP DATABASE IF EXISTS dev_postgres_database;
CREATE DATABASE dev_postgres_database;

DROP SCHEMA IF EXISTS temporal_schema CASCADE;
CREATE SCHEMA temporal_schema;

DROP TABLE IF EXISTS temporal_schema.tb_categories;
CREATE TABLE temporal_schema.tb_categories (
	id_categories SERIAL NOT NULL PRIMARY KEY,
	name VARCHAR(255)
);

DROP TABLE IF EXISTS temporal_schema.tbl_endangered_animals;
CREATE TABLE temporal_schema.tbl_endangered_animals (
	id_endangered_animals SERIAL NOT NULL,
	name VARCHAR(255),
	id_categories INTEGER,
	PRIMARY KEY (id_endangered_animals,id_categories)
);

ALTER TABLE temporal_schema.tbl_endangered_animals ADD CONSTRAINT tbl_endangered_animals_tb_categories
	FOREIGN KEY (id_categories) REFERENCES temporal_schema.tb_categories (id_categories)
ON UPDATE CASCADE;

DROP TABLE IF EXISTS temporal_schema.tbl_reasons;
CREATE TABLE temporal_schema.tbl_reasons (
	id_reasons SERIAL NOT NULL PRIMARY KEY,
	description VARCHAR(255)
);

DROP TABLE IF EXISTS temporal_schema.tbl_relation_endangered_reasons;
CREATE TABLE temporal_schema.tbl_relation_endangered_reasons (
	id_endangered_reasons_relation SERIAL,
	id_endangered_animals INTEGER NOT NULL,
	id_categories INTEGER NOT NULL,
	id_reasons INTEGER NOT NULL,
	PRIMARY KEY (id_endangered_reasons_relation,id_categories,id_endangered_animals,id_reasons)
);

ALTER TABLE temporal_schema.tbl_relation_endangered_reasons ADD CONSTRAINT tbl_relation_endangered_reasons_tbl_reasons
	FOREIGN KEY (id_reasons) REFERENCES temporal_schema.tbl_reasons (id_reasons)
ON UPDATE CASCADE;

ALTER TABLE temporal_schema.tbl_relation_endangered_reasons ADD CONSTRAINT tbl_relation_endangered_reasons_tbl_endangered_animals
	FOREIGN KEY (id_endangered_animals,id_categories) REFERENCES temporal_schema.tbl_endangered_animals (id_endangered_animals,id_categories)
ON UPDATE CASCADE;


INSERT INTO temporal_schema.tb_categories (name) VALUES ('Mammals');
INSERT INTO temporal_schema.tb_categories (name) VALUES ('Reptile');

INSERT INTO temporal_schema.tbl_endangered_animals (name,id_categories) VALUES ('Bengal tiger',1);
INSERT INTO temporal_schema.tbl_endangered_animals (name,id_categories) VALUES ('Giant panda',1);
INSERT INTO temporal_schema.tbl_endangered_animals (name,id_categories) VALUES ('Green Turtle',2);
INSERT INTO temporal_schema.tbl_endangered_animals (name,id_categories) VALUES ('Hippopotamus',1);

INSERT INTO temporal_schema.tbl_reasons (description) VALUES ('Poaching');
INSERT INTO temporal_schema.tbl_reasons (description) VALUES ('Sales');
INSERT INTO temporal_schema.tbl_reasons (description) VALUES ('Sea contamination');
INSERT INTO temporal_schema.tbl_reasons (description) VALUES ('Destruction of territory');

INSERT INTO temporal_schema.tbl_relation_endangered_reasons (id_endangered_animals,id_categories,id_reasons) VALUES (1,1,1);
INSERT INTO temporal_schema.tbl_relation_endangered_reasons (id_endangered_animals,id_categories,id_reasons) VALUES (1,1,2);
INSERT INTO temporal_schema.tbl_relation_endangered_reasons (id_endangered_animals,id_categories,id_reasons) VALUES (2,1,1);
INSERT INTO temporal_schema.tbl_relation_endangered_reasons (id_endangered_animals,id_categories,id_reasons) VALUES (3,2,3);
INSERT INTO temporal_schema.tbl_relation_endangered_reasons (id_endangered_animals,id_categories,id_reasons) VALUES (4,1,1);
INSERT INTO temporal_schema.tbl_relation_endangered_reasons (id_endangered_animals,id_categories,id_reasons) VALUES (4,1,4);
