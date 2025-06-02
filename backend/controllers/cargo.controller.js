const Cargo = require("../models/cargo.model");

const cargoController = {
  createCargo: async (req, res) => {
    try {
      const result = await Cargo.create(req.body);
      res.status(201).json(result);
    } catch (error) {
      console.error("🔴 Error creando Cargo |", error);
      res.status(500).json(error);
    }
  },

  getAllCargos: async (req, res) => {
    try {
      const cargos = await Cargo.findAll();
      res.status(200).json(cargos);
    } catch (error) {
      console.error("🔴 Error trayendo todos los Empleados |", error);
      res.status(500).json(error);
    }
  },

  getCargoById: async (req, res) => {
    try {
      const cargo = await Cargo.findById(req.params.id);
      if (!cargo) {
        res.status(404).json({ error: "🟡 Cargo no existe" });
        return;
      }
      res.status(200).json(cargo);
    } catch (error) {
      console.error("🔴 Error trayendo el Cargo |", error);
      res.status(500).json(error);
    }
  },

  updateCargo: async (req, res) => {
    try {
      const result = await Cargo.update(req.params.id, req.body);
      if (result.affectedRows === 0) {
        res.status(404).json({ error: "🟡 Cargo no existe" });
        return;
      }
      res.status(200).json(result);
    } catch (error) {
      console.error("🔴 Error actualizando el Cargo |", error);
      res.status(500).json(error);
    }
  },

  deleteCargo: async (req, res) => {
    try {
      const result = await Cargo.delete(req.params.id);
      if (result.affectedRows === 0) {
        res.status(404).json({ error: "🟡 Cargo no existe" });
        return;
      }
      res.status(204).send(); // No content
    } catch (error) {
      console.error("🔴 Error eliminando el Cargo |", error);
      res.status(500).json(error);
    }
  },
};

module.exports = cargoController;
