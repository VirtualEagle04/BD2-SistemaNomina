const Jornada = require("../models/jornada.model");

const jornadaController = {
  createJornada: async (req, res) => {
    try {
      const result = await Jornada.create(req.body);
      res.status(201).json(result);
    } catch (error) {
      console.error("🔴 Error creando Jornada |", error);
      res.status(500).json(error);
    }
  },

  getAllJornadas: async (req, res) => {
    try {
      const jornadas = await Jornada.findAll();
      res.status(200).json(jornadas);
    } catch (error) {
      console.error("🔴 Error trayendo todas las Jornadas |", error);
      res.status(500).json(error);
    }
  },

  getJornadaById: async (req, res) => {
    try {
      const jornada = await Jornada.findById(req.params.id);
      if (!jornada) {
        res.status(404).json({ error: "🟡 Jornada no existe" });
        return;
      }
      res.status(200).json(jornada);
    } catch (error) {
      console.error("🔴 Error trayendo la Jornada |", error);
      res.status(500).json(error);
    }
  },

  updateJornada: async (req, res) => {
    try {
      const result = await Jornada.update(req.params.id, req.body);
      if (result.affectedRows === 0) {
        res.status(404).json({ error: "🟡 Jornada no existe" });
        return;
      }
      res.status(200).json(result);
    } catch (error) {
      console.error("🔴 Error actualizando la Jornada |", error);
      res.status(500).json(error);
    }
  },

  deleteJornada: async (req, res) => {
    try {
      const result = await Jornada.delete(req.params.id);
      if (result.affectedRows === 0) {
        res.status(404).json({ error: "🟡 Jornada no existe" });
        return;
      }
      res.status(204).send(); // No content
    } catch (error) {
      console.error("🔴 Error eliminando la Jornada |", error);
      res.status(500).json(error);
    }
  },
};

module.exports = jornadaController;
