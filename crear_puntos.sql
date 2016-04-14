
----agrego geometry column

select AddGeometryColumn ('hidrocarburos','hidrocarburos_pozos', 'the_geom', 4326, 'POINT' , 2)
update hidrocarburos.hidrocarburos_pozos set the_geom = st_geomfromtext('POINT(' || x_visor || ' ' || y_visor || ')',4326)::geometry