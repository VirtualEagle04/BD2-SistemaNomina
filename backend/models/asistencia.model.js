const getDB = require('../config/dbConnection')
const Auditoria = require('./auditoria.model')

const Asistencia = {
	create: async (data) => {
		try {
			const db = await getDB();
			const [result] = await db.execute("CALL sp_insert_asistencia(?, ?, ?)", [
				data.id_empleado,
				data.tiempo_ingreso,
				data.tiempo_salida,
			]);
			await Auditoria.create({
				operacion: "INSERT",
				tabla: "Asistencia",
				procedimiento: "sp_insert_asistencia",
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
			const [result] = await db.execute("CALL sp_select_asistencias()");
			console.table(result[0]);
			return result;
		} catch (error) {
			throw error;
		}
	},
	
	findById: async (id) => {
		try {
			const db = await getDB();
			const [result] = await db.execute("CALL sp_select_asistencia(?)", [parseInt(id, 10)]);
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
            const [prevResult] = await db.execute("CALL sp_select_asistencia(?)", [parseInt(id, 10)]);
            const datosPrevios = prevResult[0] && prevResult[0][0] ? prevResult[0][0] : null;
			
			const [result] = await db.execute("CALL sp_delete_asistencia(?)", [parseInt(id, 10)]);
			await Auditoria.create({
				operacion: "DELETE",
				tabla: "Asistencia",
				procedimiento: "sp_delete_asistencia",
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
            const [prevResult] = await db.execute("CALL sp_select_asistencia(?)", [parseInt(id, 10)]);
            const datosPrevios = prevResult[0] && prevResult[0][0] ? prevResult[0][0] : null;
			
			const [result] = await db.execute("CALL sp_update_asistencia(?, ?, ?, ?)", [
				parseInt(id, 10),
				data.id_empleado,
				data.tiempo_ingreso,
				data.tiempo_salida,
			]);
			await Auditoria.create({
				operacion: "UPDATE",
				tabla: "Asistencia",
				procedimiento: "sp_update_asistencia",
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

module.exports = Asistencia;