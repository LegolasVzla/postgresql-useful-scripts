CREATE OR REPLACE FUNCTION etl_exp_cert()
  RETURNS character varying AS
$BODY$
 DECLARE

	/*
	Resumen: destinado a migrar los datos de la bd de origen a la nueva bd. 
	Se encarga de extraer los datos de la tabla lotus_usr_exist_datos_exp_cert y los inserta en la tabla tbl_documento
	*/

	-- Extraccion de los datos de los Certificados de Lotus
	consulta2 cursor for  select * from lotus_usr_exist_datos_exp_cert order by usr_exist_datos_exp_cert_fec_venc desc;
	arreglo lotus_usr_exist_datos_exp_cert%ROWTYPE;

	d_num_documento varchar;
	d_fecha_expedicion date;
	d_fecha_vencimiento date;
	valor varchar;

  BEGIN

	FOR arreglo IN consulta2 LOOP

		if not exists(select id_documento from tbl_documento where id_documento = arreglo.usr_exist_datos_bas_id) then

			select num_documento into strict d_num_documento from tbl_dni where id_solicitante = arreglo.usr_exist_datos_bas_id;
				
			-- Transformacion y Carga de Datos --

			-- Se acomodan las fechas incorrectas			
			if(arreglo.usr_exist_datos_exp_cert_fec_exp = '%0001-01-01 BC%') then
				d_fecha_expedicion = '0001-01-01';
			elsif(arreglo.usr_exist_datos_exp_cert_fec_venc = '%0001-01-01 BC%') then
				d_fecha_vencimiento = '0001-01-01';
			elsif(arreglo.usr_exist_datos_exp_cert_fec_exp is null) then
				d_fecha_expedicion = '0001-01-01';
			elsif(arreglo.usr_exist_datos_exp_cert_fec_venc is null) then
				d_fecha_vencimiento = '0001-01-01';
			else
				d_fecha_expedicion = arreglo.usr_exist_datos_exp_cert_fec_exp;
				d_fecha_vencimiento = arreglo.usr_exist_datos_exp_cert_fec_venc;
			end if;

			INSERT INTO tbl_documento (
			id_documento,
			solicitante,
			num_documento2,
			clase,
			fec_emic,
			fec_vcto,
			tipo_documento
			)
			VALUES (
			arreglo.usr_exist_datos_exp_cert_id,
			arreglo.usr_exist_datos_bas_id,
			upper(d_num_documento),
			arreglo.clase_cert_med_id,
			d_fecha_expedicion,
			d_fecha_vencimiento,
			2
			);

			raise notice 'Insertando el Documento: %',arreglo.usr_exist_datos_exp_cert_id;
		
		else

			raise notice 'El Documento con id % ya se encuentra en la bd',arreglo.usr_exist_datos_exp_cert_id;

		end if;
		
	END LOOP;

	valor = 'Migración de expedientes de certificados finalizada';

	RETURN valor;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;