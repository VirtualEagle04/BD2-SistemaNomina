const express = require('express');
const jornadaController = require('../controllers/jornada.controller');

const router = express.Router();

router.post('/', jornadaController.createJornada);
router.get('/', jornadaController.getAllJornadas);
router.get('/:id', jornadaController.getJornadaById);
router.put('/:id', jornadaController.updateJornada);
router.delete('/:id', jornadaController.deleteJornada);

module.exports = router;