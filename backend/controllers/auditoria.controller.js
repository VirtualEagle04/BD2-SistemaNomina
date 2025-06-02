const Auditoria = require('../models/auditoria.model');

const auditoriaController = {
    getAllAuditoria: async (req, res) => {
        try {
            const auditorias = await Auditoria.findAll();
            res.status(200).json(auditorias);
        } catch (error) {
            console.error("🔴 Error trayendo auditoría |", error);
            res.status(500).json(error);
        }
    }
};

module.exports = auditoriaController;