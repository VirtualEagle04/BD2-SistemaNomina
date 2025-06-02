const express = require('express');
const detalleNominaController = require('../controllers/detalleNomina.controller');

const router = express.Router();

router.post('/', detalleNominaController.createDetalleNomina);
router.get('/', detalleNominaController.getAllDetallesNomina);
router.get('/:id', detalleNominaController.getDetalleNominaById);
router.get('/nomina/:nominaId', detalleNominaController.getAllDetallesNominaByIdNomina);
router.put('/:id', detalleNominaController.updateDetalleNomina);
router.delete('/:id', detalleNominaController.deleteDetalleNomina);

module.exports = router;