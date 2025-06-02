const getDB = require('../config/dbConnection')
const Auditoria = require('./auditoria.model')

const ConceptoNomina = {
	create: async (data) => {
		try {
			const db = await getDB();
			const [result] = await db.execute("CALL sp_insert_concepto_nomina(?, ?, ?)", [
				data.nombre_concepto,
				data.porcentaje,
				data.id_categoria
			]);
			await Auditoria.create({
				operacion: "INSERT",
				tabla: "ConceptoNomina",
				procedimiento: "sp_insert_concepto_nomina",
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
			const [result] = await db.execute("CALL sp_select_conceptos_nomina()");
			console.table(result[0]);
			return result;
		} catch (error) {
			throw error;
		}
	},
	
	findById: async (id) => {
		try {
			const db = await getDB();
			const [result] = await db.execute("CALL sp_select_concepto_nomina(?)", [parseInt(id, 10)]);
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
            const [prevResult] = await db.execute("CALL sp_select_concepto_nomina(?)", [parseInt(id, 10)]);
            const datosPrevios = prevResult[0] && prevResult[0][0] ? prevResult[0][0] : null;
			
			const [result] = await db.execute("CALL sp_delete_concepto_nomina(?)", [parseInt(id, 10)]);
			await Auditoria.create({
				operacion: "DELETE",
				tabla: "ConceptoNomina",
				procedimiento: "sp_delete_concepto_nomina",
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
            const [prevResult] = await db.execute("CALL sp_select_concepto_nomina(?)", [parseInt(id, 10)]);
            const datosPrevios = prevResult[0] && prevResult[0][0] ? prevResult[0][0] : null;
			
			const [result] = await db.execute("CALL sp_update_concepto_nomina(?, ?, ?, ?)", [
				parseInt(id, 10),
				data.nombre_concepto,
				data.porcentaje,
				data.id_categoria
			]);
			await Auditoria.create({
				operacion: "UPDATE",
				tabla: "ConceptoNomina",
				procedimiento: "sp_update_concepto_nomina",
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

module.exports = ConceptoNomina;