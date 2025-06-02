/*
DATE: 25/05/2025
AUTHOR: Federico Vargas Rozo
DESCRIPTION: Stored Procedures for CategoriaConcepto
*/

DELIMITER $$

-- INSERTAR
CREATE PROCEDURE sp_insert_categoria_concepto(
	IN p_nombre_categoria VARCHAR(50)
)
BEGIN

	INSERT INTO CategoriaConcepto (
		nombre_categoria
	) 
	VALUES (
		p_nombre_categoria
	);
	
	SELECT CONCAT('EXITO: La Categoría Concepto con nombre: ', p_nombre_categoria, ' ha sido insertada.') AS Mensaje;
END $$

-- SELECCIONAR UNA
CREATE PROCEDURE sp_select_categoria_concepto(IN p_id_categoria INT)
BEGIN
	SELECT * FROM CategoriaConcepto WHERE id_categoria = p_id_categoria;
END $$

-- SELECCIONAR TODAS
CREATE PROCEDURE sp_select_categorias_concepto()
BEGIN
	SELECT * FROM CategoriaConcepto;
END $$

-- ACTUALIZAR
CREATE PROCEDURE sp_update_categoria_concepto(
	IN p_id_categoria INT,
	IN p_nombre_categoria VARCHAR(50)	
)
BEGIN
	IF (SELECT COUNT(*) FROM CategoriaConcepto WHERE id_categoria = p_id_categoria) = 0 THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'ERROR: La Categoría Concepto con el id_categoria especificado no existe.';
	END IF;
	
	UPDATE CategoriaConcepto
	SET
		nombre_categoria = p_nombre_categoria
	WHERE id_categoria = p_id_categoria;

	SELECT CONCAT('EXITO: La Categoría Concepto con id_categoria: ', p_id_categoria, ' ha sido actualizada.') AS Mensaje;
END $$

-- ELIMINAR
CREATE PROCEDURE sp_delete_categoria_concepto(IN p_id_categoria INT)
BEGIN
	IF (SELECT COUNT(*) FROM CategoriaConcepto WHERE id_categoria = p_id_categoria) = 0 THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'ERROR: La Categoría Concepto con el id_categoria especificado no existe.';
	END IF;

	DELETE FROM CategoriaConcepto WHERE id_categoria = p_id_categoria;

	SELECT CONCAT('EXITO: La Categoría Concepto con id_categoria: ', p_id_categoria, ' ha sido eliminada.') AS Mensaje;
END $$


DELIMITER ;