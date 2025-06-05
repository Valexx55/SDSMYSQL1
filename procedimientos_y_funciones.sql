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

DELIMITER ;

-- FUNCIÓN PARA CONVERTIR EL FORMATO DECIMAL CON . A ,

DELIMITER $$

CREATE FUNCTION convertir_peso (peso DECIMAL(4,1)) -- CABECERA
RETURNS VARCHAR(4) -- TIPO DEVUELTO
DETERMINISTIC
BEGIN
      RETURN REPLACE(CAST(peso AS CHAR), '.', ',');

END $$

DELIMITER ;

SELECT 
	paciente_id, 
	obtener_nombre_completo(paciente_id) AS nombre_paciente,
    convertir_peso (peso) AS peso_con_formato_coma
FROM pacientes;

-- procedimento para insertar un paciente

DELIMITER $$

CREATE PROCEDURE insertar_admision (
    IN p_diagnostico VARCHAR(50),
    IN p_paciente_id INT,
    IN p_doctor_id INT
) -- parámetros formales
BEGIN
    INSERT INTO admisiones (
        fecha_admision,
        fecha_alta,
        diagnostico,
        paciente_id,
        doctor_id
    )
    VALUES (
        NOW(),           -- Fecha actual
        NULL,            -- Alta todavía no registrada
        p_diagnostico,
        p_paciente_id,
        p_doctor_id
    );
END $$

DELIMITER ;

call insertar_admision('En observación', 1, 1); -- parámetros actuales


/**
***
DISPARADORES
***
**/

-- hacemos que cuando un nuevo paciente se vaya a registrar, se calcule y almacene automáticame su imc en otra tabla

-- 1) nueva tabla IMC

CREATE TABLE imc_pacientes (
    imc_id INT AUTO_INCREMENT PRIMARY KEY,
    paciente_id INT NOT NULL,
    imc DECIMAL(5,2) NOT NULL,
    fecha_registro DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (paciente_id) REFERENCES pacientes(paciente_id)
);

-- AL INSERTAR UN PACIENTE --> generamos nuevo registro en tabla imc_pacientes
DELIMITER $$

CREATE TRIGGER trg_calcular_imc
AFTER INSERT ON pacientes
FOR EACH ROW
BEGIN
    DECLARE imc_val DECIMAL(5,2);

    -- Calculamos IMC = peso (kg) / (altura (m))^2
    -- Aseguramos que peso y altura no sean NULL ni 0 para evitar errores
    IF NEW.peso IS NOT NULL AND NEW.altura IS NOT NULL AND NEW.altura > 0 THEN
        SET imc_val = NEW.peso / (NEW.altura * NEW.altura);
    ELSE
        SET imc_val = NULL;
    END IF;

    -- Insertamos el IMC en la tabla imc_pacientes solo si es válido
    IF imc_val IS NOT NULL THEN
        INSERT INTO imc_pacientes(paciente_id, imc)
        VALUES (NEW.paciente_id, imc_val);
    END IF;
END $$

DELIMITER ;

INSERT INTO pacientes(nombre, apellido, peso, altura)
VALUES ('Juan', 'Pérez', 75, 1.75);

SELECT * FROM imc_pacientes WHERE paciente_id = LAST_INSERT_ID();

-- OTRO DISPARADOR PARA CUANDO SE ACTUALICEN LOS DATOS DEL PACIENTE

DELIMITER $$

CREATE TRIGGER trg_actualizar_imc
AFTER UPDATE ON pacientes
FOR EACH ROW
BEGIN
    DECLARE imc_val DECIMAL(5,2);

    -- Calculamos el nuevo IMC si peso o altura cambiaron y son válidos
    IF (NEW.peso <> OLD.peso OR NEW.altura <> OLD.altura) 
       AND NEW.peso IS NOT NULL AND NEW.altura IS NOT NULL AND NEW.altura > 0 THEN

        SET imc_val = NEW.peso / (NEW.altura * NEW.altura);

        -- Actualizamos el IMC en la tabla imc_pacientes
        UPDATE imc_pacientes
        SET imc = imc_val,
            fecha_registro = CURRENT_TIMESTAMP
        WHERE paciente_id = NEW.paciente_id;

        -- Si no existe el registro de IMC, lo insertamos
        -- POR SI el disparador es posterior a la tabla y hay registros de pacientes sin IMC previos
        IF ROW_COUNT() = 0 THEN -- si no se ha producido ninguna modificación ROW_COUNT() = 0
            INSERT INTO imc_pacientes (paciente_id, imc)
            VALUES (NEW.paciente_id, imc_val);
        END IF;
    END IF;
END $$

DELIMITER ;



-- otro disparador para cuando se elimine un paciente, eliminar también de manera automática su imc asociado

DELIMITER $$

CREATE TRIGGER trg_eliminar_imc
BEFORE DELETE ON pacientes
FOR EACH ROW
BEGIN
    DELETE FROM imc_pacientes WHERE paciente_id = OLD.paciente_id;
END $$

DELIMITER ;


-- CREAMOS OTRO DISPARADOR, ESTA VEZ PARA VIGILAR UNA REGLA DE NEGOCIO
-- "NO PODEMOS ASIGNAR A UN MÉDICO MÁS DE 2 PACIENTES EL MISMO DÍA"
-- ANTES DE INSERTAR, DISPARADOR


DELIMITER $$

CREATE TRIGGER trg_limitar_pacientes_por_medico
BEFORE INSERT ON admisiones
FOR EACH ROW
BEGIN
  DECLARE admisiones_hoy INT;

  IF NEW.doctor_id IS NOT NULL THEN
    SELECT COUNT(*) INTO admisiones_hoy
    FROM admisiones
    WHERE doctor_id = NEW.doctor_id
      AND DATE(fecha_admision) = DATE(NEW.fecha_admision);

    IF admisiones_hoy >= 2 THEN
      SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Error: El doctor ya tiene asignados 2 pacientes en esta fecha.';
    END IF;
  END IF;
END $$

DELIMITER ;


-- probamos a insertar 3 admsiones al mismo doctor
call insertar_admision('En observación', 6, 8); -- parámetros actuales
call insertar_admision('En observación', 7, 8); -- parámetros actuales
call insertar_admision('En observación', 8, 8); -- parámetros actuales -- Error Code: 1644. Error: El doctor ya tiene asignados 2 pacientes en esta fecha.


-- TX TRANSACCIONES

SET autocommit=0;

START TRANSACTION;

INSERT INTO pacientes(nombre, apellido, peso, altura)
VALUES ('Juan', 'Pérez', 75, 1.75);

-- ROLLBACK; -- DESHAGO EL CAMBIO DESDE EL INICIO DE LA TX
COMMIT; -- CONFIRMO LOS CAMBIOS DESDE EL INICIO

-- NUEVA VERSIÓN DEL PROC INSERTAR PACIENTES CON GESTIÓN DE LA TRASACCIÓN 

DELIMITER $$

CREATE PROCEDURE insertar_admision_tx (
    IN p_diagnostico VARCHAR(50),
    IN p_paciente_id INT,
    IN p_doctor_id INT,
    OUT mensaje_salida VARCHAR(255)
) -- parámetros formales
BEGIN
	-- DECLARO VARIABLES LOCALES PARA ALMACENAR LA DESCRIPCIÓN DEL POTENCIAL FALLO
    DECLARE codigo_error INT DEFAULT 0;
    DECLARE vsqlstate CHAR(5) DEFAULT '00000';
    DECLARE mensaje_error VARCHAR(255) DEFAULT '';
       

	-- SECCIÓN "PARACAÍDAS -GESTIÓN DE LA EXCEPCIÓN"
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		GET DIAGNOSTICS CONDITION 1 -- obtengo información sobre la excepción ocurrida
			codigo_error = MYSQL_ERRNO,
			vsqlstate = RETURNED_SQLSTATE,
            mensaje_error = MESSAGE_TEXT;
		
		-- si tenemos tablas propias de error, hacer un registro en esta sección
        SET mensaje_salida = CONCAT('ERROR', codigo_error, ' ', mensaje_error);
			
    
		ROLLBACK;
    END;
    
    START TRANSACTION; -- desactiva el autocommit
    INSERT INTO admisiones (
        fecha_admision,
        fecha_alta,
        diagnostico,
        paciente_id,
        doctor_id
    )
    VALUES (
        NOW(),           -- Fecha actual
        NULL,            -- Alta todavía no registrada
        p_diagnostico,
        p_paciente_id,
        p_doctor_id
    );
    SET mensaje_salida = 'Inserción Exitosa :) ';
    COMMIT;
END $$

DELIMITER ;

SET @mensaje='';
call insertar_admision_tx('En observación', 11, 10, @mensaje);
SELECT @mensaje;
