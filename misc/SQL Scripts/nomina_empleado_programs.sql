/*
DATE: 25/05/2025
AUTHOR: Federico Vargas Rozo
DESCRIPTION: Stored Procedures for Empleado
*/

DELIMITER $$

-- INSERTAR
CREATE PROCEDURE sp_insert_empleado(
	IN p_cedula VARCHAR(10),
	IN p_nombres VARCHAR(50),
	IN p_apellidos VARCHAR(50),
	IN p_fecha_nacimiento DATE,
	IN p_direccion VARCHAR(100),
	IN p_telefono VARCHAR(10),
	IN p_email VARCHAR(50),
	IN p_id_cargo INT,
	IN p_id_jornada INT
)
BEGIN
	IF (SELECT COUNT(*) FROM Cargo WHERE id_cargo = p_id_cargo) = 0 THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'ERROR: El Cargo con el id_cargo especificado no existe.';
	END IF;

	IF (SELECT COUNT(*) FROM Jornada WHERE id_jornada = p_id_jornada) = 0 THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'ERROR: La Jornada con el id_jornada especificado no existe.';
	END IF;

	INSERT INTO Empleado (
		cedula, 
		nombres, 
		apellidos, 
		fecha_nacimiento, 
		direccion, 
		telefono, 
		email, 
		id_cargo,
		id_jornada
	) 
	VALUES (
		p_cedula,
		p_nombres,
		p_apellidos,
		p_fecha_nacimiento,
		p_direccion,
		p_telefono,
		p_email,
		p_id_cargo,
		p_id_jornada
	);
	
	SELECT CONCAT('EXITO: El Empleado con cedula: ', p_cedula, ' ha sido insertado.') AS Mensaje;
END $$

-- SELECCIONAR UNO
CREATE PROCEDURE sp_select_empleado(IN p_id_empleado INT)
BEGIN
	SELECT * FROM Empleado WHERE id_empleado = p_id_empleado;
END $$

-- SELECCIONAR TODOS
CREATE PROCEDURE sp_select_empleados()
BEGIN
	SELECT * FROM Empleado;
END $$

-- ACTUALIZAR
CREATE PROCEDURE sp_update_empleado(
	IN p_id_empleado INT,
	IN p_cedula VARCHAR(10),
	IN p_nombres VARCHAR(50),
	IN p_apellidos VARCHAR(50),
	IN p_fecha_nacimiento DATE,
	IN p_direccion VARCHAR(100),
	IN p_telefono VARCHAR(10),
	IN p_email VARCHAR(50),
	IN p_fecha_contratacion DATETIME,
	IN p_id_cargo INT,
	IN p_id_jornada INT
)
BEGIN
	IF (SELECT COUNT(*) FROM Cargo WHERE id_cargo = p_id_cargo) = 0 THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'ERROR: El Cargo con el id_cargo especificado no existe.';
	END IF;

	IF (SELECT COUNT(*) FROM Jornada WHERE id_jornada = p_id_jornada) = 0 THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'ERROR: La Jornada con el id_jornada especificado no existe.';
	END IF;

	IF (SELECT COUNT(*) FROM Empleado WHERE id_empleado = p_id_empleado) = 0 THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'ERROR: El Empleado con el id_empleado especificado no existe.';
	END IF;
	
	UPDATE Empleado
	SET
		cedula = p_cedula,
		nombres = p_nombres,
		apellidos = p_apellidos,
		fecha_nacimiento = p_fecha_nacimiento,
		direccion = p_direccion,
		telefono = p_telefono,
		email = p_email,
		fecha_contratacion = p_fecha_contratacion,
		id_cargo = p_id_cargo,
		id_jornada = p_id_jornada
	WHERE id_empleado = p_id_empleado;
	
	SELECT CONCAT('EXITO: El Empleado con id_empleado: ', p_id_empleado, ' ha sido actualizado.') AS Mensaje;
END $$

-- ELIMINAR
CREATE PROCEDURE sp_delete_empleado(IN p_id_empleado INT)
BEGIN
	IF (SELECT COUNT(*) FROM Empleado WHERE id_empleado = p_id_empleado) = 0 THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'ERROR: El Empleado con el id_empleado especificado no existe.';
	END IF;

	DELETE FROM Empleado WHERE id_empleado = p_id_empleado;
	
	SELECT CONCAT('EXITO: El Empleado con id_empleado: ', p_id_empleado, ' ha sido eliminado.') AS Mensaje;
END $$


DELIMITER ;

-- PRUEBAS
-- CALL nomina.sp_select_empleado(5);
-- CALL nomina.sp_select_empleados();
-- CALL nomina.sp_delete_empleado(54);
-- CALL nomina.sp_update_empleado(
-- 	1,
-- 	'1012345678', 
-- 	'Carlos', 
-- 	'Ramírez', 
-- 	'1990-05-12', 
-- 	'Cra 10 #20-30', 
-- 	'3114567890', 
-- 	'carlos.ramirez@example.com', 
-- 	1
-- );