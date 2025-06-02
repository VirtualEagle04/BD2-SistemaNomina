const express = require('express');
const cargoController = require('../controllers/cargo.controller');

const router = express.Router();

router.post('/', cargoController.createCargo);
router.get('/', cargoController.getAllCargos);
router.get('/:id', cargoController.getCargoById);
router.put('/:id', cargoController.updateCargo);
router.delete('/:id', cargoController.deleteCargo);

module.exports = router;