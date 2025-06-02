const Asistencia = require("../models/asistencia.model");

const asistenciaController = {
  createAsistencia: async (req, res) => {
    try {
      const result = await Asistencia.create(req.body);
      res.status(201).json(result);
    } catch (error) {
      console.error("🔴 Error creando Asistencia |", error);
      res.status(500).json(error);
    }
  },

  getAllAsistencias: async (req, res) => {
    try {
      const asistencias = await Asistencia.findAll();
      res.status(200).json(asistencias);
    } catch (error) {
      console.error("🔴 Error trayendo todas las Asistencias |", error);
      res.status(500).json(error);
    }
  },

  getAsistenciaById: async (req, res) => {
    try {
      const asistencia = await Asistencia.findById(req.params.id);
      if (!asistencia) {
        res.status(404).json({ error: "🟡 Asistencia no existe" });
        return;
      }
      res.status(200).json(asistencia);
    } catch (error) {
      console.error("🔴 Error trayendo la Asistencia |", error);
      res.status(500).json(error);
    }
  },

  updateAsistencia: async (req, res) => {
    try {
      const result = await Asistencia.update(req.params.id, req.body);
      if (result.affectedRows === 0) {
        res.status(404).json({ error: "🟡 Asistencia no existe" });
        return;
      }
      res.status(200).json(result);
    } catch (error) {
      console.error("🔴 Error actualizando la Asistencia |", error);
      res.status(500).json(error);
    }
  },

  deleteAsistencia: async (req, res) => {
    try {
      const result = await Asistencia.delete(req.params.id);
      if (result.affectedRows === 0) {
        res.status(404).json({ error: "🟡 Asistencia no existe" });
        return;
      }
      res.status(204).send(); // No content
    } catch (error) {
      console.error("🔴 Error eliminando la Asistencia |", error);
      res.status(500).json(error);
    }
  },
};

module.exports = asistenciaController;
