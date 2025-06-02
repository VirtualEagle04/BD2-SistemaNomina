const Nomina = require("../models/nomina.model");

const nominaController = {
  generateNomina: async (req, res) => {
    try {
      const result = await Nomina.generate(req.body);
      res.status(201).json(result);
    } catch (error) {
      console.error("🔴 Error generando Nomina |", error);
      res.status(500).json(error);
    }
  },
  
  createNomina: async (req, res) => {
    try {
      const result = await Nomina.create(req.body);
      res.status(201).json(result);
    } catch (error) {
      console.error("🔴 Error creando Nomina |", error);
      res.status(500).json(error);
    }
  },

  getAllNominas: async (req, res) => {
    try {
      const nominas = await Nomina.findAll();
      res.status(200).json(nominas);
    } catch (error) {
      console.error("🔴 Error trayendo todas las Nominas |", error);
      res.status(500).json(error);
    }
  },

  getNominaById: async (req, res) => {
    try {
      const nomina = await Nomina.findById(req.params.id);
      if (!nomina) {
        res.status(404).json({ error: "🟡 Nomina no existe" });
        return;
      }
      res.status(200).json(nomina);
    } catch (error) {
      console.error("🔴 Error trayendo la Nomina |", error);
      res.status(500).json(error);
    }
  },

  updateNomina: async (req, res) => {
    try {
      const result = await Nomina.update(req.params.id, req.body);
      if (result.affectedRows === 0) {
        res.status(404).json({ error: "🟡 Nomina no existe" });
        return;
      }
      res.status(200).json(result);
    } catch (error) {
      console.error("🔴 Error actualizando la Nomina |", error);
      res.status(500).json(error);
    }
  },

  deleteNomina: async (req, res) => {
    try {
      const result = await Nomina.delete(req.params.id);
      if (result.affectedRows === 0) {
        res.status(404).json({ error: "🟡 Nomina no existe" });
        return;
      }
      res.status(204).send(); // No content
    } catch (error) {
      console.error("🔴 Error eliminando la Nomina |", error);
      res.status(500).json(error);
    }
  },
};

module.exports = nominaController;
