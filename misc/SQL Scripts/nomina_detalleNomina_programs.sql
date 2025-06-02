/*
DATE: 25/05/2025
AUTHOR: Federico Vargas Rozo
DESCRIPTION: Stored Procedures for DetalleNomina
*/

DELIMITER $$

-- INSERTAR
CREATE PROCEDURE sp_insert_detalle_nomina(
	IN p_id_nomina INT,
	IN p_id_concepto INT,
	IN p_monto_aplicado INT,
	IN p_porcentaje_aplicado FLOAT,
	IN p_monto_final INT
)
BEGIN
	IF (SELECT COUNT(*) FROM Nomina WHERE id_nomina = p_id_nomina) = 0 THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'ERROR: La Nómina con el id_nomina especificado no existe.';
	END IF;

	IF (SELECT COUNT(*) FROM ConceptoNomina WHERE id_concepto = p_id_concepto) = 0 THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'ERROR: El Concepto Nómina con el id_concepto especificado no existe.';
	END IF;

	INSERT INTO DetalleNomina (
		id_nomina,
        id_concepto,
        monto_aplicado,
        porcentaje_aplicado,
        monto_final
	) 
	VALUES (
		p_id_nomina,
        p_id_concepto,
        p_monto_aplicado,
        p_porcentaje_aplicado,
        p_monto_final
	);
	
	SELECT CONCAT('EXITO: El Detalle Nómina con id_nomina: ', p_id_nomina, ' ha sido insertado.') AS Mensaje;
END $$

-- SELECCIONAR TODOS CON ID NÓMINA
CREATE PROCEDURE sp_select_detalles_nomina_for_nomina(IN p_id_nomina INT)
BEGIN
	SELECT * FROM DetalleNomina WHERE id_nomina = p_id_nomina;
END $$

-- SELECCIONAR UNO
CREATE PROCEDURE sp_select_detalle_nomina(IN p_id_detalle INT)
BEGIN
	SELECT * FROM DetalleNomina WHERE id_detalle = p_id_detalle;
END $$

-- SELECCIONAR TODOS
CREATE PROCEDURE sp_select_detalles_nomina()
BEGIN
	SELECT * FROM DetalleNomina;
END $$

-- ACTUALIZAR
CREATE PROCEDURE sp_update_detalle_nomina(
	IN p_id_detalle INT,
	IN p_id_concepto INT,
	IN p_monto_aplicado INT,
	IN p_porcentaje_aplicado FLOAT,
	IN p_monto_final INT	
)
BEGIN
	IF (SELECT COUNT(*) FROM ConceptoNomina WHERE id_concepto = p_id_concepto) = 0 THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'ERROR: El Concepto Nómina con el id_concepto especificado no existe.';
	END IF;

	IF (SELECT COUNT(*) FROM DetalleNomina WHERE id_detalle = p_id_detalle) = 0 THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'ERROR: El Detalle Nómina con el id_detalle especificado no existe.';
	END IF;
	
	UPDATE DetalleNomina
	SET
        id_concepto = p_id_concepto,
        monto_aplicado = p_monto_aplicado,
        porcentaje_aplicado = p_porcentaje_aplicado,
        monto_final = p_monto_final
	WHERE id_detalle = p_id_detalle;
	
	SELECT CONCAT('EXITO: El Detalle con id_detalle: ', p_id_detalle, ' ha sido actualizado.') AS Mensaje;
END $$

-- ELIMINAR
CREATE PROCEDURE sp_delete_detalle_nomina(IN p_id_detalle INT)
BEGIN
	IF (SELECT COUNT(*) FROM DetalleNomina WHERE id_detalle = p_id_detalle) = 0 THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'ERROR: El Detalle Nómina con el id_detalle especificado no existe.';
	END IF;

	DELETE FROM DetalleNomina WHERE id_detalle = p_id_detalle;

	SELECT CONCAT('EXITO: El Detalle Nómina con id_detalle: ', p_id_detalle, ' ha sido eliminado.') AS Mensaje;
END $$


DELIMITER ;