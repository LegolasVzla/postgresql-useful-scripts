-- PostGIS tests

-----------------------------------------------
-- ABOUT INSTALLATION
-----------------------------------------------

-- Default installation
CREATE EXTENSION postgis;

/*
-- See more about the installation and aditional extensions here:

http://postgis.net/install/

https://postgis.net/docs/postgis_installation.html#idm559

*/

-----------------------------------------------
-- THINGS YOU SHOULD KNOW RELATED WITH GEOLOCALIZATION AND BEFORE TO WORK WITH POSTGIS
-----------------------------------------------

/*
-- WGS 84 (World Geodetic System 1984)
https://es.wikipedia.org/wiki/WGS84

-- What are EPSG / SRID codes and their link with PostGIS
https://mappinggis.com/2016/04/los-codigos-epsg-srid-vinculacion-postgis/

-- Spatial reference system
https://en.wikipedia.org/wiki/Spatial_reference_system

-- Introduction to Spatial References (See 4326 - GPS section)
https://developers.arcgis.com/documentation/core-concepts/spatial-references/

-- Reverse Geocoding
https://en.wikipedia.org/wiki/Reverse_geocoding

-- Admin level reference (useful for reverse geocoding queries, not only for PostGIS)
https://wiki.openstreetmap.org/wiki/Nominatim/Development_overview#Country_to_street_level

-- Nearest-Neighbour Searching
https://postgis.net/workshops/postgis-intro/knn.html

*/

-----------------------------------------------
-- ABOUT DOCUMENTATION
-----------------------------------------------

/*

-- Official Documentation
http://postgis.net/docs/

-- PostGIS 2.5.3dev Manual
http://postgis.net/stuff/postgis-2.5.pdf

-- PostGIS reference for functions description
http://postgis.net/docs/reference.html

-- FAQ:
https://postgis.net/docs/PostGIS_FAQ.html

http://postgis.net/2013/08/30/tip_ST_Set_or_Transform/

-- PostGIS official repository:
https://trac.osgeo.org/postgis/

https://github.com/postgis/postgis

-- pgRouting official repository
https://github.com/pgRouting/pgrouting

*/

-----------------------------------------------
-- USEFUL QUERIES
-----------------------------------------------

-- Adding a geometry columns:
ALTER TABLE <your_table>
	ADD COLUMN geom geometry(Geometry,4326);

ALTER TABLE <your_table>
	ADD COLUMN position geometry(Point,4326);

-- Traduce your lat and long columns in a geometry point based on WGS 84
UPDATE <your_table> 
	SET <your_geometry_column> = ST_SetSRID(ST_MakePoint(<your_long_column>,<your_lat_column>),4326);

-- Distance between 2 points (longitude latitude) based on WGS 84
SELECT ST_Distance(
  ST_GeometryFromText('POINT(-118.4079 33.9434)', 4326), -- Los Angeles (LAX)
  ST_GeometryFromText('POINT(2.5559 49.0083)', 4326)     -- Paris (CDG)
  );

-- Get X,Y coordinates from geometry point
SELECT 
	ST_X(<your_geometry_column>) latitude, 
	ST_Y(<your_geometry_column>) longitude, 
	ST_AsText(<your_geometry_column>) 
FROM 
	<your_table>;

-- Get geometry value from text (longitude latitude) 
SELECT 
	ST_GeogFromText('SRID=4267;POINT(-77.0092 38.889588)');

-- Get geometry value from text (longitude latitude)
SELECT 
	ST_Transform(<your_table>.<your_geometry_column>,4269) 
FROM 
	<your_table>;

-- Find intersection based on WGS 84
SELECT 
	<some_colums> 
FROM 
	<your_table> 
WHERE 
	ST_intersects(ST_GeographyFromText('SRID=4326;POINT(' || <your_table>.<your_long_column> || ' ' || <your_table>.<your_lat_column> || ')'), <your_table>.<your_geometry_column>)

-- Find near by places within 5 km from a current position(longitude,latitude)
SELECT 
	*
FROM
	<your_table>
WHERE
	ST_DistanceSphere("<your_table>"."<your_geometry_position_column>", ST_GeomFromEWKB(ST_MakePoint(<your_long_column>,<your_lat_column>)::bytea)) <= 5000.0

-- Get the first 5 nearest records disregard (<->) how far the are away from the current location (latitude and longitude as a parameters)
SELECT 
	* 
FROM 
	<your_table>
ORDER BY 
		<your_table>.<your_geometry_column> <-> ST_SetSRID(ST_MakePoint(param_lng,param_lat),4326) LIMIT 5;
