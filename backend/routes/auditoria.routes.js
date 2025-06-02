const express = require('express');
const auditoriaController = require('../controllers/auditoria.controller');

const router = express.Router();

router.get('/', auditoriaController.getAllAuditoria);

module.exports = router;