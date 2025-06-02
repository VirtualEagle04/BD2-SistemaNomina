const getDB = require('../config/dbConnection')
const Auditoria = require('./auditoria.model')

const Nomina = {
	
	generate: async (data) => {
		try {
			const db = await getDB();
			const [result] = await db.execute("CALL sp_generar_nomina(?, ?, ?)", [
				data.id_empleado,
				data.fecha_inicio,
				data.fecha_fin,
			]);
			await Auditoria.create({
				tabla: "Nomina",
				procedimiento: "sp_generar_nomina",
				datos_nuevos: data
			});
			console.table(result[0]);
			return result;
		} catch (error) {
			throw error;
		}
	},
	
	create: async (data) => {
		try {
			const db = await getDB();
			const [result] = await db.execute("CALL sp_insert_nomina(?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", [
				data.id_empleado,
				data.fecha_inicio,
				data.fecha_fin,
				data.fecha_liquidacion,
				data.total_devengado,
				data.total_deducido,
				data.total_apropiado,
				data.total_prestaciones,
				data.neto_pagado,
				data.gran_total,
			]);
			await Auditoria.create({
				operacion: "INSERT",
				tabla: "Nomina",
				procedimiento: "sp_insert_nomina",
				datos_nuevos: data
			});
			console.table(result[0]);
			return result;
		} catch (error) {
			throw error;
		}
	},
	
	findAll: async () => {
		try {
			const db = await getDB();
			const [result] = await db.execute("CALL sp_select_nominas()");
			console.table(result[0]);
			return result;
		} catch (error) {
			throw error;
		}
	},
	
	findById: async (id) => {
		try {
			const db = await getDB();
			const [result] = await db.execute("CALL sp_select_nomina(?)", [parseInt(id, 10)]);
			console.table(result[0]);
			return result;
		} catch (error) {
			throw error;
		}
	},
	
	delete: async (id) => {
		try {
			const db = await getDB();
			// Obtener datos previos antes de eliminar
            const [prevResult] = await db.execute("CALL sp_select_nomina(?)", [parseInt(id, 10)]);
            const datosPrevios = prevResult[0] && prevResult[0][0] ? prevResult[0][0] : null;
			
			const [result] = await db.execute("CALL sp_delete_nomina(?)", [parseInt(id, 10)]);
			await Auditoria.create({
				operacion: "DELETE",
				tabla: "Nomina",
				procedimiento: "sp_delete_nomina",
				id: id,
				datos_previos: datosPrevios
			});
			console.table(result[0]);
			return result;
		} catch (error) {
			throw error;
		}
	},
	
	update: async (id, data) => {
		try {
			const db = await getDB();
			// Obtener datos previos antes de eliminar
            const [prevResult] = await db.execute("CALL sp_select_nomina(?)", [parseInt(id, 10)]);
            const datosPrevios = prevResult[0] && prevResult[0][0] ? prevResult[0][0] : null;
			
			const [result] = await db.execute("CALL sp_update_nomina(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", [
				parseInt(id, 10),
				data.id_empleado,
				data.fecha_inicio,
				data.fecha_fin,
				data.fecha_liquidacion,
				data.total_devengado,
				data.total_deducido,
				data.total_apropiado,
				data.total_prestaciones,
				data.neto_pagado,
				data.gran_total,
			]);
			await Auditoria.create({
				operacion: "UPDATE",
				tabla: "Nomina",
				procedimiento: "sp_update_nomina",
				id: id,
				datos_previos: datosPrevios,
				datos_nuevos: data
			});
			console.table(result[0]);
			return result;
		} catch (error) {
			throw error;
		}
	}
};

module.exports = Nomina;