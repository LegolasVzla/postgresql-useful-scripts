--DROP TABLE IF EXISTS temporal_schema.tbl_log_reasons;
CREATE TABLE temporal_schema.tbl_log_reasons (
	id_reasons INTEGER,
	name VARCHAR(255),
	is_active BOOLEAN DEFAULT true,
	is_deleted BOOLEAN DEFAULT false,
    last_modified_date timestamp with time zone NOT NULL,
	last_modified_by CHARACTER VARYING(100),
	ip_user CHARACTER VARYING(100),
	update_or_deleted_date timestamp with time zone NOT NULL
);