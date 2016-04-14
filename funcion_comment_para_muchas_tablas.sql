SELECT 
'COMMENT ON TABLE ' ||table_schema || '.' ||table_name ||' IS ''
- Fecha recibido: año 2010 aprox
- Fuente: GCBA''' || ';' FROM information_schema.tables 
WHERE table_schema = 'gcba' 


