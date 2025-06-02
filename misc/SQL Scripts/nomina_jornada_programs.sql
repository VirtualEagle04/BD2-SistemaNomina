/*
DATE: 25/05/2025
AUTHOR: Federico Vargas Rozo
DESCRIPTION: Stored Procedures for Jornada
*/

DELIMITER $$

-- INSERTAR
CREATE PROCEDURE sp_insert_jornada(
	IN p_nombre_jornada VARCHAR(50),
	IN p_hora_inicio TIME,
	IN p_hora_fin TIME,
	IN p_id_recargo INT,
	IN p_id_hora_extra INT
)
BEGIN
	IF (SELECT COUNT(*) FROM ConceptoNomina WHERE id_concepto = p_id_recargo) = 0 THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'ERROR: El Concepto con el p_id_recargo especificado no existe.';
	END IF;

	IF (SELECT COUNT(*) FROM ConceptoNomina WHERE id_concepto = p_id_hora_extra) = 0 THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'ERROR: El Concepto con el p_id_hora_extra especificado no existe.';
	END IF;

	INSERT INTO Jornada (
		nombre_jornada,
        hora_inicio,
        hora_fin,
        id_recargo,
        id_hora_extra
	) 
	VALUES (
		p_nombre_jornada,
        p_hora_inicio,
        p_hora_fin,
        p_id_recargo,
        p_id_hora_extra
	);
	
	SELECT CONCAT('EXITO: La Jornada con nombre jornada: ', p_nombre_jornada, ' ha sido insertada.') AS Mensaje;
END $$

-- SELECCIONAR UNA
CREATE PROCEDURE sp_select_jornada(IN p_id_jornada INT)
BEGIN
	SELECT * FROM Jornada WHERE id_jornada = p_id_jornada;
END $$

-- SELECCIONAR TODAS
CREATE PROCEDURE sp_select_jornadas()
BEGIN
	SELECT * FROM Jornada;
END $$

-- ACTUALIZAR
CREATE PROCEDURE sp_update_jornada(
	IN p_id_jornada INT,
	IN p_nombre_jornada VARCHAR(50),
	IN p_hora_inicio TIME,
	IN p_hora_fin TIME,
	IN p_id_recargo INT,
	IN p_id_hora_extra INT
)
BEGIN
	IF (SELECT COUNT(*) FROM ConceptoNomina WHERE id_concepto = p_id_recargo) = 0 THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'ERROR: El Concepto con el p_id_recargo especificado no existe.';
	END IF;

	IF (SELECT COUNT(*) FROM ConceptoNomina WHERE id_concepto = p_id_hora_extra) = 0 THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'ERROR: El Concepto con el p_id_hora_extra especificado no existe.';
	END IF;

	IF (SELECT COUNT(*) FROM Jornada WHERE id_jornada = p_id_jornada) = 0 THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'ERROR: La Jornada con el id_jornada especificada no existe.';
	END IF;
	
	UPDATE Jornada
	SET
		nombre_jornada = p_nombre_jornada,
        hora_inicio = p_hora_inicio,
        hora_fin = p_hora_fin,
        id_recargo = p_id_recargo,
        id_hora_extra = p_id_hora_extra
	WHERE id_jornada = p_id_jornada;
	
	SELECT CONCAT('EXITO: La Jornada con id_jornada: ', p_id_jornada, ' ha sido actualizada.') AS Mensaje;
END $$

-- ELIMINAR
CREATE PROCEDURE sp_delete_jornada(IN p_id_jornada INT)
BEGIN
	IF (SELECT COUNT(*) FROM Jornada WHERE id_jornada = p_id_jornada) = 0 THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'ERROR: La Jornada con el id_jornada especificada no existe.';
	END IF;

	DELETE FROM Jornada WHERE id_jornada = p_id_jornada;
	
	SELECT CONCAT('EXITO: La Jornada con id_jornada: ', p_id_jornada, ' ha sido eliminada.') AS Mensaje;
END $$


DELIMITER ;