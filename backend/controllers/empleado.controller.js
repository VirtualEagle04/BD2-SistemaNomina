const Empleado = require("../models/empleado.model");

const empleadoController = {
  createEmpleado: async (req, res) => {
    try {
      const result = await Empleado.create(req.body);
      res.status(201).json(result);
    } catch (error) {
      console.error("🔴 Error creando Empleado |", error);
      res.status(500).json(error);
    }
  },

  getAllEmpleados: async (req, res) => {
    try {
      const empleados = await Empleado.findAll();
      res.status(200).json(empleados);
    } catch (error) {
      console.error("🔴 Error trayendo todos los Empleados |", error);
      res.status(500).json(error);
    }
  },

  getEmpleadoById: async (req, res) => {
    try {
      const empleado = await Empleado.findById(req.params.id);
      if (!empleado) {
        res.status(404).json({ error: "🟡 Empleado no existe" });
        return;
      }
      res.status(200).json(empleado);
    } catch (error) {
      console.error("🔴 Error trayendo el Empleado |", error);
      res.status(500).json(error);
    }
  },

  updateEmpleado: async (req, res) => {
    try {
      const result = await Empleado.update(req.params.id, req.body);
      if (result.affectedRows === 0) {
        res.status(404).json({ error: "🟡 Empleado no existe" });
        return;
      }
      res.status(200).json(result);
    } catch (error) {
      console.error("🔴 Error actualizando el Empleado |", error);
      res.status(500).json(error);
    }
  },

  deleteEmpleado: async (req, res) => {
    try {
      const result = await Empleado.delete(req.params.id);
      if (result.affectedRows === 0) {
        res.status(404).json({ error: "🟡 Empleado no existe" });
        return;
      }
      res.status(204).send(); // No content
    } catch (error) {
      console.error("🔴 Error eliminando el Empleado |", error);
      res.status(500).json(error);
    }
  },
};

module.exports = empleadoController;
