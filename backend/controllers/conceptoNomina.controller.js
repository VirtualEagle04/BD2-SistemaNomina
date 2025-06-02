const ConceptoNomina = require("../models/conceptoNomina.model");

const conceptoNominaController = {
  createConceptoNomina: async (req, res) => {
    try {
      const result = await ConceptoNomina.create(req.body);
      res.status(201).json(result);
    } catch (error) {
      console.error("🔴 Error creando ConceptoNomina |", error);
      res.status(500).json(error);
    }
  },

  getAllConceptosNomina: async (req, res) => {
    try {
      const conceptos = await ConceptoNomina.findAll();
      res.status(200).json(conceptos);
    } catch (error) {
      console.error("🔴 Error trayendo todos los ConceptosNomina |", error);
      res.status(500).json(error);
    }
  },

  getConceptoNominaById: async (req, res) => {
    try {
      const conceptoNomina = await ConceptoNomina.findById(req.params.id);
      if (!conceptoNomina) {
        res.status(404).json({ error: "🟡 ConceptoNomina no existe" });
        return;
      }
      res.status(200).json(conceptoNomina);
    } catch (error) {
      console.error("🔴 Error trayendo el ConceptoNomina |", error);
      res.status(500).json(error);
    }
  },

  updateConceptoNomina: async (req, res) => {
    try {
      const result = await ConceptoNomina.update(req.params.id, req.body);
      if (result.affectedRows === 0) {
        res.status(404).json({ error: "🟡 ConceptoNomina no existe" });
        return;
      }
      res.status(200).json(result);
    } catch (error) {
      console.error("🔴 Error actualizando el ConceptoNomina |", error);
      res.status(500).json(error);
    }
  },

  deleteConceptoNomina: async (req, res) => {
    try {
      const result = await ConceptoNomina.delete(req.params.id);
      if (result.affectedRows === 0) {
        res.status(404).json({ error: "🟡 ConceptoNomina no existe" });
        return;
      }
      res.status(204).send(); // No content
    } catch (error) {
      console.error("🔴 Error eliminando el ConceptoNomina |", error);
      res.status(500).json(error);
    }
  },
};

module.exports = conceptoNominaController;
