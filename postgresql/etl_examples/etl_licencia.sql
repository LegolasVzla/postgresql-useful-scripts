CREATE OR REPLACE FUNCTION etl_licencia()
  RETURNS character varying AS
$BODY$
 DECLARE

	/* 
	Resumen: destinado a migrar los datos de la bd de origen a la nueva bd. 
	Se encarga de extraer los datos de la tabla lotus_usr_exist_datos_exp_lic y los inserta en la tabla tbl_licencia
	*/

	d_status2 int;
	numero_licencia2 character varying(50);
	d_fecha_expedicion date;

	-- Extraccion de Datos --
	consulta3 cursor for select * from lotus_usr_exist_datos_exp_lic;
	arreglo lotus_usr_exist_datos_exp_lic%ROWTYPE;

	valor varchar;

  BEGIN

	FOR arreglo IN consulta3 LOOP

		if not exists(select id_licencia from tbl_licencia where id_licencia = arreglo.usr_exist_datos_exp_lic_id) then
		
			numero_licencia2 = arreglo.usr_exist_datos_exp_lic_numero;

			-- Transformacion y Carga de Datos --

			-- Se homologan los 3 estatus de la bd lotus, haciendo correspondencia con los estatus cargados en la bd limed
			if(arreglo.usr_exist_datos_exp_lic_estatus = '0') then -- No especificado --
				d_status2 = 0;
			elsif(arreglo.usr_exist_datos_exp_lic_estatus = '1') then -- Vigente --
				d_status2 = 1;
			elsif(arreglo.usr_exist_datos_exp_lic_estatus = '2') then -- Vencida --
				d_status2 = 2;
			end if;

			-- Se acomodan las fechas incorrectas
			if(arreglo.usr_exist_datos_exp_lic_fec_emi = '%0001-01-01 BC%') then
				d_fecha_expedicion = '0001-01-01';
			elsif(arreglo.usr_exist_datos_exp_lic_fec_emi is null) then
				d_fecha_expedicion = '0001-01-01';
			else
				d_fecha_expedicion = arreglo.usr_exist_datos_exp_lic_fec_emi;
			end if;

			INSERT INTO tbl_licencia (
			id_licencia,
			id_solicitante,
			fec_emision,
			tipo_licencia,
			status,
			numero_licencia2
			)
			VALUES (
			arreglo.usr_exist_datos_exp_lic_id,
			arreglo.usr_exist_datos_bas_id,
			d_fecha_expedicion,
			arreglo.tipo_pers_id,
			d_status2,
			upper(numero_licencia2)
			);

		else

			raise notice 'La licencia con id % ya se encuentra en la bd',arreglo.usr_exist_datos_exp_lic_id;

		end if;

		valor = 'Migración de licencias finalizada';

	END LOOP;
	
	RETURN valor;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
