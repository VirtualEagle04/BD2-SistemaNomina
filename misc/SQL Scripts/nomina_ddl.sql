/*
DATE: 25/05/2025
AUTHOR: Federico Vargas Rozo
DESCRIPTION: Table Creation
*/

CREATE DATABASE nomina;
USE nomina;

DROP TABLE CategoriaConcepto;
CREATE TABLE IF NOT EXISTS CategoriaConcepto
(
	id_categoria INT NOT NULL AUTO_INCREMENT,
	nombre_categoria VARCHAR(50) NOT NULL,
	PRIMARY KEY (id_categoria)
);

DROP TABLE ConceptoNomina;
CREATE TABLE IF NOT EXISTS ConceptoNomina
(
	id_concepto INT NOT NULL AUTO_INCREMENT,
	nombre_concepto VARCHAR(50) NOT NULL,
	porcentaje FLOAT NOT NULL,
	id_categoria INT NOT NULL,
	PRIMARY KEY (id_concepto),
	FOREIGN KEY (id_categoria) REFERENCES CategoriaConcepto (id_categoria)
);

DROP TABLE Cargo;
CREATE TABLE IF NOT EXISTS Cargo
(
	id_cargo INT NOT NULL AUTO_INCREMENT,
	nombre_cargo VARCHAR(50) NOT NULL,
	salario_base INT NOT NULL,
	horas_trabajo INT NOT NULL,
	id_riesgo INT NOT NULL,
	PRIMARY KEY (id_cargo),
	FOREIGN KEY (id_riesgo) REFERENCES ConceptoNomina (id_concepto)
);

DROP TABLE Jornada;
CREATE TABLE IF NOT EXISTS Jornada
(
	id_jornada INT NOT NULL AUTO_INCREMENT,
	nombre_jornada VARCHAR(50) NOT NULL,
	hora_inicio TIME NOT NULL,
	hora_fin TIME NOT NULL,
	id_recargo INT NOT NULL,
	id_hora_extra INT NOT NULL,
	PRIMARY KEY (id_jornada),
	FOREIGN KEY (id_recargo) REFERENCES ConceptoNomina (id_concepto),
	FOREIGN KEY (id_hora_extra) REFERENCES ConceptoNomina (id_concepto)
);

DROP TABLE Empleado;
CREATE TABLE IF NOT EXISTS Empleado
(
	id_empleado INT NOT NULL AUTO_INCREMENT,
    cedula VARCHAR(10) NOT NULL,
    nombres VARCHAR(50) NOT NULL,
    apellidos VARCHAR(50) NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    direccion VARCHAR(100) NOT NULL,
    telefono VARCHAR(10) NOT NULL,
    email VARCHAR(50) NOT NULL,
    fecha_contratacion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    id_cargo INT NOT NULL,
    id_jornada INT NOT NULL,
    PRIMARY KEY (id_empleado),
    FOREIGN KEY (id_cargo) REFERENCES Cargo (id_cargo),
    FOREIGN KEY (id_jornada) REFERENCES Jornada (id_jornada)
);

DROP TABLE Asistencia;
CREATE TABLE IF NOT EXISTS Asistencia
(
	id_asistencia INT NOT NULL AUTO_INCREMENT,
	id_empleado INT NOT NULL,
	tiempo_ingreso DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	tiempo_salida DATETIME,
	PRIMARY KEY (id_asistencia),
	FOREIGN KEY (id_empleado) REFERENCES Empleado (id_empleado)
);

DROP TABLE Nomina;
CREATE TABLE IF NOT EXISTS Nomina
(
	id_nomina INT NOT NULL AUTO_INCREMENT,
	id_empleado INT NOT NULL,
	fecha_inicio DATE NOT NULL,
	fecha_fin DATE NOT NULL,
	fecha_liquidacion DATETIME NOT NULL,
	total_devengado INT NOT NULL,
	total_deducido INT NOT NULL,
	total_apropiado INT NOT NULL,
	total_prestaciones INT NOT NULL,
	neto_pagado INT NOT NULL, -- Total Pagado al Empleado
	gran_total INT NOT NULL, -- Total Pagado por el Empleador
	PRIMARY KEY (id_nomina),
	FOREIGN KEY (id_empleado) REFERENCES Empleado (id_empleado)
);

DROP TABLE DetalleNomina;
CREATE TABLE IF NOT EXISTS DetalleNomina
(
	id_detalle INT NOT NULL AUTO_INCREMENT,
	id_nomina INT NOT NULL,
	id_concepto INT NOT NULL,
	monto_aplicado INT NOT NULL,
	porcentaje_aplicado FLOAT NOT NULL,
	monto_final INT NOT NULL,
	PRIMARY KEY (id_detalle, id_nomina),
	FOREIGN KEY (id_nomina) REFERENCES Nomina (id_nomina),
	FOREIGN KEY (id_concepto) REFERENCES ConceptoNomina (id_concepto)
);
