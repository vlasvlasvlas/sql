select AddGeometryColumn( 'public', 'ign_provincias_capital', 'the_geombuf', 4326, 'MULTIPOLYGON', 2 )

update ign_provincias_capital set the_geombuf = st_buffer(the_geom,0.01)


--0.01 seria 1.11 km ya que 1 grado equivale a 111 km. al parecer esa distancia de 1.11 km la mantiene a lo largo de todo el pais










