-----------------------------------------------
-- RELATED WITH SCHEMAS
-----------------------------------------------

-- To list schemas names
SELECT 
  n.nspname 
FROM 
  pg_namespace n 
ORDER BY 
  n.nspname ;

-----------------------------------------------
-- RELATED WITH SEQUENCES
-----------------------------------------------

-- To list all sequences information
SELECT
  *
FROM
  information_schema.sequences
ORDER BY
  sequence_schema;

-- Display all the information about an specific sequence
SELECT 
  * 
FROM 
  your_schema_name.your_sequence_name;

-- To list sequences comments
SELECT 
  c.relname AS "sequence_name", 
  CASE WHEN c.relkind = 'S' THEN 'sequence' END AS "type",
  pg_get_userbyid(c.relowner) AS "owner", 
  t.spcname AS tspace, 
  n.nspname AS "schemaname",
  d.description AS "comment"
FROM 
  pg_class AS c
   LEFT JOIN pg_namespace n ON n.oid = c.relnamespace
   LEFT JOIN pg_tablespace t ON t.oid = c.reltablespace
   LEFT JOIN pg_description AS d ON (d.objoid = c.oid
   AND d.objsubid = 0)
WHERE 
  c.relkind IN('S')
  AND d.description > ''
ORDER BY 
  n.nspname, c.relname ;

/* 
Note: depENDing of the value of "pg_class.relkind", you could query different objects: 
  r = ordinary table, 
  i = index, 
  S = sequence, 
  v = view, 
  m = materialized view, 
  c = composite type, 
  t = TOAST table, 
  f = foreign table
- More information in: 
  https://www.postgresql.org/docs/9.3/static/catalog-pg-class.html
*/

-----------------------------------------------
-- RELATED WITH TABLES
-----------------------------------------------

-- To list all the tables names of an schema
SELECT 
  tablename 
FROM 
  pg_tables
WHERE 
  schemaname = 'public';

-- To list all the tables of your database with their primary keys
SELECT 
  tc.table_schema,
  tc.table_name,
  kc.column_name
FROM
  information_schema.table_constraints tc,
  information_schema.key_column_usage kc
WHERE
  tc.constraint_type = 'PRIMARY KEY'
  AND kc.table_name = tc.table_name 
  AND kc.table_schema = tc.table_schema
  AND kc.constraint_name = tc.constraint_name
ORDER BY 1, 2;

-- To list all the tables indexs 
SELECT 
  * 
FROM 
  pg_indexes 
WHERE 
  schemaname != 'pg_catalog' 
ORDER BY 
  schemaname,
  tablename;

-----------------------------------------------
-- RELATED WITH COLUMNS
-----------------------------------------------

-- To search an specific column excluding postgres pg_catalogs
 WITH temp_table AS (

  SELECT 
    c.relname AS datname,
    n.nspname
  FROM
    pg_catalog.pg_class c
  LEFT JOIN pg_catalog.pg_user u ON
    u.usesysid = c.relowner
  LEFT JOIN pg_catalog.pg_namespace n ON
     n.oid = c.relnamespace
  WHERE
    c.relkind IN ('r','') AND
    n.nspname NOT IN ('pg_catalog', 'pg_toast', 'information_schema')
  ORDER BY datname ASC

), tem_aux_table AS (

  SELECT DISTINCT
    temp_table.nspname AS Schema_Name,
    pg_tables.tablename,
    pg_attribute.attname AS field--,
  FROM
    temp_table,
    pg_tables,
    pg_class
  JOIN pg_attribute ON
    pg_class.oid = pg_attribute.attrelid 
    AND pg_attribute.attnum > 0
  LEFT JOIN pg_constraint ON
    pg_constraint.contype = 'p'::"char"
    AND pg_constraint.conrelid = pg_class.oid
    AND (pg_attribute.attnum = ANY (pg_constraint.conkey))
  LEFT JOIN pg_constraint AS pc2 ON
    pc2.contype = 'f'::"char"
    AND pc2.conrelid = pg_class.oid
    AND (pg_attribute.attnum = ANY (pc2.conkey))
  WHERE
    pg_class.relname = pg_tables.tablename
    AND pg_tables.tableowner = "current_user"()
    AND pg_attribute.atttypid <> 0::oid
    AND tablename = temp_table.datname
    AND pg_attribute.attname = 'your_column_name'
  ORDER BY field ASC

)

  SELECT *
  FROM tem_aux_table

;

-----------------------------------------------
-- RELATED WITH TRIGGERS
-----------------------------------------------

-- To list all the triggers
SELECT
  ns.nspname||'.'||tbl.relname AS trigger_table,
  trg.tgname AS "trigger_name",
    CASE trg.tgtype::INTEGER & 66
        WHEN 2 THEN 'BEFORE'
        WHEN 64 THEN 'INSTEAD OF'
        ELSE 'AFTER'
    END AS "action_timing",
   CASE trg.tgtype::INTEGER & cast(28 AS int2)
     WHEN 16 THEN 'UPDATE'
     WHEN 8 THEN 'DELETE'
     WHEN 4 THEN 'INSERT'
     WHEN 20 THEN 'INSERT, UPDATE'
     WHEN 28 THEN 'INSERT, UPDATE, DELETE'
     WHEN 24 THEN 'UPDATE, DELETE'
     WHEN 12 THEN 'INSERT, DELETE'
   END AS trigger_event,
   obj_description(trg.oid) AS remarks,
     CASE
      WHEN trg.tgenabled='O' THEN 'ENABLED'
        ELSE 'DISABLED'
    END AS status,
    CASE trg.tgtype::INTEGER & 1
      WHEN 1 THEN 'ROW'::TEXT
      ELSE 'STATEMENT'::TEXT
    END AS trigger_level
FROM 
  pg_trigger trg
 JOIN pg_class tbl ON trg.tgrelid = tbl.oid
 JOIN pg_namespace ns ON ns.oid = tbl.relnamespace
WHERE 
  trg.tgname not LIKE 'RI_ConstraintTrigger%'
  AND trg.tgname not LIKE 'pg_sync_pg%';

-- To list all the triggers of a schema
SELECT 
  event_object_table AS "trigger_table",
  trigger_name,
  action_timing,
  event_manipulation AS "trigger_event",
  action_statement
FROM  
  information_schema.triggers
WHERE 
  event_object_table IN (
    SELECT 
      tablename 
    FROM 
      pg_tables 
    WHERE
      schemaname = 'your_schema_name'
  )
ORDER BY 
  event_object_table,
  event_manipulation;

-----------------------------------------------
-- RELATED WITH FOREIGN AND PRIMARY KEYS
-----------------------------------------------

-- To list all the foreign keys
SELECT
    att2.attname AS "child_column",
    cl.relname AS "parent_table",
    att.attname AS "parent_column",
    conname AS "foreign_key_name"
FROM
   (SELECT
        unnest(con1.conkey) AS "parent",
        unnest(con1.confkey) AS "child",
        con1.confrelid,
        con1.conrelid,
        con1.conname
    FROM
        pg_class cl
        JOIN pg_namespace ns ON cl.relnamespace = ns.oid
        JOIN pg_constraint con1 ON con1.conrelid = cl.oid
    WHERE
--        cl.relname = 'your_table_name' AND  -- To filter by table
--        ns.nspname = 'your_schema_name' AND   -- To filter by schema
        con1.contype = 'f'
   ) con
   JOIN pg_attribute att ON
       att.attrelid = con.confrelid
       AND att.attnum = con.child
   JOIN pg_class cl ON
       cl.oid = con.confrelid
   JOIN pg_attribute att2 ON
       att2.attrelid = con.conrelid
       AND att2.attnum = con.parent

-----------------------------------------------
-- RELATED WITH FUNCTIONS
-----------------------------------------------

-- To list all the functions including postgres
SELECT
  proname AS "FUNCTION NAME",
  proargnames AS "PARAMETER NAMES",
  pg_catalog.oidvectortypes(proargtypes) AS "PARAMETER TYPES"
FROM 
  pg_proc f
  INNER JOIN 
    pg_catalog.pg_namespace n ON (f.pronamespace = n.oid);

-- To list all the functions of a schema
SELECT 
  proname AS "FUNCTION NAME",
  proargnames AS "PARAMETER NAMES",
  pg_get_functiondef(f.oid) AS "BODY",
  pg_catalog.oidvectortypes(proargtypes) AS "PARAMETER TYPES"  
FROM
  pg_catalog.pg_proc f
  INNER JOIN 
    pg_catalog.pg_namespace n ON (f.pronamespace = n.oid)
WHERE 
  n.nspname = 'your_schema_name';

-- To search (functions, tables, colums...) in all the functions
SELECT
  quote_ident(n.nspname) AS Schema,
  p.proname AS Funcion
--  p.proargnames AS "Parameters",
--  p.prosrc AS "Body Function",
--  r.rolname AS "Owner",
--  l.lanname AS "Language"
FROM
  pg_proc p
  LEFT JOIN pg_catalog.pg_namespace n ON
    n.oid = p.pronamespace
  LEFT JOIN pg_catalog.pg_language l ON
    l.oid = p.prolang
  JOIN pg_catalog.pg_roles r ON
    r.oid = p.proowner
WHERE
  lower(p.prosrc) LIKE '%your_column_name%'
ORDER BY 
  Schema, 
  FUNCION;

-- To list function comments of a schema
SELECT 
  p.proname AS funcname,
  d.description
FROM 
  pg_proc p
  INNER JOIN 
    pg_namespace n ON n.oid = p.pronamespace
  LEFT JOIN 
    pg_description AS d ON (d.objoid = p.oid )
WHERE 
  n.nspname = 'your_schema_name'
ORDER BY 
  n.nspname, p.proname ;


-----------------------------------------------
-- RELATED WITH CHANNELS
-----------------------------------------------

-- To list current channels listening
SELECT
    pid,
    backend_start,
    query channel,
    query_start,
    state_change
FROM
    pg_stat_activity
WHERE
    datname = 'your_database_name'
    AND query
    LIKE '%LISTEN%'
ORDER BY backend_start;

