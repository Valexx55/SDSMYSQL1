-- CREAMOS UNA VISTA CON LOS PACIENTES ALERGIAS
-- esta vista, tiene datos no actualizables, por incluir un JOIN de varias tablas
--  igual pasaría si tengo funciones de agregación o agrupaciones
CREATE VIEW vista_pacientes_alergias AS
SELECT
	p.paciente_id,
    p.nombre, 
    p.apellido,
    a.nombre as nombre_alergia
FROM pacientes p
JOIN paciente_alergia pa ON p.paciente_id = pa.paciente_id
JOIN alergias a ON a.alergia_id = pa.alergia_id;

-- UNA VISTA PARA QUE NOS DE ELDETALLE DE CUA´NDO HA SIDO ADMITOD UN PACIENTE, EL DOCTOR, EL DIAGNOSTICO

CREATE OR REPLACE VIEW vista_admisiones_detalle AS -- NO PODEMOS REALIZAR ALTER SOBRE VIEWS, SIEMPRE INCLUIR CREATE OR REPLACE SI NECESITAMOS MODIFICARLO
SELECT
    p.nombre AS nombre_paciente,
    a.fecha_admision,
    a.fecha_alta,
    d.nombre AS nombre_doctor,
    d.apellido AS apellido_doctor ,
	a.diagnostico
FROM admisiones a
JOIN pacientes p ON a.paciente_id = p.paciente_id
LEFT JOIN doctores d ON a.doctor_id = d.doctor_id;
    

-- UNA VISTA QUE OMITA LOS DATOS PRIVADOS DE UN PACIENTE (FECHA_NACIMIENTO) Y EL GÉNERO -- si son actualizable : son datos de una sola tabla -- PODRÍAS HACER UN UPDATE O DELETE

CREATE VIEW vista_pacientes_sin_genero_fecha AS
SELECT 
    paciente_id,
    nombre,
    apellido,
    peso,
    altura,
    poblacion_id
FROM 
    pacientes;
