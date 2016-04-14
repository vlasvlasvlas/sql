select sum(rownum) from (
SELECT table_name, dsql2('select count(*) from here.'||table_name) as rownum
FROM information_schema.tables
WHERE table_type='BASE TABLE'
    AND table_schema='here'
    and table_name like 'here_%'

) as a

CREATE OR REPLACE FUNCTION dsql2(i_text text)
  RETURNS int AS
$BODY$
Declare
  v_val int;
BEGIN
  execute i_text into v_val;
  return v_val;
END; 
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;