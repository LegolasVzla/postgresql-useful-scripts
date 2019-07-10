-- To show max databases connection allowed
SHOW max_connections;

-- To display actives connections
SELECT 
	COUNT(client_addr) 
FROM  
	pg_stat_activity;

-- To display the activity of your database
SELECT 
	* 
FROM
	pg_stat_activity 
WHERE 
	datname = 'your_database_name' 
ORDER BY 
	backend_start;

-- To display connections by client_addr
SELECT 
	client_addr,
	COUNT(client_addr) AS connecciones 
FROM 
	pg_stat_activity 
GROUP BY 
	client_addr 
ORDER BY 
	client_addr ASC;

-- To display usaged size on disk by database
SELECT 
	pg_database.datname, 
	pg_size_pretty(pg_database_size(pg_database.datname)) AS size 
FROM 
	pg_database;

-- To display usaged size of a specific table
SELECT 
	pg.relname AS "Tabla", 
	pg_size_pretty((relpages*8)::bigint*1024) 
AS "Tamaño estimado"
FROM 
	pg_class pg
WHERE 
	relname='your_table_name';

-- To display usaged size of tables by schemas
SELECT
	*,
	pg_size_pretty(total_bytes) AS total,
    pg_size_pretty(index_bytes) AS INDEX,
    pg_size_pretty(toast_bytes) AS toast,
    pg_size_pretty(table_bytes) AS TABLE
  FROM (
  	SELECT 
  		*, 
  		total_bytes-index_bytes-COALESCE(toast_bytes,0) AS table_bytes 
  	FROM (
	      SELECT 
	      	c.oid,
	      	nspname AS table_schema, 
	      	relname AS TABLE_NAME, 
	      	c.reltuples AS row_estimate, 
	      	pg_total_relation_size(c.oid) AS total_bytes, 
	      	pg_indexes_size(c.oid) AS index_bytes, 
	      	pg_total_relation_size(reltoastrelid) AS toast_bytes
          FROM 
          	pg_class c
          	LEFT JOIN 
          		pg_namespace n ON n.oid = c.relnamespace
          WHERE 
          	relkind = 'r'
          ORDER BY 
          	table_name,
          	total_bytes ASC
      	) a
) a;
