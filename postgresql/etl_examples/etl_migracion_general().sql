CREATE OR REPLACE FUNCTION etl_migracion_general()
  RETURNS character varying AS
$BODY$
 DECLARE

	/* Migración de Datos usada para trasladar los datos de un proyecto del sector aeronáutico

	Para probarlo: select etl_migracion_general()
	
	- Para eliminar datos de lotus:

	delete from lotus_usr_exist_datos_basicos;	
	delete from lotus_usr_exist_datos_exp_cert;
	delete from lotus_usr_exist_datos_exp_hab;
	delete from lotus_usr_exist_datos_exp_lic;
	delete from lotus_usr_exist_descalif_med;
	
	*/

	-- Para valores de retorno
	resultado_etl_datos_basicos varchar;
	resultado_etl_exp_cert varchar;
	resultado_etl_descalificaciones varchar;
	resultado_etl_licencia varchar;
	resultado_etl_habilitaciones varchar;
	
	valor varchar;

  BEGIN
 
	resultado_etl_datos_basicos = (select etl_datos_basicos());
	resultado_etl_exp_cert = (select etl_exp_cert());
	resultado_etl_descalificaciones = (select etl_descalificacion_medica());
	resultado_etl_licencia = (select etl_licencia());
	resultado_etl_habilitaciones = (select etl_habilitacion());

	valor = 'Migración de datos finalizada';
	
	RETURN valor;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
