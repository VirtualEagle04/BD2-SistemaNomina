const express = require('express');
const conceptoNominaController = require('../controllers/conceptoNomina.controller');

const router = express.Router();

router.post('/', conceptoNominaController.createConceptoNomina);
router.get('/', conceptoNominaController.getAllConceptosNomina);
router.get('/:id', conceptoNominaController.getConceptoNominaById);
router.put('/:id', conceptoNominaController.updateConceptoNomina);
router.delete('/:id', conceptoNominaController.deleteConceptoNomina);

module.exports = router;