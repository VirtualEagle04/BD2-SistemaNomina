const express = require('express');
const empleadoController = require('../controllers/empleado.controller');

const router = express.Router();

router.post('/', empleadoController.createEmpleado);
router.get('/', empleadoController.getAllEmpleados);
router.get('/:id', empleadoController.getEmpleadoById);
router.put('/:id', empleadoController.updateEmpleado);
router.delete('/:id', empleadoController.deleteEmpleado);

module.exports = router;