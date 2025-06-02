/*
DATE: 25/05/2025
AUTHOR: Federico Vargas Rozo
DESCRIPTION: Stored Procedures for ConceptoNomina
*/

DELIMITER $$

-- INSERTAR
CREATE PROCEDURE sp_insert_concepto_nomina(
	IN p_nombre_concepto VARCHAR(50),
	IN p_porcentaje FLOAT,
	IN p_id_categoria INT
)
BEGIN
	IF (SELECT COUNT(*) FROM CategoriaConcepto WHERE id_categoria = p_id_categoria) = 0 THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'ERROR: La Categoría Concepto con el id_categoria especificada no existe.';
	END IF;

	INSERT INTO ConceptoNomina (
		nombre_concepto,
        porcentaje,
        id_categoria
	) 
	VALUES (
		p_nombre_concepto,
        p_porcentaje,
        p_id_categoria
	);
	
	SELECT CONCAT('EXITO: El Concepto Nómina con nombre: ', p_nombre_concepto, ' ha sido insertado.') AS Mensaje;
END $$

-- SELECCIONAR UNO
CREATE PROCEDURE sp_select_concepto_nomina(IN p_id_concepto INT)
BEGIN
	SELECT * FROM ConceptoNomina WHERE id_concepto = p_id_concepto;
END $$

-- SELECCIONAR TODOS
CREATE PROCEDURE sp_select_conceptos_nomina()
BEGIN
	SELECT * FROM ConceptoNomina;
END $$

-- ACTUALIZAR
CREATE PROCEDURE sp_update_concepto_nomina(
	IN p_id_concepto INT,
	IN p_nombre_concepto VARCHAR(50),
	IN p_porcentaje FLOAT,
	IN p_id_categoria INT	
)
BEGIN
	IF (SELECT COUNT(*) FROM CategoriaConcepto WHERE id_categoria = p_id_categoria) = 0 THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'ERROR: La Categoría Concepto con el id_categoria especificada no existe.';
	END IF;

	IF (SELECT COUNT(*) FROM ConceptoNomina WHERE id_concepto = p_id_concepto) = 0 THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'ERROR: El Concepto Nómina con el id_concepto especificado no existe.';
	END IF;

	UPDATE ConceptoNomina
	SET
		nombre_concepto = p_nombre_concepto,
        porcentaje = p_porcentaje,
        id_categoria = p_id_categoria
	WHERE id_concepto = p_id_concepto;

	SELECT CONCAT('EXITO: El Concepto Nómina con id_concepto: ', p_id_concepto, ' ha sido actualizado.') AS Mensaje;
END $$

-- ELIMINAR
CREATE PROCEDURE sp_delete_concepto_nomina(IN p_id_concepto INT)
BEGIN
	IF (SELECT COUNT(*) FROM ConceptoNomina WHERE id_concepto = p_id_concepto) = 0 THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'ERROR: El Concepto Nómina con el id_concepto especificado no existe.';
	END IF;

	DELETE FROM ConceptoNomina WHERE id_concepto = p_id_concepto;

	SELECT CONCAT('EXITO: El Concepto Nómina con id_concepto: ', p_id_concepto, ' ha sido eliminado.') AS Mensaje;
END $$


DELIMITER ;