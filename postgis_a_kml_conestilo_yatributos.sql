
--header
select '<?xml version="1.0" encoding="UTF-8"?>' || E'\n' ||
'<kml xmlns="http://www.opengis.net/kml/2.2">' ||  E'\n' ||
'<Document>' ||  E'\n' ||
'<name>' || 'salida de edelap' || '</name>' ||  E'\n' || --nombre del kml
'<description>' || 'description' || '</description>' || E'\n' --descripcion del kml
 
 as kml

union all

(select 

'<Style id="defaultStyle">' ||  E'\n' ||

--colores de linea
'  <LineStyle>' || E'\n' ||

/* colores ejemplos :
ff0000ff is solid rojo
330000ff is a transpanent (see thru) red
ff00ff00 is solid verde
ffff0000 is solid azul
ff00ffff is solid amarillo (mixing of red and green)
ffff00ff is solid purple (mixing of red & blue)
*/

--color con case:

case when tension = '132000' then  
'    <color>ff0000ff</color>'  --ej color de linea 132
else 
'    <color>ff00ff00</color>'  --ej color de linea 220
end ||  E'\n' ||

'    <width>3</width>' || E'\n' || -- grosor de linea

'  </LineStyle>' ||  E'\n' ||


'  <PolyStyle>' ||  E'\n' ||


--color de poligono
case when tension = '132000' then  
'    <color>ff0000ff</color>'  --ej color de linea 132
else 
'    <color>ff00ff00</color>'  --ej color de linea 220
end ||  E'\n' ||


'  </PolyStyle>' ||  E'\n' ||
'</Style>'||  E'\n' ||
'<Placemark>' ||  E'\n' ||
'<styleUrl>#defaultStyle</styleUrl>' ||  E'\n' || 

'<name>Club de golf</name>' ||  E'\n' || --nombre del registro

    '<ExtendedData>' ||  E'\n' || 
      '<Data name="tension">' ||  E'\n' || --nombre del atributo (nombre de la columna en string)
        '<value>'||tension||'</value>' ||  E'\n' || --valor del atributo (no string)
      '</Data>' ||  E'\n' || 
      
      '<Data name="holeYardage">' ||  E'\n' || 
        '<value>234</value>' ||  E'\n' || 
      '</Data>' ||  E'\n' || 
      
      '<Data name="holePar">' ||  E'\n' || 
        '<value>4</value>' ||  E'\n' || 
      '</Data>' ||  E'\n' || 
    '</ExtendedData>' ||  E'\n' || 
    
ST_AsKML(the_geom) ||  E'\n' || '</Placemark>'  as kml from edelap.edelap_tramos_at limit 150 ) --where lo que sea  

union all

select '</Document>' ||  E'\n' ||'</kml>';


