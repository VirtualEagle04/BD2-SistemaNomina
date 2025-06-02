const express = require('express');
const nominaController = require('../controllers/nomina.controller');

const router = express.Router();

router.post('/generar', nominaController.generateNomina);
router.post('/', nominaController.createNomina);
router.get('/', nominaController.getAllNominas);
router.get('/:id', nominaController.getNominaById);
router.put('/:id', nominaController.updateNomina);
router.delete('/:id', nominaController.deleteNomina);

module.exports = router;