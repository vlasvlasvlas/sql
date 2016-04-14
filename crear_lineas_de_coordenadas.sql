SELECT AddGeometryColumn('public','edesur_red_bt_gk5','the_geom',4326,'LINESTRING',2);


update edesur_red_bt_gk5
set the_geom =
st_transform( st_GeomFromText('LINESTRING(' ||coorxinicial || ' ' || cooryinicial || ', ' || coorxfinal || ' ' || cooryfinal || ')',22195),4326)



