-- esto es un comentario
-- seleccionar el nombre, apellido y gÃ©nero de los pacientes de gÃ©nero masculino

SELECT 
    nombre, apellido, genero
FROM
    pacientes
WHERE
    genero = 'M';



-- seleccionar el nombre de los pacientes que empiecen por la letra 'C'

SELECT 
    nombre
FROM
    pacientes
WHERE
    nombre LIKE 'C%';

SELECT 
    nombre
FROM
    pacientes
WHERE
    SUBSTRING(nombre, 1, 1) = 'C';

-- seleccionar el nombre de los pacientes que empiecen cotengan una 'a'

SELECT 
    nombre
FROM
    pacientes
WHERE
    nombre LIKE '%a%';

-- seleccionar pacientes que estÃ¡n en un peso entre 70 y 90

SELECT 
    *
FROM
    pacientes
WHERE
    peso >= 70 AND peso <= 90;

SELECT 
    *
FROM
    pacientes
WHERE
    peso BETWEEN 70 AND 90;

-- hacer una consulta para obtener el nÃºmero pacientes nacidos en el 1980

SELECT 
    COUNT(*)
FROM
    pacientes
WHERE
    SUBSTRING(fecha_nacimiento, 1, 4) = '1980';

SET @anio := 1980;
SELECT 
    COUNT(*)
FROM
    pacientes
WHERE
    YEAR(fecha_nacimiento) = @anio;

-- seleccionar el nombre y el apellido, mostrado bajo un mismo llamado nombre completo


SELECT 
    CONCAT(nombre, ' ', apellido) AS nombre_completo
FROM
    pacientes;

SELECT 
    nombre || ' ' || apellido AS nombre_completo
FROM
    pacientes;

-- SET sql_mode=PIPES_AS_CONCAT; 

SELECT @@sql_mode; --  CONSULTA DEL "MODO"

SET sql_mode = CONCAT(@@sql_mode, ',PIPES_AS_CONCAT'); -- que se pueda usar el oeprador OR || como concatenación 

/*configuración del modo para esta conexión. si lo queremos hacer permanente, debemos editar el fichero /etc/mysql/mysql.conf.d/mysql.cnf por ejemplo
 con estas líneas
[mysqld]
sql_mode=STRICT_TRANS_TABLES,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION,PIPES_AS_CONCAT*/



SELECT nombre || ' ' || apellido AS nombre_completo FROM pacientes;


-- SET sql_mode=PIPES_AS_CONCAT;
SELECT @@sql_mode;
-- select NOMBRE Y APELLIDOS Y POBLACIÃ“N DE COMBINANDO LAS DOS TABLAS

SELECT 
    pa.nombre, po.nombre AS poblado, pa.apellido
FROM
    pacientes pa
        JOIN
    poblaciones po;  -- ON po.poblacion_id = pa.paciente_id;

-- select NOMBRE Y APELLIDOS Y POBLACIÃ“N DE CADA PACIENTE

SELECT 
    pa.nombre, pa.apellido, po.nombre
FROM
    pacientes pa
        JOIN
    poblaciones po ON po.poblacion_id = pa.poblacion_id;
 

SELECT 
    pa.nombre, pa.apellido, po.nombre
FROM
    pacientes pa,
    poblaciones po
WHERE
    (pa.poblacion_id = po.poblacion_id);
    

-- SELECCIONAMOS TODOS LOS PACIENTES CON ALERGIA
-- Error Code: 1054. Unknown column 'paciente_alergia.paciente_id' in 'on clause'

SELECT DISTINCT
    (nombre), pa.alergia_id
FROM
    pacientes p -- TABLA A
        INNER JOIN -- Ó JOIN TABLA B PACIENTE_ALERGIA
    paciente_alergia pa ON p.paciente_id = pa.paciente_id;
    
-- TODOS LOS PACIENTES CON ALERGIA Y NO
SELECT DISTINCT
    (nombre) , pa.alergia_id -- con esto vemos el null
FROM
    pacientes p -- tabla A
        LEFT JOIN 
    paciente_alergia pa ON p.paciente_id = pa.paciente_id; -- tabla b


-- NOMBRE DE LOS PACIENTES QUE TIENEN ALERGIA, USANDO UN RIGHT JOIN

SELECT 
    nombre
FROM
    pacientes -- TABLA A
        RIGHT JOIN
    paciente_alergia ON pacientes.paciente_id = paciente_alergia.paciente_id; -- TABLA B


-- nombre de pacientes que no tienen alergia


SELECT nombre 
FROM pacientes 
WHERE paciente_id NOT IN
	(SELECT paciente_id
    FROM paciente_alergia);
    
    
    

SELECT 
    p.nombre
FROM
    pacientes p
        LEFT JOIN
    paciente_alergia pa ON p.paciente_id = pa.paciente_id
WHERE
    pa.paciente_id IS NULL;
    
-- saber el número de admisiones

select count(*) from admisiones;


-- el número de personas que no tienen el alta

SELECT 
    COUNT(*)
FROM
    admisiones
WHERE
    fecha_alta IS NULL;
    
-- ES IGUAL QUE USO DEL * Y ES ALGO CONFUSO. SI CUENTO TODO, MEJOR *
SELECT 
    COUNT(1)
FROM
    admisiones
WHERE
    fecha_alta IS NULL;


-- SI EN VEZ DE *, PONGO EL NOMBRE DE UN CAMPO, ME CUENTA TODOS LOS REGISTROS DONDE ESE CAMPO NO ES NULO
    
SELECT 
    COUNT(fecha_alta)
FROM
    admisiones;
    
-- media peso pacientes

SELECT 
    ROUND(AVG(peso),1) AS peso_medio
FROM
    pacientes;


SELECT 
    ROUND(AVG(altura) * 100, 1) AS altura_media_cm
FROM
    pacientes;

-- DADO UN ID DE PACIENTE, CONSULTAD CUÁNTAS ADMISIONES HA TENIDO EN EL ÚLTIMO MES?

SET @idpaciente := 1;
SELECT 
    COUNT(*)
FROM
    admisiones
WHERE
    paciente_id = @idpaciente
        AND fecha_admision >= DATE_SUB(CURDATE(), INTERVAL 1 MONTH);


-- mostarr el total de pacientes, de hombres y de mujeres con COUNT Y SUM 

SELECT 
	COUNT(*) AS total_pacientes,
    SUM(CASE WHEN genero = 'M' THEN 1 ELSE 0 END) AS num_hombres,
    SUM(CASE WHEN genero = 'F' THEN 1 ELSE 0 END) AS num_mujeres
FROM pacientes;


-- LISTADO DE ALERGIAS ARGUPADO POR NOMBRE Y EL NÚMERO de PACIENTES QUE LA TIENEN

SELECT 
    alergias.nombre, COUNT(*) AS num_pacientes
FROM
    paciente_alergia
        JOIN
    alergias ON paciente_alergia.alergia_id = alergias.alergia_id
GROUP BY alergias.nombre;

-- SI USAMOS UNA FUNCI'PON AGREGADA CON UN DATO QUE NO, SIEMPRE GROUP BY
-- Error Code: 1140. In aggregated query without GROUP BY, expression #1 of SELECT list contains nonaggregated column 'hospital_profe.alergias.nombre'; this is incompatible with sql_mode=only_full_group_by


-- EL NÚMERO DE ADMISIONES POR POR PROVINCIA, ORDENADO POR NOMBRE DE PROVINCIA Y NÚMERO DE ADMISIONES
/**
1 datos y hago la select (DATOS Calculados o NO)
2 de qué tablas, pienso en los join
3 cómo agrupo
4 cómo ordena 
5 filtro HAVING / LIMIT
*/

SELECT provincias.nombre, 
       COUNT(admisiones.admisiones_id) AS num_admisiones
FROM admisiones
JOIN pacientes ON admisiones.paciente_id = pacientes.paciente_id
JOIN poblaciones ON pacientes.poblacion_id = poblaciones.poblacion_id
JOIN provincias ON poblaciones.provincia_id = provincias.provincia_id
GROUP BY provincias.nombre, provincias.provincia_id
ORDER BY num_admisiones DESC, provincias.nombre ASC;
-- ordenación simple ORDER BY num_admisiones DESC;

-- CONSULTAR LA ALERGIA MÁS COMÚN

SELECT 
    alergias.nombre, COUNT(*) AS num_pacientes
FROM
    paciente_alergia
        JOIN
    alergias ON paciente_alergia.alergia_id = alergias.alergia_id
GROUP BY alergias.nombre
ORDER BY num_pacientes DESC
LIMIT 1; -- TODO mejorar para que salgan más en caso de empate

-- MISMA LÓGICA, CON SUBOCUNLTAS Y CTES

SELECT 
    nombre, cantidad -- seleccionamos la cantidad que sea igual al máximo: filtro la subconsulta 1 con los datos de la subconsulta 2
FROM
    (SELECT -- seleccionamos las veces que aparecen cada alergia (1)
        a.nombre, COUNT(*) AS cantidad
    FROM
        paciente_alergia pa
    JOIN alergias a ON pa.alergia_id = a.alergia_id
    GROUP BY pa.alergia_id , a.nombre) AS p
WHERE
    cantidad = (SELECT 
            MAX(cantidad) -- seleccionar el número máximo de las distitnas alergias en la tabla intermedia (2)
        FROM
            (SELECT 
                COUNT(*) AS cantidad
            FROM
                paciente_alergia
            GROUP BY alergia_id) AS sub);

-- CTE - COMMON TABLE EXPRESSIONS - tablas temporales, vistas - sólo disponibles a partir de la versión 8

WITH alergias_con_conteo AS (
    SELECT 
        a.nombre,
        COUNT(*) AS cantidad
    FROM
        paciente_alergia pa
    JOIN 
        alergias a ON pa.alergia_id = a.alergia_id
    GROUP BY 
        a.nombre
),
cantidad_maxima AS (
    SELECT MAX(cantidad) AS max_cantidad
    FROM alergias_con_conteo
)
SELECT 
    ac.nombre,
    ac.cantidad
FROM 
    alergias_con_conteo ac
JOIN 
    cantidad_maxima cm ON ac.cantidad = cm.max_cantidad;




-- CONSULTAR LA ALERGIA MENOS COMÚN

SELECT 
    alergias.nombre, COUNT(*) AS num_pacientes
FROM
    paciente_alergia
        JOIN
    alergias ON paciente_alergia.alergia_id = alergias.alergia_id
GROUP BY alergias.nombre
ORDER BY num_pacientes ASC
LIMIT 1; -- TODO mejorar para que salgan más en caso de empate


-- ALERGIAS QUE TIENEN LOS DISTINTOS PACIENTES se repiten por no usar Distinct

SELECT a.nombre
FROM alergias a
JOIN paciente_alergia pa ON a.alergia_id = pa.alergia_id;

-- ALERGIAS QUE TIENEN LOS DISTINTOS PACIENTES NO se repiten AL USAR Distinct

SELECT DISTINCT a.nombre
FROM alergias a
JOIN paciente_alergia pa ON a.alergia_id = pa.alergia_id;

-- CUÁNTAS ESPECIALIDADES MÉDICAS TENGO EN MI EQUIPO MÉDICO
/**
contar las especialidades de cada médico
sólo las distintas
*/

SELECT COUNT(especialidad) FROM doctores; -- salen repes / MISMO DATO QUE DOCTORES

SELECT COUNT(DISTINCT especialidad) FROM doctores; -- EVITAMOS EL REPE AL USAR DISTINCT



-- EL NÚMERO DE PACIENTES AGRUPADOS POR EL PESO, DE 10 EN 10, DE MENOR A MAYOR

SELECT 
    COUNT(*) AS num_pacientes_grupo,
    FLOOR(peso / 10) * 10 AS grupo_peso
FROM
    pacientes
GROUP BY grupo_peso
ORDER BY grupo_peso ASC;


-- más ejemplos con LIMIT VS CTES

-- qué paciente ha estaod más tiempo ingresado (en admisiones)

SELECT 
    p.paciente_id,
    p.nombre,
    p.apellido,
    SUM(DATEDIFF(
        IF(a.fecha_alta IS NOT NULL, a.fecha_alta, CURDATE()), 
        a.fecha_admision
    )) AS dias_totales
FROM 
    admisiones a
JOIN 
    pacientes p ON a.paciente_id = p.paciente_id
GROUP BY 
    p.paciente_id, p.nombre, p.apellido
ORDER BY 
    dias_totales DESC
LIMIT 1;


-- INTENTAD, HACER LA CONSULTA ANTERIOR, COMO SUBCONSULTAS CON CTE
-- (1) CALCULAMOS LOS DÍAS TOTALES, INGRESADOS POR PACIENTES
-- (2) OBTENGO EL MÁXIMO DE DÍAS
--  (3) ME QUEDON CON LOS PACIENTES DE (1) QUE TENGAN LOS DÍAS DE (2)

WITH dias_por_paciente AS(
SELECT 
    p.paciente_id,
    p.nombre,
    p.apellido,
    SUM(DATEDIFF(
        IF(a.fecha_alta IS NOT NULL, a.fecha_alta, CURDATE()), 
        a.fecha_admision
    )) AS dias_totales
FROM 
    admisiones a
JOIN 
    pacientes p ON a.paciente_id = p.paciente_id
GROUP BY 
    p.paciente_id, p.nombre, p.apellido
), maximo AS (
SELECT MAX(dias_totales) AS max_dias FROM dias_por_paciente
)
SELECT
	d.paciente_id,
    d.nombre, 
    d.apellido,
    d.dias_totales
FROM dias_por_paciente d
JOIN maximo m ON d.dias_totales = m.max_dias;

-- DATOS CALCULADOS/AGREGADOS/FLAG
/**
MUESTRA ID, ALTURA Y PESO Y SI UN PACIENTE ES SOBREPESO ( CON 0 0 1) Y SOBREPESO SI SU IMC ES MAYOR O IGUAL 25
//imc = PESO (KG) / estatutra * estatura
**/

SELECT 
    paciente_id,
    peso,
    altura,
    peso / (POWER(p.altura,2)) >= 25 AS sobrepeso
FROM
    pacientes p
ORDER BY sobrepeso DESC;

SELECT paciente_id, peso, altura,
  (CASE 
      WHEN (peso/POWER(p.altura,2)) >= 25 THEN
          1
      ELSE
          0
      END) AS SOBREPESO
FROM pacientes p
ORDER BY sobrepeso DESC;


