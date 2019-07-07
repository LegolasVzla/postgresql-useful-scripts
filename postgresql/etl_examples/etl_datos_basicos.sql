CREATE OR REPLACE FUNCTION etl_datos_basicos()
  RETURNS character varying AS
$BODY$
 DECLARE

	/*
	Resumen: destinado a migrar los datos de la bd de origen a la nueva bd. 
	Se encarga de extraer los datos de la tabla lotus_usr_exist_datos_basicos y los inserta en las tablas
	tbl_solicitante y tbl_dni
	*/
 
	nacionalidad varchar(100);
	tipo_documento2 varchar(100);
	id_solicitante2 int;
	solicitante_repetido  boolean;
	
	-- Extraccion de Datos Basicos --
	consulta cursor for select * from lotus_usr_exist_datos_basicos;
	arreglo lotus_usr_exist_datos_basicos%ROWTYPE;

	valor varchar;

  BEGIN

	FOR arreglo IN consulta LOOP

		if not exists(select id_solicitante from tbl_solicitante where id_solicitante = arreglo.usr_exist_datos_bas_id) then

			nacionalidad := arreglo.usr_exist_datos_bas_nacionalidad;
			
			-- Transformacion y Carga de Datos --
			if (nacionalidad= 'V') then
			
				tipo_documento2:= 'Cédula';
				
			elsif (nacionalidad= 'P') then
			
				tipo_documento2:= 'Pasaporte';		

			elsif (nacionalidad = 'D') then

				tipo_documento2:= 'Dni';

			elsif (nacionalidad = 'R') then

				tipo_documento2:= 'RIF';

			elsif (nacionalidad = 'E') then

				tipo_documento2:= 'Extranjero';

			end if;

			if (nacionalidad = 'V') then
			
				-- Cargado de Datos de en tbl_solicitante
				INSERT INTO tbl_solicitante (
				id_solicitante,
				cod_solicitante,
				tx_nombre,
				tx_apellido,
	--			fec_nacimiento,
				id_nacionalidad,
				id_pais		
				)
				VALUES (
				arreglo.usr_exist_datos_bas_id,
				cast(arreglo.usr_exist_datos_bas_cod_clte as int),
				arreglo.usr_exist_datos_bas_nombre,
				arreglo.usr_exist_datos_bas_apellido,
	--			arreglo.usr_exist_datos_bas_fec_nac,
				196,
				238
				);

			else
				-- Cargado de Datos de en tbl_solicitante
				INSERT INTO tbl_solicitante (
				id_solicitante,
				cod_usuario,
				tx_nombre,
				tx_apellido,
	--			fec_nacimiento,
				id_nacionalidad,
				id_pais
				) 
				VALUES (
				arreglo.usr_exist_datos_bas_id,
				cast(arreglo.usr_exist_datos_bas_cod_clte as int),
				arreglo.usr_exist_datos_bas_nombre,
				arreglo.usr_exist_datos_bas_apellido,
	--			arreglo.usr_exist_datos_bas_fec_nac,
				201,
				250
				);
				
			end if;

			-- Carga de Datos en tbl_dni
			INSERT INTO tbl_dni (
			id_tbl_dni,
			tipo_documento,
			num_documento,
			id_solicitante
			) 
			VALUES (
			arreglo.usr_exist_datos_bas_id,
			tipo_documento2,
			upper(arreglo.usr_exist_datos_bas_cedula_pasaporte),
			arreglo.usr_exist_datos_bas_id
			);

			raise notice 'Insertado el solicitante %',arreglo.usr_exist_datos_bas_id;

		else

			raise notice 'El Solicitante % % N°identidad % con el id: % ya se encuentra en la bd',arreglo.usr_exist_datos_bas_nombre, arreglo.usr_exist_datos_bas_apellido,arreglo.usr_exist_datos_bas_cedula_pasaporte,arreglo.usr_exist_datos_bas_id;

		end if;
			
	END LOOP;

	valor = 'Migración de datos basicos finalizada';
	
	RETURN valor;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
