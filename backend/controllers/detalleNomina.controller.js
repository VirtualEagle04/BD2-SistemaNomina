const DetalleNomina = require("../models/detalleNomina.model");

const detalleNominaController = {
  createDetalleNomina: async (req, res) => {
    try {
      const result = await DetalleNomina.create(req.body);
      res.status(201).json(result);
    } catch (error) {
      console.error("🔴 Error creando Detalle Nomina |", error);
      res.status(500).json(error);
    }
  },

  getAllDetallesNomina: async (req, res) => {
    try {
      const detalles = await DetalleNomina.findAll();
      res.status(200).json(detalles);
    } catch (error) {
      console.error("🔴 Error trayendo todos los Detalles de Nomina |", error);
      res.status(500).json(error);
    }
  },

  getDetalleNominaById: async (req, res) => {
    try {
      const detalle = await DetalleNomina.findById(req.params.id);
      if (!detalle) {
        res.status(404).json({ error: "🟡 Detalle de Nomina no existe" });
        return;
      }
      res.status(200).json(detalle);
    } catch (error) {
      console.error("🔴 Error trayendo el Detalle de Nomina |", error);
      res.status(500).json(error);
    }
  },
  
  getAllDetallesNominaByIdNomina: async (req, res) => {
    try {
      const detalles = await DetalleNomina.findAllById(req.params.id);
      if (!detalles) {
        res.status(404).json({ error: "🟡 Detalles de Nomina no existen" });
        return;
      }
      res.status(200).json(detalles);
    } catch (error) {
      console.error("🔴 Error trayendo los Detalles de Nomina |", error);
      res.status(500).json(error);
    }
  },

  updateDetalleNomina: async (req, res) => {
    try {
      const result = await DetalleNomina.update(req.params.id, req.body);
      if (result.affectedRows === 0) {
        res.status(404).json({ error: "🟡 Detalle de Nomina no existe" });
        return;
      }
      res.status(200).json(result);
    } catch (error) {
      console.error("🔴 Error actualizando el Detalle de Nomina |", error);
      res.status(500).json(error);
    }
  },

  deleteDetalleNomina: async (req, res) => {
    try {
      const result = await DetalleNomina.delete(req.params.id);
      if (result.affectedRows === 0) {
        res.status(404).json({ error: "🟡 Detalle de Nomina no existe" });
        return;
      }
      res.status(204).send(); // No content
    } catch (error) {
      console.error("🔴 Error eliminando el Detalle de Nomina |", error);
      res.status(500).json(error);
    }
  },
};

module.exports = detalleNominaController;
