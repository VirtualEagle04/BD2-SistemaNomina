/*
DATE: 25/05/2025
AUTHOR: Federico Vargas Rozo
DESCRIPTION: Functions and Stored Procedures for Nómina generation
*/

DELIMITER $$

-- Función que calcula si un Empleado es legíble para recibir el Auxilio de Transporte.
-- Un Empleado es legíble para recibir este auxilio si gana menos de 2 SMMLV.
CREATE FUNCTION fn_emp_legible_aux(p_id_empleado INT)
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE vn_salario_base INT;
    DECLARE vn_smmlv INT DEFAULT 1423500;

    SELECT C.salario_base
      INTO vn_salario_base
      FROM Empleado E
      JOIN Cargo C ON E.id_cargo = C.id_cargo
     WHERE E.id_empleado = p_id_empleado;

    RETURN vn_salario_base < (2 * vn_smmlv); -- 2847000
END$$

-- Función para traer el porcentaje dado el id_concepto
CREATE FUNCTION fn_porcentaje_cpto(p_id_concepto INT)
RETURNS FLOAT
DETERMINISTIC
BEGIN
    DECLARE vn_porcentaje FLOAT;
    SELECT porcentaje INTO vn_porcentaje
    FROM ConceptoNomina
    WHERE id_concepto = p_id_concepto;
    RETURN vn_porcentaje;
END$$

-- Función para calcular el monto_final dado el monto_aplicado y el id_concepto (para que encuentre el porcentaje)
CREATE FUNCTION fn_monto_final(p_monto_aplicado INT, p_id_concepto INT)
RETURNS INT
DETERMINISTIC
BEGIN
	RETURN ROUND(p_monto_aplicado * (fn_porcentaje_cpto(p_id_concepto) / 100));
END$$

-- Procedimiento que se debería llamar para generarle una nómina a un Empleado
CREATE PROCEDURE sp_generar_nomina(
	IN p_id_empleado INT, 
	IN p_fecha_inicio DATE, 
	IN p_fecha_fin DATE
)
BEGIN
	DECLARE vn_id_nomina INT;
	
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
		0, 
		0, 
		0,
		0,
		0,
		0
	);
	
	SET vn_id_nomina = LAST_INSERT_ID();
	
	CALL sp_insertar_detalles(vn_id_nomina, p_id_empleado, p_fecha_inicio, p_fecha_fin);
	
	SELECT CONCAT('EXITO: La Nomina con id_empleado: ', p_id_empleado, ' ha sido generada.') AS Mensaje;
END$$

-- Procedimiento para insertar todos los DetalleNomina
CREATE PROCEDURE sp_insertar_detalles(
	IN vn_id_nomina INT,
	IN vn_id_empleado INT,
	IN vd_fecha_inicio DATE,
	IN vd_fecha_fin DATE
)
BEGIN
	
	-- Variables Principales
	DECLARE vn_emp_sal INT;
	DECLARE vn_valor_aux INT DEFAULT 0;
	
	-- Devengados
	DECLARE vn_total_devengado INT DEFAULT 0;
	DECLARE vn_id_recargo INT;
	
	-- Horas Extra
	DECLARE vt_hora_fin TIME;
	DECLARE vn_id_hora_extra INT;
	DECLARE vd_tiempo_ingreso DATETIME;
	DECLARE vd_tiempo_salida DATETIME;
	
	DECLARE vn_num_horas_extra INT DEFAULT 0;
	DECLARE vn_valor_hora_ordinaria INT;
	DECLARE vn_valor_hora_extra INT;
	DECLARE vn_total_ganado_por_horas_extra INT;
	
	-- Deducciones
	DECLARE vn_total_deducido INT DEFAULT 0;
	
	-- Apropiaciones
	DECLARE vn_total_apropiado INT DEFAULT 0;
	DECLARE vn_id_riesgo INT;
	
	-- Prestaciones Sociales
	DECLARE vn_total_prestaciones INT DEFAULT 0;
	
	-- Cursores y Handlers (Horas Extra)
	DECLARE vb_fin_cursor BOOLEAN DEFAULT FALSE;
	DECLARE cur_asistencias CURSOR FOR
		SELECT tiempo_ingreso, tiempo_salida
		FROM Asistencia
		WHERE 
			id_empleado = vn_id_empleado
			AND
			DATE(tiempo_ingreso) BETWEEN vd_fecha_inicio AND vd_fecha_fin;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET vb_fin_cursor = TRUE;
	
	-- Definir Variables Principales
	SELECT C.salario_base INTO vn_emp_sal
	FROM Empleado E
	JOIN Cargo C ON E.id_cargo = C.id_cargo 
	WHERE E.id_empleado = vn_id_empleado;
	
	IF vn_emp_sal IS NULL THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'vn_emp_sal es NULL';
	END IF;
	
	IF fn_emp_legible_aux(vn_id_empleado) = 1 THEN
		SET vn_valor_aux = 200000;
	END IF;

	-- DEVENGADOS
		-- Salario Base
		INSERT INTO DetalleNomina (id_nomina, id_concepto, monto_aplicado, porcentaje_aplicado, monto_final) VALUES
			(vn_id_nomina, 25, vn_emp_sal, fn_porcentaje_cpto(25), fn_monto_final(vn_emp_sal, 25));
		SET vn_total_devengado = vn_total_devengado + fn_monto_final(vn_emp_sal, 25);
		
		-- Auxilio de Transporte
		IF fn_emp_legible_aux(vn_id_empleado) = 1 THEN
			INSERT INTO DetalleNomina (id_nomina, id_concepto, monto_aplicado, porcentaje_aplicado, monto_final) VALUES
				(vn_id_nomina, 25, 200000, fn_porcentaje_cpto(25), fn_monto_final(200000, 25));
			SET vn_total_devengado = vn_total_devengado + fn_monto_final(200000, 25);
		END IF;
		
		-- Recargo
		SELECT J.id_recargo INTO vn_id_recargo
		FROM Empleado E
		JOIN Jornada J ON J.id_jornada = E.id_jornada
		WHERE E.id_empleado = vn_id_empleado;
		
		INSERT INTO DetalleNomina (id_nomina, id_concepto, monto_aplicado, porcentaje_aplicado, monto_final) VALUES
			(vn_id_nomina, vn_id_recargo, vn_emp_sal, fn_porcentaje_cpto(vn_id_recargo), fn_monto_final(vn_emp_sal, vn_id_recargo));
		SET vn_total_devengado = vn_total_devengado + fn_monto_final(vn_emp_sal, vn_id_recargo);
		
		-- Horas Extra
		SELECT J.hora_fin, J.id_hora_extra INTO vt_hora_fin, vn_id_hora_extra
		FROM Empleado E
		JOIN Jornada J ON J.id_jornada = E.id_jornada
		WHERE E.id_empleado = vn_id_empleado;
		
		-- Calcular el número de horas extra que el Empleado realizó
		OPEN cur_asistencias;
		bucle: LOOP
			FETCH cur_asistencias INTO vd_tiempo_ingreso, vd_tiempo_salida;
			IF vb_fin_cursor THEN
				LEAVE bucle;
			END IF;
		
			-- El Empleado trabajó horas extra
			IF vd_tiempo_salida IS NOT NULL AND TIME(vd_tiempo_salida) > vt_hora_fin THEN
				SET vn_num_horas_extra = vn_num_horas_extra + TIMESTAMPDIFF(HOUR, CONCAT(DATE(vd_tiempo_salida), ' ', vt_hora_fin), vd_tiempo_salida);
			END IF;
			
		END LOOP;
		CLOSE cur_asistencias;
		
		-- Calcular el valor de la hora ordinaria
		SET vn_valor_hora_ordinaria = ROUND(vn_emp_sal / 276);
		
		-- Aplicar el % de la hora extra sobre el valor de la hora ordinaria (1 + %)
		SET vn_valor_hora_extra = ROUND(vn_valor_hora_ordinaria * (1 + (fn_porcentaje_cpto(vn_id_hora_extra) / 100)));
		
		-- Multiplicar el N° horas extra realizadas por el valor de la hora extra
		SET vn_total_ganado_por_horas_extra = vn_num_horas_extra * vn_valor_hora_extra;
		
		-- 100 + fn_porcentaje_cpto(vn_id_horas_extra) porque el porcentaje de la hora extra se aplica SOBRE el valor de la hora ordinaria: 1.25, 1.75, 2.0, 2.5
		INSERT INTO DetalleNomina (id_nomina, id_concepto, monto_aplicado, porcentaje_aplicado, monto_final) VALUES
			(vn_id_nomina, vn_id_hora_extra, vn_valor_hora_ordinaria, 100 + fn_porcentaje_cpto(vn_id_hora_extra), vn_total_ganado_por_horas_extra);
		SET vn_total_devengado = vn_total_devengado + vn_total_ganado_por_horas_extra;
	
		
	IF vn_total_devengado IS NULL THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'vn_total_devengado es NULL';
	END IF;
	-- DEDUCCIONES
		-- Salud
		INSERT INTO DetalleNomina (id_nomina, id_concepto, monto_aplicado, porcentaje_aplicado, monto_final) VALUES
			(vn_id_nomina, 9, vn_total_devengado - vn_valor_aux, fn_porcentaje_cpto(9), fn_monto_final(vn_total_devengado - vn_valor_aux, 9));
		SET vn_total_deducido = vn_total_deducido + fn_monto_final(vn_total_devengado - vn_valor_aux, 9);
		
		-- Pensión
		INSERT INTO DetalleNomina (id_nomina, id_concepto, monto_aplicado, porcentaje_aplicado, monto_final) VALUES
			(vn_id_nomina, 10, vn_total_devengado - vn_valor_aux, fn_porcentaje_cpto(10), fn_monto_final(vn_total_devengado - vn_valor_aux, 10));
		SET vn_total_deducido = vn_total_deducido + fn_monto_final(vn_total_devengado - vn_valor_aux, 10);
		
	-- APROPIACIONES
		-- Seguridad Social - Salud
		INSERT INTO DetalleNomina (id_nomina, id_concepto, monto_aplicado, porcentaje_aplicado, monto_final) VALUES
			(vn_id_nomina, 11, vn_total_devengado - vn_valor_aux, fn_porcentaje_cpto(11), fn_monto_final(vn_total_devengado - vn_valor_aux, 11));
		SET vn_total_apropiado = vn_total_apropiado + fn_monto_final(vn_total_devengado - vn_valor_aux, 11);
	
		-- Seguridad Social - Pensión
		INSERT INTO DetalleNomina (id_nomina, id_concepto, monto_aplicado, porcentaje_aplicado, monto_final) VALUES
			(vn_id_nomina, 12, vn_total_devengado - vn_valor_aux, fn_porcentaje_cpto(12), fn_monto_final(vn_total_devengado - vn_valor_aux, 12));
		SET vn_total_apropiado = vn_total_apropiado + fn_monto_final(vn_total_devengado - vn_valor_aux, 12);
	
		-- Seguridad Social - ARL
		SELECT C.id_riesgo INTO vn_id_riesgo
		FROM Empleado E
		JOIN Cargo C ON C.id_cargo = E.id_cargo
		WHERE E.id_empleado = vn_id_empleado;
		
		INSERT INTO DetalleNomina (id_nomina, id_concepto, monto_aplicado, porcentaje_aplicado, monto_final) VALUES
			(vn_id_nomina, vn_id_riesgo, vn_total_devengado - vn_valor_aux, fn_porcentaje_cpto(vn_id_riesgo), fn_monto_final(vn_total_devengado - vn_valor_aux, vn_id_riesgo));
		SET vn_total_apropiado = vn_total_apropiado + fn_monto_final(vn_total_devengado - vn_valor_aux, vn_id_riesgo);
	
		-- Aportes Parafiscales - SENA
		INSERT INTO DetalleNomina (id_nomina, id_concepto, monto_aplicado, porcentaje_aplicado, monto_final) VALUES
			(vn_id_nomina, 18, vn_total_devengado - vn_valor_aux, fn_porcentaje_cpto(18), fn_monto_final(vn_total_devengado - vn_valor_aux, 18));
		SET vn_total_apropiado = vn_total_apropiado + fn_monto_final(vn_total_devengado - vn_valor_aux, 18);
	
		-- Aportes Parafiscales - ICBF
		INSERT INTO DetalleNomina (id_nomina, id_concepto, monto_aplicado, porcentaje_aplicado, monto_final) VALUES
			(vn_id_nomina, 19, vn_total_devengado - vn_valor_aux, fn_porcentaje_cpto(19), fn_monto_final(vn_total_devengado - vn_valor_aux, 19));
		SET vn_total_apropiado = vn_total_apropiado + fn_monto_final(vn_total_devengado - vn_valor_aux, 19);
	
		-- Aportes Parafiscales - Caja de Compensación Familiar
		INSERT INTO DetalleNomina (id_nomina, id_concepto, monto_aplicado, porcentaje_aplicado, monto_final) VALUES
			(vn_id_nomina, 20, vn_total_devengado - vn_valor_aux, fn_porcentaje_cpto(20), fn_monto_final(vn_total_devengado - vn_valor_aux, 20));
		SET vn_total_apropiado = vn_total_apropiado + fn_monto_final(vn_total_devengado - vn_valor_aux, 20);
	
	-- Prestaciones Sociales
		-- Cesantias
		INSERT INTO DetalleNomina (id_nomina, id_concepto, monto_aplicado, porcentaje_aplicado, monto_final) VALUES
			(vn_id_nomina, 21, vn_emp_sal + vn_valor_aux, fn_porcentaje_cpto(21), fn_monto_final(vn_emp_sal + vn_valor_aux, 21));
		SET vn_total_prestaciones = vn_total_prestaciones + fn_monto_final(vn_emp_sal + vn_valor_aux, 21);
	
		-- Intereses de Cesantías
		INSERT INTO DetalleNomina (id_nomina, id_concepto, monto_aplicado, porcentaje_aplicado, monto_final) VALUES
			(vn_id_nomina, 22, fn_monto_final(vn_emp_sal + vn_valor_aux, 21), fn_porcentaje_cpto(22), fn_monto_final(fn_monto_final(vn_emp_sal + vn_valor_aux, 21), 22));
		SET vn_total_prestaciones = vn_total_prestaciones + fn_monto_final(fn_monto_final(vn_emp_sal + vn_valor_aux, 21), 22);
	
		-- Prima
		INSERT INTO DetalleNomina (id_nomina, id_concepto, monto_aplicado, porcentaje_aplicado, monto_final) VALUES
			(vn_id_nomina, 23, vn_emp_sal + vn_valor_aux, fn_porcentaje_cpto(23), fn_monto_final(vn_emp_sal + vn_valor_aux, 23));
		SET vn_total_prestaciones = vn_total_prestaciones + fn_monto_final(vn_emp_sal + vn_valor_aux, 23);
	
		-- Vacaciones
		INSERT INTO DetalleNomina (id_nomina, id_concepto, monto_aplicado, porcentaje_aplicado, monto_final) VALUES
			(vn_id_nomina, 24, vn_emp_sal, fn_porcentaje_cpto(24), fn_monto_final(vn_emp_sal, 24));
		SET vn_total_prestaciones = vn_total_prestaciones + fn_monto_final(vn_emp_sal, 24);
		
	UPDATE Nomina
	SET
		total_devengado = vn_total_devengado,
		total_deducido = vn_total_deducido,
		total_apropiado = vn_total_apropiado,
		total_prestaciones = vn_total_prestaciones,
		neto_pagado = vn_total_devengado - vn_total_deducido,
		gran_total = vn_total_devengado + vn_total_deducido + vn_total_apropiado + vn_total_prestaciones
	WHERE id_nomina = vn_id_nomina;
	
END$$

DELIMITER ;

-- PRUEBAS

-- SELECT TIME(A.tiempo_salida)
-- FROM Empleado E
-- JOIN Asistencia A ON A.id_empleado = E.id_empleado
-- WHERE E.id_empleado = 1;

-- SELECT TIMESTAMPDIFF(HOUR, '2025-05-22 18:00:00', '2025-05-22 10:00:00');

-- SELECT tiempo_ingreso, tiempo_salida
-- FROM Asistencia
-- WHERE 
-- 	id_empleado = 1
-- 	AND
-- 	DATE(tiempo_ingreso) BETWEEN '2025-05-02 00:00:00' AND '2025-05-31 23:59:00';

-- SELECT ROUND(1423500 / 276);
-- SELECT ROUND((1423500 / 276) * (1 + (fn_porcentaje_cpto(1) / 100)));

-- SELECT 10 * 6447;

-- SELECT 100 + fn_porcentaje_cpto(1);

-- SELECT C.salario_base
-- 	FROM Empleado E
-- 	JOIN Cargo C ON E.id_cargo = C.id_cargo 
-- 	WHERE E.id_empleado = 1;

-- SELECT LAST_INSERT_ID();

-- CALL sp_generar_nomina(1, '2025-05-01', '2025-05-31');