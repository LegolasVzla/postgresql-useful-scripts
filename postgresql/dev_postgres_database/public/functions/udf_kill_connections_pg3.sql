-- DROP FUNCTION udf_kill_connections_pg3(INTEGER);
CREATE OR REPLACE FUNCTION udf_kill_connections_pg3(param_max_allowed_connections INTEGER) 
   RETURNS TEXT AS
$BODY$

   DECLARE  

/*

   Author: Manuel Carrero and Simon Cedeno
   Creation Date: 2018

   To test:
   SELECT udf_kill_connections_pg3(2);

*/

   i RECORD;
   local_connections_killed INTEGER;
   local_returning_message VARCHAR;

   BEGIN
      
      local_connections_killed = 0;
      local_returning_message = '';

      FOR i IN (
         SELECT
            psa.pid
         FROM
            pg_stat_activity psa,
            (
            SELECT 
               application_name, 
               client_addr, 
               COUNT(client_addr) AS quant 
            FROM 
               pg_stat_activity 
            GROUP BY 
               application_name,
               client_addr 
            HAVING
               COUNT(client_addr) > param_max_allowed_connections
            ) AS connections
         WHERE
            psa.application_name IN ('pgAdmin III - Query Tool')
            AND psa.client_addr = connections.client_addr
         )
      LOOP    

         PERFORM (SELECT pg_terminate_backend(i.pid));
         local_connections_killed = local_connections_killed + 1;
         
      END LOOP;  

      IF (local_connections_killed = 0) THEN
         
         local_returning_message = 'Not found connections to Kill.';
      
      RETURN local_returning_message;
         
         ELSE
      
      local_returning_message = 'Connections Killed, you probably will not see this message...';
      
         RETURN local_returning_message;

      END IF;

   END;

$BODY$
LANGUAGE plpgsql VOLATILE
COST 100;

COMMENT ON FUNCTION udf_kill_connections_pg3(INTEGER) IS 'This function is used to kill a determinate number of pgAdmin III connections, to prevent excessive windows opened.';
