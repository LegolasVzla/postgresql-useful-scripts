CREATE OR REPLACE FUNCTION etl_descalificacion_medica()
  RETURNS character varying AS
$BODY$
 DECLARE


	/*
	Resumen: destinado a migrar los datos de la bd de origen a la nueva bd.
	Se encarga de extraer los datos de la tabla lotus_usr_exist_descalif_med y los inserta en la tabla tbl_descalificacion_medica
	ademas, actualiza el estatus_solicitante en la tabla tbl_documento asociados a todos los documentos correspondientes
	al respectivo solicitante.
	*/
  
	-- Extraccion de Datos de Descalificaciones Medicas--
	consulta5 cursor for select * from lotus_usr_exist_descalif_med;
	arreglo lotus_usr_exist_descalif_med%ROWTYPE;

	arreglo_doc record;

	valor varchar;

  BEGIN
	
	FOR arreglo IN consulta5 LOOP

		-- Se verifica si ya existe el registro en la base de datos
		if not exists(select id_descalificacion_lotus from tbl_descalificacion_medica where id_descalificacion_lotus = arreglo.usr_exist_descalif_med_id) then

			-- Se aplican las descalificaciones medicas a los correspondientes certificados (cap o cma) asociados
			if (arreglo.tipo_descalif_med_id = 1) then

				update tbl_documento set descalificacion_medica = true, status_solicitante = 21, tx_motivo = arreglo.usr_exist_descalif_med_motivo where solicitante = arreglo.usr_exist_datos_bas_id;

			elsif (arreglo.tipo_descalif_med_id = 2) then

				update tbl_documento set descalificacion_medica = true, status_solicitante = 20, tx_motivo = arreglo.usr_exist_descalif_med_motivo where solicitante = arreglo.usr_exist_datos_bas_id;

			end if;

			FOR arreglo_doc IN select id_documento,solicitante from tbl_documento where solicitante = arreglo.usr_exist_datos_bas_id LOOP

				if (arreglo_doc.solicitante = arreglo.usr_exist_datos_bas_id) then
					-- Transformacion y Carga de Datos --
					INSERT INTO tbl_descalificacion_medica (
					id_descalificacion_lotus,
					documento,
					tipo_descalif_medica,
					motivo
					)
					VALUES (
					arreglo.usr_exist_descalif_med_id,
					arreglo_doc.id_documento,
					arreglo.tipo_descalif_med_id,
					arreglo.usr_exist_descalif_med_motivo
					);

					raise notice 'Inserte la descalificacion %, el documento fue % y el solicitante en desc fue %',arreglo.usr_exist_descalif_med_id,arreglo_doc.id_documento,arreglo.usr_exist_datos_bas_id;
		
				end if;

			end loop;

		else

			raise notice 'La descalificacion con id % ya se encuentra en la bd',arreglo.usr_exist_descalif_med_id;

		end if;

		valor = 'Migración de descalificaciones medicas finalizada';

	END LOOP;

	RETURN valor;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
