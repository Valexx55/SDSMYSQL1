EXPLAIN SELECT 
    COUNT(*) AS num_pacientes_grupo,
    FLOOR(peso / 10) * 10 AS grupo_peso
FROM
    pacientes
GROUP BY grupo_peso;


SELECT 
    COUNT(*) AS num_pacientes_grupo,
    FLOOR(peso / 10) * 10 AS grupo_peso_n
FROM
    pacientes
GROUP BY grupo_peso_n;

-- PRECALCULAR LOS GRUPOS DE PESO Y NO TENER QUE CALCULARLO PARA CADA FILA CADA VEZ 
-- datos agregados / calculados

ALTER TABLE pacientes ADD COLUMN grupo_peso INT GENERATED ALWAYS AS (FLOOR(peso / 10) * 10) STORED;

-- CREAMOS UN ÍNDICE SOBRE ESE NUEVO CAMPO, PARA OPTIMIZAR LAS LECTURAS

CREATE INDEX idx_grupo_peso ON pacientes(grupo_peso);

EXPLAIN SELECT 
    COUNT(*) AS num_pacientes_grupo, grupo_peso
FROM
    pacientes
GROUP BY grupo_peso;


EXPLAIN ANALYZE SELECT 
    COUNT(*) AS num_pacientes_grupo, grupo_peso
FROM
    pacientes
GROUP BY grupo_peso;


SELECT 
    COUNT(*) AS num_pacientes_grupo, grupo_peso
FROM
    pacientes
GROUP BY grupo_peso;


-- optimizando la consulta 2

SELECT 
    alergias.nombre, 
    COUNT(*) AS num_pacientes
FROM
    paciente_alergia
JOIN
    alergias ON paciente_alergia.alergia_id = alergias.alergia_id
GROUP BY 
    alergias.nombre
ORDER BY 
    num_pacientes DESC
LIMIT 1;



EXPLAIN ANALYZE SELECT 
    alergias.nombre, 
    COUNT(*) AS num_pacientes
FROM
    paciente_alergia
JOIN
    alergias ON paciente_alergia.alergia_id = alergias.alergia_id
GROUP BY 
    alergias.nombre
ORDER BY 
    num_pacientes DESC
LIMIT 1;

/*
*
'-> Limit: 1 row(s)  (actual time=0.122..0.122 rows=1 loops=1)\n    
	-> Sort: num_pacientes DESC, limit input to 1 row(s) per chunk  (actual time=0.121..0.121 rows=1 loops=1)\n        
		-> Stream results  (cost=5.85 rows=8) (actual time=0.0706..0.106 rows=8 loops=1)\n            
			-> Group aggregate: count(0)  (cost=5.85 rows=8) (actual time=0.066..0.0981 rows=8 loops=1)\n                
				-> Nested loop inner join  (cost=4.45 rows=14) (actual time=0.0493..0.086 rows=13 loops=1)\n                    
					-> Covering index scan on alergias using nombre  (cost=1.05 rows=8) (actual time=0.0314..0.035 rows=8 loops=1)\n                    -> Covering index lookup on paciente_alergia using alergia_id (alergia_id=alergias.alergia_id)  (cost=0.272 rows=1.75) (actual time=0.00423..0.00577 rows=1.62 loops=8)\n'

TRAS OPTIMIZAR

'-> Limit: 1 row(s)  (cost=2.6..2.6 rows=0) (actual time=0.188..0.188 rows=1 loops=1)\n    
	-> Sort: sub.num_pacientes DESC, limit input to 1 row(s) per chunk  (cost=2.6..2.6 rows=0) (actual time=0.187..0.187 rows=1 loops=1)\n
		-> Table scan on sub  (cost=2.5..2.5 rows=0) (actual time=0.168..0.169 rows=8 loops=1)\n            
			-> Materialize  (cost=0..0 rows=0) (actual time=0.167..0.167 rows=8 loops=1)\n                
				-> Table scan on <temporary>  (actual time=0.15..0.151 rows=8 loops=1)\n                    
					-> Aggregate using temporary table  (actual time=0.148..0.148 rows=8 loops=1)\n                        
						-> Nested loop inner join  (cost=4.45 rows=14) (actual time=0.0747..0.112 rows=13 loops=1)\n  
							-> Covering index scan on a using nombre  (cost=1.05 rows=8) (actual time=0.0548..0.0586 rows=8 loops=1)\n                            -> Covering index lookup on pa using alergia_id (alergia_id=a.alergia_id)  (cost=0.272 rows=1.75) (actual time=0.00446..0.00605 rows=1.62 loops=8)\n'


*/


-- DIVIDO LA CONSULTA EN 2 PARA PRIMERO AGRUPAR Y DESPUÉS ORDENAR
-- agrupar además por la PK ID ALERGIA



EXPLAIN ANALYZE SELECT nombre, num_pacientes
FROM (
    SELECT 
        a.alergia_id,
        a.nombre, 
        COUNT(*) AS num_pacientes
    FROM paciente_alergia pa
    JOIN alergias a ON pa.alergia_id = a.alergia_id
    GROUP BY a.alergia_id, a.nombre
) AS sub
ORDER BY num_pacientes DESC
LIMIT 1;
