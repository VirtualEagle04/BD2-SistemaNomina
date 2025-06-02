/*
DATE: 25/05/2025
AUTHOR: Federico Vargas Rozo
DESCRIPTION: Stored Procedures for Asistencia
*/

DELIMITER $$

-- INSERTAR
CREATE PROCEDURE sp_insert_asistencia(
	IN p_id_empleado INT,
	IN p_tiempo_ingreso DATETIME,
	IN p_tiempo_salida DATETIME
)
BEGIN
	IF (SELECT COUNT(*) FROM Empleado WHERE id_empleado = p_id_empleado) = 0 THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'ERROR: El Empleado con el id_empleado especificado no existe.';
	END IF;

	INSERT INTO Asistencia (
		id_empleado,
        tiempo_ingreso,
        tiempo_salida
	) 
	VALUES (
		p_id_empleado,
		p_tiempo_ingreso,
        p_tiempo_salida
	);
	
	SELECT CONCAT('EXITO: La Asistencia con id de empleado: ', p_id_empleado, ' ha sido insertada.') AS Mensaje;
END $$

-- SELECCIONAR TODAS CON ID EMPLEADO
CREATE PROCEDURE sp_select_asistencias_by_empleado(IN p_id_empleado INT)
BEGIN
	SELECT * FROM Asistencia WHERE id_empleado = p_id_empleado;
END $$

-- SELECCIONAR UNA
CREATE PROCEDURE sp_select_asistencia(IN p_id_asistencia INT)
BEGIN
	SELECT * FROM Asistencia WHERE id_asistencia = p_id_asistencia;
END$$

-- SELECCIONAR TODAS
CREATE PROCEDURE sp_select_asistencias()
BEGIN
	SELECT * FROM Asistencia;
END $$

-- ACTUALIZAR
CREATE PROCEDURE sp_update_asistencia(
	IN p_id_asistencia INT,
	IN p_id_empleado INT,
	IN p_tiempo_ingreso DATETIME,
	IN p_tiempo_salida DATETIME
)
BEGIN
	IF (SELECT COUNT(*) FROM Empleado WHERE id_empleado = p_id_empleado) = 0 THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'ERROR: El Empleado con el id_empleado especificado no existe.';
	END IF;

	IF (SELECT COUNT(*) FROM Asistencia WHERE id_asistencia = p_id_asistencia) = 0 THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'ERROR: La Asistencia con el id_asistencia especificada no existe.';
	END IF;
	
	UPDATE Asistencia
	SET
		id_empleado = p_id_empleado,
		tiempo_ingreso = p_tiempo_ingreso,
		tiempo_salida = p_tiempo_salida
	WHERE id_asistencia = p_id_asistencia;
	
	SELECT CONCAT('EXITO: La Asistencia con id_asistencia: ', p_id_asistencia, ' ha sido actualizada.') AS Mensaje;
END $$

-- ELIMINAR
CREATE PROCEDURE sp_delete_asistencia(IN p_id_asistencia INT)
BEGIN
	IF (SELECT COUNT(*) FROM Asistencia WHERE id_asistencia = p_id_asistencia) = 0 THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'ERROR: La Asistencia con el id_asistencia especificada no existe.';
	END IF;

	DELETE FROM Asistencia WHERE id_asistencia = p_id_asistencia;
	
	SELECT CONCAT('EXITO: La Asistencia con id_asistencia: ', p_id_asistencia, ' ha sido eliminado.') AS Mensaje;
END $$


DELIMITER ;