const getDB = require('../config/dbConnection')
const Auditoria = require('./auditoria.model')

const Empleado = {
	create: async (data) => {
		try {
			const db = await getDB();
			const [result] = await db.execute("CALL sp_insert_empleado(?, ?, ?, ?, ?, ?, ?, ?, ?)", [
				data.cedula,
				data.nombres,
				data.apellidos,
				data.fecha_nacimiento,
				data.direccion,
				data.telefono,
				data.email,
				data.id_cargo,
				data.id_jornada,
			]);
			await Auditoria.create({
				operacion: "INSERT",
				tabla: "Empleado",
				procedimiento: "sp_insert_empleado",
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
			const [result] = await db.execute("CALL sp_select_empleados()");
			console.table(result[0]);
			return result;
		} catch (error) {
			throw error;
		}
	},
	
	findById: async (id) => {
		try {
			const db = await getDB();
			const [result] = await db.execute("CALL sp_select_empleado(?)", [parseInt(id, 10)]);
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
            const [prevResult] = await db.execute("CALL sp_select_empleado(?)", [parseInt(id, 10)]);
            const datosPrevios = prevResult[0] && prevResult[0][0] ? prevResult[0][0] : null;
			
			const [result] = await db.execute("CALL sp_delete_empleado(?)", [parseInt(id, 10)]);
			await Auditoria.create({
				operacion: "DELETE",
				tabla: "Empleado",
				procedimiento: "sp_delete_empleado",
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
			// Obtener datos previos antes de actualizar
			const [prevResult] = await db.execute("CALL sp_select_empleado(?)", [parseInt(id, 10)]);
			const datosPrevios = prevResult[0] && prevResult[0][0] ? prevResult[0][0] : null;

			const [result] = await db.execute("CALL sp_update_empleado(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", [
				parseInt(id, 10),
				data.cedula,
				data.nombres,
				data.apellidos,
				data.fecha_nacimiento,
				data.direccion,
				data.telefono,
				data.email,
				data.fecha_contratacion,
				data.id_cargo,
				data.id_jornada,
			]);
			await Auditoria.create({
				operacion: "UPDATE",
				tabla: "Empleado",
				procedimiento: "sp_update_empleado",
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

module.exports = Empleado;