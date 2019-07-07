CREATE OR REPLACE FUNCTION etl_habilitacion()
  RETURNS character varying AS
$BODY$
 DECLARE


	/*
	Resumen: destinado a migrar los datos de la bd de origen a la nueva bd. 
	Se encarga de extraer los datos de la tabla lotus_usr_exist_datos_exp_hab y los inserta en la tabla tbl_habilitacion
	*/

	d_funcion integer;
--	d_clase integer;
--	d_tipo integer;
	d_verificar_tipo boolean;
	d_verificar_clase boolean;
	d_fecha_expedicion date;
	d_fecha_vencimiento date;	

	-- Extraccion de Datos --
	consulta4 cursor for select * from lotus_usr_exist_datos_exp_hab;
	arreglo lotus_usr_exist_datos_exp_hab%ROWTYPE;

	i record;
	
	valor varchar;

  BEGIN
	
	FOR arreglo IN consulta4 LOOP

		if not exists(select id_habilitacion from tbl_habilitacion where id_habilitacion = arreglo.usr_exist_datos_exp_hab_id) then				
			for i in select usr_exist_datos_exp_lic_id from lotus_usr_exist_datos_exp_lic where usr_exist_datos_exp_lic_id = arreglo.usr_exist_datos_exp_lic_id loop

				-- Se verifica si la habilitacion es de clase
				if (arreglo.tipo_habilitacion_id = 1) then
							d_verificar_clase = true;
							d_verificar_tipo = false;

				-- Se verifica si la habilitacion es de tipo				
				else
							d_verificar_tipo = true;
							d_verificar_clase = false;

				end if;

				-- Transformacion y Carga de Datos --

				-- Se acomodan las fechas incorrectas
				if(arreglo.usr_exist_datos_exp_hab_fec_exp = '%0001-01-01 BC%') then
					d_fecha_expedicion = '0001-01-01';
				elsif(arreglo.usr_exist_datos_exp_hab_fec_venc = '%0001-01-01 BC%') then
					d_fecha_vencimiento = '0001-01-01';
				elsif(arreglo.usr_exist_datos_exp_hab_fec_exp is null) then
					d_fecha_expedicion = '0001-01-01';
				elsif(arreglo.usr_exist_datos_exp_hab_fec_venc is null) then
					d_fecha_vencimiento = '0001-01-01';
				else
					d_fecha_expedicion = arreglo.usr_exist_datos_exp_hab_fec_exp;
					d_fecha_vencimiento = arreglo.usr_exist_datos_exp_hab_fec_venc;
				end if;

				if (arreglo.tipo_habilitacion_id = 1) then

					INSERT INTO tbl_habilitacion (
					id_habilitacion,
					clase,
					tipo,
					desc_habilitacion,
					fec_habilitacion,
					fec_vencimiento,
					funcion,
					tipo_licencia,
					categoria,
					verificar_clase,
					verificar_tipo
					)
					VALUES (
					arreglo.usr_exist_datos_exp_hab_id,
					1000000,
					1000000,
					'No Especificado',
					d_fecha_expedicion,
					d_fecha_vencimiento,
					d_funcion,
					arreglo.usr_exist_datos_exp_lic_id,
					100,
					d_verificar_clase,
					d_verificar_tipo
					);

					raise notice 'Inserte la habilitacion % y es de Clase',arreglo.usr_exist_datos_exp_hab_id;				

				elsif (arreglo.tipo_habilitacion_id = 2) then

					-- Transformacion y Carga de Datos --
					INSERT INTO tbl_habilitacion (
					id_habilitacion,
					clase,
					tipo,
					desc_habilitacion,
					fec_habilitacion,
					fec_vencimiento,
					funcion,
					tipo_licencia,
					categoria,
					verificar_clase,
					verificar_tipo
					)
					VALUES (
					arreglo.usr_exist_datos_exp_hab_id,
					1000000,
					1000000,
					'No Especificado',
					d_fecha_expedicion,
					d_fecha_vencimiento,
					d_funcion,
					arreglo.usr_exist_datos_exp_lic_id,
					100,
					d_verificar_clase,
					d_verificar_tipo
					);

					raise notice 'Inserte la habilitacion % y es de Tipo',arreglo.usr_exist_datos_exp_hab_id;

				end if;

			END LOOP;

		else

			raise notice 'La habilitacion con id % ya se encuentra en la bd',arreglo.usr_exist_datos_exp_hab_id;

		end if;


	END LOOP;

	valor = 'Migración de habilitaciones finalizada';

	RETURN valor;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
