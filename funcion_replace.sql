

UPDATE r318.r318_instalaciones
SET long = replace("longitud",',','.')::double precision

UPDATE r318.r318_instalaciones
SET lat = replace("latitud",',','.')::double precision



-----o bien se puede usar la siguiente, lo unico que no deja poner un where



ALTER TABLE r318.r318_instalaciones
ALTER COLUMN  long  TYPE double precision
 USING replace("longitud",',','.')::double precision





