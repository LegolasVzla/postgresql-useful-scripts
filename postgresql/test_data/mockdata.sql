-- DROP DATABASE IF NOT EXISTS dev_postgres_database;
CREATE DATABASE dev_postgres_database;

DROP SCHEMA IF EXISTS temporal_schema CASCADE;
CREATE SCHEMA temporal_schema;

DROP TABLE IF EXISTS temporal_schema.tbl_endangered_animals;
CREATE TABLE temporal_schema.tbl_endangered_animals (
	id_endangered_animals SERIAL NOT NULL PRIMARY KEY,
	name VARCHAR(255)
)
;

INSERT INTO temporal_schema.tbl_endangered_animals (name) VALUES ('Bengal tiger');
INSERT INTO temporal_schema.tbl_endangered_animals (name) VALUES ('Giant panda');
INSERT INTO temporal_schema.tbl_endangered_animals (name) VALUES ('Green Turtle');
INSERT INTO temporal_schema.tbl_endangered_animals (name) VALUES ('Hippopotamus');

DROP TABLE IF EXISTS temporal_schema.tbl_reasons;
CREATE TABLE temporal_schema.tbl_reasons (
	id_reasons SERIAL NOT NULL PRIMARY KEY,
	description VARCHAR(255)
)
;

INSERT INTO temporal_schema.tbl_reasons (description) VALUES ('Poaching');
INSERT INTO temporal_schema.tbl_reasons (description) VALUES ('Sales');
INSERT INTO temporal_schema.tbl_reasons (description) VALUES ('Sea contamination');
INSERT INTO temporal_schema.tbl_reasons (description) VALUES ('Destruction of territory');

DROP TABLE IF EXISTS temporal_schema.tbl_relation_endangered_reasons;
CREATE TABLE temporal_schema.tbl_relation_endangered_reasons (
	id_endangered_reasons_relation SERIAL NOT NULL PRIMARY KEY,
	id_endangered_animals INTEGER,
	id_reasons INTEGER
)
;

ALTER TABLE temporal_schema.tbl_relation_endangered_reasons add CONSTRAINT tbl_relation_endangered_reasons_tbl_endangered_animals
	FOREIGN KEY (id_endangered_animals) REFERENCES temporal_schema.tbl_endangered_animals (id_endangered_animals)
ON UPDATE CASCADE
;

ALTER TABLE temporal_schema.tbl_relation_endangered_reasons add CONSTRAINT tbl_relation_endangered_reasons_tbl_reasons
	FOREIGN KEY (id_reasons) REFERENCES temporal_schema.tbl_reasons (id_reasons)
ON UPDATE CASCADE
;

INSERT INTO temporal_schema.tbl_relation_endangered_reasons (id_endangered_animals,id_reasons) VALUES (1,1);
INSERT INTO temporal_schema.tbl_relation_endangered_reasons (id_endangered_animals,id_reasons) VALUES (1,2);
INSERT INTO temporal_schema.tbl_relation_endangered_reasons (id_endangered_animals,id_reasons) VALUES (2,1);
INSERT INTO temporal_schema.tbl_relation_endangered_reasons (id_endangered_animals,id_reasons) VALUES (3,3);
INSERT INTO temporal_schema.tbl_relation_endangered_reasons (id_endangered_animals,id_reasons) VALUES (4,1);
INSERT INTO temporal_schema.tbl_relation_endangered_reasons (id_endangered_animals,id_reasons) VALUES (4,4);
