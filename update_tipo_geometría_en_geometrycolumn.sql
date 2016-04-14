

ALTER TABLE universidad_lujan.universidad_lujan_atlas_heliofania_abril 
 ALTER COLUMN the_geom TYPE geometry(MULTIPOLYGON, 4326) USING the_geom::geometry(MULTIPOLYGON,4326)