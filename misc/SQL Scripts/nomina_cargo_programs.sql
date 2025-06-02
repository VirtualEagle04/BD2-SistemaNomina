/*
DATE: 25/05/2025
AUTHOR: Federico Vargas Rozo
DESCRIPTION: Stored Procedures for Cargo
*/

DELIMITER $$

-- INSERTAR
CREATE PROCEDURE sp_insert_cargo(
	IN p_nombre_cargo VARCHAR(50),
	IN p_salario_base INT,
	IN p_id_riesgo INT
)
BEGIN
	IF (SELECT COUNT(*) FROM ConceptoNomina WHERE id_concepto = p_id_riesgo) = 0 THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'ERROR: El Concepto Nómina con el id_concepto especificado no existe.';
	END IF;

	INSERT INTO Cargo (
		nombre_cargo, 
		salario_base,
		id_riesgo
	) 
	VALUES (
		p_nombre_cargo, 
		p_salario_base,
		p_id_riesgo
	);
	
	SELECT CONCAT('EXITO: El Cargo con nombre: ', p_nombre_cargo, ' ha sido insertado.') AS Mensaje;
END $$

-- SELECCIONAR UNO
CREATE PROCEDURE sp_select_cargo(IN p_id_cargo INT)
BEGIN
	SELECT * FROM Cargo WHERE id_cargo = p_id_cargo;
END $$

-- SELECCIONAR TODOS
CREATE PROCEDURE sp_select_cargos()
BEGIN
	SELECT * FROM Cargo;
END $$

-- ACTUALIZAR
CREATE PROCEDURE sp_update_cargo(
	IN p_id_cargo INT,
	IN p_nombre_cargo VARCHAR(50),
	IN p_salario_base INT,
	IN p_id_riesgo INT	
)
BEGIN
	IF (SELECT COUNT(*) FROM ConceptoNomina WHERE id_concepto = p_id_riesgo) = 0 THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'ERROR: El Concepto Nómina con el id_concepto especificado no existe.';
	END IF;

	IF (SELECT COUNT(*) FROM Cargo WHERE id_cargo = p_id_cargo) = 0 THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'ERROR: El Cargo con el id_cargo especificado no existe.';
	END IF;
	
	UPDATE Cargo
	SET
		nombre_cargo = p_nombre_cargo, 
		salario_base = p_salario_base,
		id_riesgo = p_id_riesgo
	WHERE id_cargo = p_id_cargo;
	
	SELECT CONCAT('EXITO: El Cargo con id_cargo: ', p_id_cargo, ' ha sido actualizado.') AS Mensaje;
END $$

-- ELIMINAR
CREATE PROCEDURE sp_delete_cargo(IN p_id_cargo INT)
BEGIN
	IF (SELECT COUNT(*) FROM Cargo WHERE id_cargo = p_id_cargo) = 0 THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'ERROR: El Cargo con el id_cargo especificado no existe.';
	END IF;

	DELETE FROM Cargo WHERE id_cargo = p_id_cargo;

	SELECT CONCAT('EXITO: El Cargo con id_cargo: ', p_id_cargo, ' ha sido eliminado.') AS Mensaje;
END $$


DELIMITER ;