const express = require('express');
const categoriaConceptoController = require('../controllers/categoriaConcepto.controller');

const router = express.Router();

router.post('/', categoriaConceptoController.createCategoriaConcepto);
router.get('/', categoriaConceptoController.getAllCategoriasConcepto);
router.get('/:id', categoriaConceptoController.getCategoriaConceptoById);
router.put('/:id', categoriaConceptoController.updateCategoriaConcepto);
router.delete('/:id', categoriaConceptoController.deleteCategoriaConcepto);

module.exports = router;