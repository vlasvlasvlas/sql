--para revisar si existe un key en postgresql json
    CREATE FUNCTION key_exists(some_json json, outer_key text)
    RETURNS boolean AS $$
    BEGIN
    RETURN(some_json -> outer_key) IS NOT NULL;
    END;
    $$ LANGUAGE plpgsql;
   
  -- ej:
  CASE
      WHEN key_exists("tabla".submission, 'clave/a_buscar'::text) THEN "tabla".submission::jsonb ->> 'clave/a_buscar'::text
      ELSE 'N/A'::text
  END AS nuevacol
