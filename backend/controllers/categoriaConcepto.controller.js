const CategoriaConcepto = require("../models/categoriaConcepto.model");

const categoriaConceptoController = {
  createCategoriaConcepto: async (req, res) => {
    try {
      const result = await CategoriaConcepto.create(req.body);
      res.status(201).json(result);
    } catch (error) {
      console.error("🔴 Error creando CategoriaConcepto |", error);
      res.status(500).json(error);
    }
  },

  getAllCategoriasConcepto: async (req, res) => {
    try {
      const categorias = await CategoriaConcepto.findAll();
      res.status(200).json(categorias);
    } catch (error) {
      console.error("🔴 Error trayendo todos los CategoriaConcepto |", error);
      res.status(500).json(error);
    }
  },

  getCategoriaConceptoById: async (req, res) => {
    try {
      const categoriaConcepto = await CategoriaConcepto.findById(req.params.id);
      if (!categoriaConcepto) {
        res.status(404).json({ error: "🟡 CategoriaConcepto no existe" });
        return;
      }
      res.status(200).json(categoriaConcepto);
    } catch (error) {
      console.error("🔴 Error trayendo el CategoriaConcepto |", error);
      res.status(500).json(error);
    }
  },

  updateCategoriaConcepto: async (req, res) => {
    try {
      const result = await CategoriaConcepto.update(req.params.id, req.body);
      if (result.affectedRows === 0) {
        res.status(404).json({ error: "🟡 CategoriaConcepto no existe" });
        return;
      }
      res.status(200).json(result);
    } catch (error) {
      console.error("🔴 Error actualizando el CategoriaConcepto |", error);
      res.status(500).json(error);
    }
  },

  deleteCategoriaConcepto: async (req, res) => {
    try {
      const result = await CategoriaConcepto.delete(req.params.id);
      if (result.affectedRows === 0) {
        res.status(404).json({ error: "🟡 CategoriaConcepto no existe" });
        return;
      }
      res.status(204).send(); // No content
    } catch (error) {
      console.error("🔴 Error eliminando el CategoriaConcepto |", error);
      res.status(500).json(error);
    }
  },
};

module.exports = categoriaConceptoController;
