/**
PROCEDIMIENTOS ALMACENADOS

TRANSACCIÓN - TX : Conjunto de operaciones lógicamente agrupadas de modo que quiero que se hagan todas o si falla alguna, que no se haga nada

ESTRUCTURA DE UN PROC
NOMBRE - describe su funcionalidad
PARAMÉTROS - datos necesarios para realizar esa operación

**/

DELIMITER $$

CREATE PROCEDURE buscar_pacientes_por_apellido2(IN prefijo VARCHAR(10)) -- parámetros
BEGIN
	-- primera consulta
    SELECT * FROM pacientes WHERE apellido LIKE CONCAT(prefijo, '%');	
END $$

DELIMITER ; 




DELIMITER $$

CREATE PROCEDURE buscar_pacientes_por_apellido_inicio(IN prefijo VARCHAR(30))
BEGIN
    SELECT 
        *
    FROM 
        pacientes
    WHERE 
        apellido LIKE CONCAT(prefijo, '%');
END $$

DELIMITER ;


call hospital_profe.buscar_pacientes_por_apellido_inicio('M');
call hospital_profe.buscar_pacientes_por_apellido_inicio('Z');


-- HACER UN PROCEDIMIENTO QUE RECIBA EL ID DE PACIENTE Y DEVUELVA SU Nº ADMISIONES Y EL NOMBRE COMPLETO

DELIMITER $$

CREATE PROCEDURE obtener_info_paciente(IN idpaciente INT, OUT num_admisiones INT, OUT nombre_completo VARCHAR(100))
BEGIN
	
    SELECT 
        COUNT(*) INTO num_admisiones
    FROM 
        admisiones
    WHERE 
        paciente_id = idpaciente;
        
    SELECT 
		CONCAT(nombre, ' ', apellido) INTO nombre_completo 
	FROM
		pacientes
	WHERE
		idpaciente = paciente_id;
END $$

DELIMITER ;


-- CUERPO DE PROCEDIMIENTO -- puede haber muchas consultas



/**
FUNCIONES -DEFINIDAS POR EL USUARIO-
IGUAL QUE PROCEDMIENTO, PERO ME DEVUELVE UN ÚNICO DATO. y sólo tengo parámetros de entrada. No se especifica el tipo
F() PARA LUEGO REULIZARLTA DESDE OTRAS CONSULTAS

**/

-- FUNCIÓN QUE ME DEVUELVE, DADA LA FECHA DE NACIMIENTO, LOS AÑOS DE UN PACIENTE



DELIMITER $$

CREATE FUNCTION obtener_edad(fec_nac DATE)
RETURNS INT -- declaro el tipo devuelto
CONTAINS SQL -- VALOR POR DEFECTO, le decimos al motor que esta función no hace selects ni accede a tablas
DETERMINISTIC -- ante un mismo dato de entrada, la salida es idéntica
BEGIN
	 RETURN TIMESTAMPDIFF(YEAR,fec_nac,CURDATE());
END $$

DELIMITER ;


SELECT 
    nombre, apellido, obtener_edad(fecha_nacimiento) AS edad
FROM
    pacientes
ORDER BY edad DESC;


-- FUNCIÓN QUE DEVUELVA EL NOMBRE COMPLETO DE UN APCIENTE, DADO SU ID 


DELIMITER $$

CREATE FUNCTION obtener_nombre_completo(idpaciente INT)
RETURNS VARCHAR(100) -- declaro el tipo devuelto
DETERMINISTIC -- ante un mismo dato de entrada, la salida es idéntica
READS SQL DATA -- si la función, ejecuta alguna consulta, debo indicar este valor
BEGIN
	 -- RETURN TIMESTAMPDIFF(YEAR,fec_nac,CURDATE());
     DECLARE nombre_completo VARCHAR(100);
     SELECT CONCAT(nombre, ' ', apellido) INTO nombre_completo
     FROM pacientes 
     WHERE paciente_id = idpaciente;
     RETURN nombre_completo;
END $$

DELIMITER ;

SELECT obtener_nombre_completo(1) AS paciente FROM pacientes WHERE paciente_id=1;


-- TODO voluntario: haced un procedimiento, que inserte los datos de una nueva admisión. Pensad en los parámetros imprescindibles, suponiendo un valor por defecto a columnas opcionales o deducibles
