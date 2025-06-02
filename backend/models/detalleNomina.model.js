const getDB = require('../config/dbConnection')
const Auditoria = require('./auditoria.model')

const DetalleNomina = {
	create: async (data) => {
		try {
			const db = await getDB();
			const [result] = await db.execute("CALL sp_insert_detalle_nomina(?, ?, ?, ?, ?)", [
				data.id_nomina,
				data.id_concepto,
				data.monto_aplicado,
				data.porcentaje_aplicado,
				data.monto_final
			]);
			await Auditoria.create({
				operacion: "INSERT",
				tabla: "DetalleNomina",
				procedimiento: "sp_insert_detalle_nomina",
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
			const [result] = await db.execute("CALL sp_select_detalles_nomina()");
			console.table(result[0]);
			return result;
		} catch (error) {
			throw error;
		}
	},
	
	findById: async (id) => {
		try {
			const db = await getDB();
			const [result] = await db.execute("CALL sp_select_detalle_nomina(?)", [parseInt(id, 10)]);
			console.table(result[0]);
			return result;
		} catch (error) {
			throw error;
		}
	},
	
	findAllById: async (id) => {
		try {
			const db = await getDB();
			const [result] = await db.execute("CALL sp_select_detalles_nomina_for_nomina(?)", [parseInt(id, 10)]);
			console.table(result[0]);
			return result;
		} catch (error) {
			throw error;
		}
	},
	
	delete: async (id) => {
		try {
			const db = await getDB();
			const [result] = await db.execute("CALL sp_delete_detalle_nomina(?)", [parseInt(id, 10)]);
			console.table(result[0]);
			return result;
		} catch (error) {
			throw error;
		}
	},
	
	update: async (id, data) => {
		try {
			const db = await getDB();
			const [result] = await db.execute("CALL sp_update_detalle_nomina(?, ?, ?, ?, ?)", [
				parseInt(id, 10),
				data.id_concepto,
				data.monto_aplicado,
				data.porcentaje_aplicado,
				data.monto_final
			]);
			console.table(result[0]);
			return result;
		} catch (error) {
			throw error;
		}
	}
};

module.exports = DetalleNomina;