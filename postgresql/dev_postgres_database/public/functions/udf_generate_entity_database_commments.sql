-- DROP FUNCTION IF EXISTS public.udf_generate_entity_database_commments(character varying[]);
CREATE OR REPLACE FUNCTION public.udf_generate_entity_database_commments(param_schema_list character varying[])
  RETURNS void
  LANGUAGE 'plpgsql'
  COST 100
  VOLATILE
AS $BODY$

DECLARE

  /*
  To test:
    SELECT public.udf_generate_entity_database_commments(array['public']);
  */

  i integer;
  j RECORD;
  k RECORD;
  w RECORD;
    
  BEGIN

    -- Iterate on each schema
    FOR i IN 1 .. array_upper(param_schema_list, 1)
    LOOP

      -- Iterate on each table of the current schema
      FOR j IN (
        SELECT
          tablename
        FROM
          pg_tables
        WHERE 
          schemaname = param_schema_list[i]
      )
      LOOP

        -- Generate table comment
        RAISE NOTICE 'COMMENT ON TABLE %.% is ''<write_your_comment>''',param_schema_list[i],j.tablename;

        -- Get all the columns name of the current table
        FOR k IN (
          SELECT
            column_name
          FROM 
            information_schema.columns
          WHERE
            table_schema = 'public'
            AND 
            table_name = j.tablename
          ORDER BY
            column_name
        )
        LOOP

          -- Generate column comment
          RAISE NOTICE 'COMMENT ON COLUMN %.%.% is ''<write_your_comment>''',param_schema_list[i],j.tablename,k.column_name;

        END LOOP;

      END LOOP;        

      -- Iterate on each function of the current schema
      FOR w IN (
        SELECT 
          proname  
        FROM
          pg_catalog.pg_proc f
          INNER JOIN 
            pg_catalog.pg_namespace n ON (f.pronamespace = n.oid)
        WHERE 
          n.nspname = param_schema_list[i]
      )
      LOOP

        -- Generate function comment
        RAISE NOTICE 'COMMENT ON FUNCTION %.% is ''<write_your_comment>''',param_schema_list[i],w.proname;

      END LOOP;

    END LOOP;

END;

$BODY$;

ALTER FUNCTION public.udf_generate_entity_database_commments(character varying[]) OWNER TO postgres;