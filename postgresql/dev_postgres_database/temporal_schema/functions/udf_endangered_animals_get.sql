-- DROP FUNCTION temporal_schema.udf_endangered_animals_get(INTEGER);

CREATE OR REPLACE FUNCTION temporal_schema.udf_endangered_animals_get(param_id_endangered_animals INTEGER)
 RETURNS character varying
 LANGUAGE plpgsql
AS $function$

DECLARE
  -- This is a comment: in this section you can declare your variables

  local_returning VARCHAR(200) = '';
    
  BEGIN        

  /* It is a suggest of a good header
  Author: 
  Creation Date:
  Review:   

  -- To Test: you can use the next line, to test this function
    SELECT temporal_schema.udf_endangered_animals_get(1);
  */

  -- This is a validation to check if the param_id_endangered_animals exist
  IF EXISTS (
    SELECT
      name
    FROM 
      temporal_schema.tbl_endangered_animals
    WHERE
      id_endangered_animals = param_id_endangered_animals
      AND
      is_active
      AND
      not is_deleted
    ) THEN

    -- You can use 'INTO STRICT' statement, to store data returned into a variable. Be carefull if your query return more than one values
    SELECT
      name INTO STRICT local_returning
    FROM 
      temporal_schema.tbl_endangered_animals
    WHERE
      id_endangered_animals = param_id_endangered_animals
      AND
      is_active
      AND
      not is_deleted;

    -- You can use 'RAISE NOTICE' statement to display messages and debug your code 
    RAISE NOTICE 'Data found';

  ELSE

    RAISE NOTICE 'Not data found';

  END IF;

    RETURN local_returning;

END;

$function$;

COMMENT ON FUNCTION temporal_schema.udf_endangered_animals_get(INTEGER) IS 'This function is used to get data from temporal_schema.udf_endangered_animals_get';
