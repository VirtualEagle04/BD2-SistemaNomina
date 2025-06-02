/*
DATE: 25/05/2025
AUTHOR: Federico Vargas Rozo
DESCRIPTION: Stored Procedures for Nomina
*/

DELIMITER $$

-- INSERTAR
CREATE PROCEDURE sp_insert_nomina(
	IN p_id_empleado INT,
	IN p_fecha_inicio DATE,
	IN p_fecha_fin DATE,
	IN p_total_devengado INT,
	IN p_total_deducido INT,
	IN p_total_apropiado INT,
	IN p_total_prestaciones INT,
	IN p_neto_pagado INT,
	IN p_gran_total INT
)
BEGIN
	IF (SELECT COUNT(*) FROM Empleado WHERE id_empleado = p_id_empleado) = 0 THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'ERROR: El Empleado con el id_empleado especificado no existe.';
	END IF;

	INSERT INTO Nomina (
		id_empleado, 
		fecha_inicio, 
		fecha_fin, 
		fecha_liquidacion, 
		total_devengado, 
		total_deducido, 
		total_apropiado,
		total_prestaciones,
		neto_pagado,
		gran_total
	) 
	VALUES (
		p_id_empleado, 
		p_fecha_inicio, 
		p_fecha_fin, 
		NOW(), 
		p_total_devengado, 
		p_total_deducido, 
		p_total_apropiado,
		p_total_prestaciones,
		p_neto_pagado,
		p_gran_total
	);
	
	SELECT CONCAT('EXITO: La Nomina con id_empleado: ', p_id_empleado, ' ha sido insertado.') AS Mensaje;
END $$

-- SELECCIONAR UNA
CREATE PROCEDURE sp_select_nomina(IN p_id_nomina INT)
BEGIN
	SELECT * FROM Nomina WHERE id_nomina = p_id_nomina;
END $$

-- SELECCIONAR TODAS
CREATE PROCEDURE sp_select_nominas()
BEGIN
	SELECT * FROM Nomina;
END $$

-- ACTUALIZAR
CREATE PROCEDURE sp_update_nomina(
	IN p_id_nomina INT,
	IN p_id_empleado INT,
	IN p_fecha_inicio DATE,
	IN p_fecha_fin DATE,
	IN p_fecha_liquidacion DATETIME,
	IN p_total_devengado INT,
	IN p_total_deducido INT,
	IN p_total_apropiado INT,
	IN p_total_prestaciones INT,
	IN p_neto_pagado INT,
	IN p_gran_total INT	
)
BEGIN
	IF (SELECT COUNT(*) FROM Empleado WHERE id_empleado = p_id_empleado) = 0 THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'ERROR: El Empleado con el id_empleado especificado no existe.';
	END IF;

	IF (SELECT COUNT(*) FROM Nomina WHERE id_nomina = p_id_nomina) = 0 THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'ERROR: La Nomina con el id_nomina especificada no existe.';
	END IF;
	
	UPDATE Nomina
	SET
		id_empleado = p_id_empleado, 
		fecha_inicio = p_fecha_inicio, 
		fecha_fin = p_fecha_fin, 
		fecha_liquidacion = p_fecha_liquidacion, 
		total_devengado = p_total_devengado, 
		total_deducido = p_total_deducido, 
		total_apropiado = p_total_apropiado,
		total_prestaciones = p_total_prestaciones,
		neto_pagado = p_neto_pagado,
		gran_total = p_gran_total
	WHERE id_nomina = p_id_nomina;
	
	SELECT CONCAT('EXITO: La Nomina con id_nomina: ', p_id_nomina, ' ha sido actualizado.') AS Mensaje;
END $$

-- ELIMINAR
CREATE PROCEDURE sp_delete_nomina(IN p_id_nomina INT)
BEGIN
	IF (SELECT COUNT(*) FROM Nomina WHERE id_nomina = p_id_nomina) = 0 THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'ERROR: El Nomina con el id_nomina especificado no existe.';
	END IF;

	DELETE FROM Nomina WHERE id_nomina = p_id_nomina;
	
	SELECT CONCAT('EXITO: La Nomina con id_nomina: ', p_id_nomina, ' ha sido eliminado.') AS Mensaje;
END $$


DELIMITER ;