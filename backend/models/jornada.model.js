const getDB = require('../config/dbConnection')
const Auditoria = require('./auditoria.model')

const Jornada = {
	create: async (data) => {
		try {
			const db = await getDB();
			const [result] = await db.execute("CALL sp_insert_jornada(?, ?, ?, ?, ?)", [
				data.nombre_jornada,
				data.hora_inicio,
				data.hora_fin,
				data.id_recargo,
				data.id_hora_extra
			]);
			await Auditoria.create({
				operacion: "INSERT",
				tabla: "Jornada",
				procedimiento: "sp_insert_jornada",
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
			const [result] = await db.execute("CALL sp_select_jornadas()");
			console.table(result[0]);
			return result;
		} catch (error) {
			throw error;
		}
	},
	
	findById: async (id) => {
		try {
			const db = await getDB();
			const [result] = await db.execute("CALL sp_select_jornada(?)", [parseInt(id, 10)]);
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
            const [prevResult] = await db.execute("CALL sp_select_jornada(?)", [parseInt(id, 10)]);
            const datosPrevios = prevResult[0] && prevResult[0][0] ? prevResult[0][0] : null;
			
			const [result] = await db.execute("CALL sp_delete_jornada(?)", [parseInt(id, 10)]);
			await Auditoria.create({
				operacion: "DELETE",
				tabla: "Jornada",
				procedimiento: "sp_delete_jornada",
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
            const [prevResult] = await db.execute("CALL sp_select_jornada(?)", [parseInt(id, 10)]);
            const datosPrevios = prevResult[0] && prevResult[0][0] ? prevResult[0][0] : null;
			
			const [result] = await db.execute("CALL sp_update_jornada(?, ?, ?, ?, ?, ?)", [
				parseInt(id, 10),
				data.nombre_jornada,
				data.hora_inicio,
				data.hora_fin,
				data.id_recargo,
				data.id_hora_extra
			]);
			await Auditoria.create({
				operacion: "UPDATE",
				tabla: "Jornada",
				procedimiento: "sp_update_jornada",
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

module.exports = Jornada;