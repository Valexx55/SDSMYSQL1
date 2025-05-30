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
/*
SET sql_mode=PIPES_AS_CONCAT; 
SELECT nombre || ' ' || apellido AS nombre_completo FROM pacientes;
*/

-- SET sql_mode=PIPES_AS_CONCAT;
-- SELECT @@sql_mode;
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

SELECT DISTINCT
    (nombre)
FROM
    pacientes
        INNER JOIN
    paciente_alergia ON pacientes.paciente_id = paciente_alergia.paciente_id;


SELECT 
    pa.nombre, pa.apellido, pu.nombre
FROM
    pacientes pa
        JOIN
    alergias pu ON pu.alergia_id;

