/**
UPDATE
**/

-- actualizar todas las fechas de alta de admisiones a la fecha actual
SET SQL_SAFE_UPDATES = 0; -- DESHABILITO EL MODO DE ACTUALIZACIONES SEGURAS "SAFE UPDATE MODE"
UPDATE admisiones
SET admisiones.fecha_alta = CURDATE();
SET SQL_SAFE_UPDATES = 1;

/**
Error Code: 1175. You are using safe update mode and you tried to update a table without a WHERE that uses a KEY column.  
To disable safe mode, toggle the option in Preferences -> SQL Editor and reconnect.

**/

-- actualziar el apellido del paciente id 4 a jimenez
UPDATE pacientes
SET apellido = 'Jiménez'
WHERE paciente_id = 4;


UPDATE pacientes
SET apellido = CONCAT(apellido, ' López')
WHERE paciente_id = 4;

-- HACED UNA ACTUALIZACIÓN PARA AUMENTAR  EN 1KG A TODOS LOS PACIENTES DE MADRID

UPDATE pacientes p
JOIN poblaciones po ON po.poblacion_id = p.poblacion_id
JOIN provincias pa ON po.provincia_id = pa.provincia_id
SET p.peso = p.peso +1
WHERE pa.nombre = 'Madrid';

SELECT p.nombre, p.peso FROM 
pacientes p
JOIN poblaciones po ON po.poblacion_id = p.poblacion_id
JOIN provincias pa ON po.provincia_id = pa.provincia_id 
WHERE pa.nombre = 'Madrid';

-- ACTUALIZAR LAS ADMSIONES SIN FECHA DE ALTA AL DIAGNÓSTICO GENÉRICO "EN OBSERVACIÓN"

SET SQL_SAFE_UPDATES = 0; -- DESHABILITO EL MODO DE ACTUALIZACIONES SEGURAS "SAFE UPDATE MODE" -- NECESARIO AL NO USAR UN CAMPO CLAVE EN LA CLÁSULA WHERE
UPDATE admisiones
SET diagnostico = 'En observación'
WHERE fecha_alta IS NULL; 
SET SQL_SAFE_UPDATES = 1; -- HABILITO EL MODO DE ACTUALIZACIONES SEGURAS "SAFE UPDATE MODE"

-- Error Code: 1175. You are using safe update mode and you tried to update a table without a WHERE that uses a KEY column.  To disable safe mode, toggle the option in Preferences -> SQL Editor and reconnect.

/**
DELETE
**/

-- ELIMINAMOS UN PACIENTE CONCRETO
SET @idpaciente := 5;
DELETE FROM  pacientes
WHERE paciente_id = @idpaciente;
-- Error Code: 1451. Cannot delete or update a parent row: a foreign key constraint fails (`hospital_profe`.`admisiones`, CONSTRAINT `admisiones_ibfk_1` FOREIGN KEY (`paciente_id`) REFERENCES `pacientes` (`paciente_id`))
-- Error Code: 1451. Cannot delete or update a parent row: a foreign key constraint fails (`hospital_profe`.`paciente_alergia`, CONSTRAINT `paciente_alergia_ibfk_1` FOREIGN KEY (`paciente_id`) REFERENCES `pacientes` (`paciente_id`))


-- ELIMINAR LAS ADMSIONES ANTERIORES A 5 AÑOS
UPDATE `hospital_profe`.`admisiones` SET `fecha_admision` = '2020-05-01 10:00:00' WHERE (`admisiones_id` = '1'); -- preparamos datos
SET SQL_SAFE_UPDATES = 0;
DELETE FROM admisiones
WHERE fecha_admision < DATE_SUB(CURDATE(), INTERVAL 5 YEAR);
SET SQL_SAFE_UPDATES = 1;


-- eliminar doctores sin una asignación en el último año

SET SQL_SAFE_UPDATES = 0;
DELETE d FROM doctores d
LEFT JOIN admisiones a ON a.doctor_id = d.doctor_id
WHERE a.fecha_admision < DATE_SUB(CURDATE(), INTERVAL 1 YEAR) OR a.fecha_admision IS NULL;
SET SQL_SAFE_UPDATES = 1;


-- Error Code: 1451. Cannot delete or update a parent row: a foreign key constraint fails (`hospital_profe`.`admisiones`, CONSTRAINT `admisiones_ibfk_2` FOREIGN KEY (`doctor_id`) REFERENCES `doctores` (`doctor_id`))

