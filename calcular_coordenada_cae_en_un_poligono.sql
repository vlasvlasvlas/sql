SELECT gid, cod_aglom, sum_htot, sum_gasgar, aglom, b10kg_ene, garr_hog,the_geom
FROM glp.glp_regiones r
WHERE st_contains (r.the_geom,ST_SetSRID(ST_Point(-57.901135,-34.873485),4326))
