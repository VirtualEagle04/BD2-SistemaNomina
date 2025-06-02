const express = require('express');
const asistenciaController = require('../controllers/asistencia.controller');

const router = express.Router();

router.post('/', asistenciaController.createAsistencia);
router.get('/', asistenciaController.getAllAsistencias);
router.get('/:id', asistenciaController.getAsistenciaById);
router.put('/:id', asistenciaController.updateAsistencia);
router.delete('/:id', asistenciaController.deleteAsistencia);

module.exports = router;