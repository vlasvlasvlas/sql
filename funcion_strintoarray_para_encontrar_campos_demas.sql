﻿select * from pruebas.usuarios_lote3a where unica ~ ';{7}'
select unica, replace(unica,'!=;','<') from pruebas.usuarios_lote3a 




SELECT unica,string_to_array (unica,';'), array_length(string_to_array (unica,';'),1)
  FROM pruebas.suministros_epe
WHERE array_length(string_to_array (unica,';'),1)<12























































































