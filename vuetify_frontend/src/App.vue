<template>
  <v-app>
    <!-- expand-on-hover rail -->
    <v-navigation-drawer app expand-on-hover rail>
      <v-list>
        <v-list-item prepend-icon="mdi-shape" title="Categoría Concepto" value="categoriaConcepto" @click="selected = 'categoriaConcepto'"></v-list-item>
        <v-list-item prepend-icon="mdi-percent-box" title="Concepto Nómina" value="conceptoNomina" @click="selected = 'conceptoNomina'"></v-list-item>
        <v-list-item prepend-icon="mdi-briefcase" title="Cargo" value="cargo" @click="selected = 'cargo'"></v-list-item>
        <v-list-item prepend-icon="mdi-account" title="Empleado" value="empleado" @click="selected = 'empleado'"></v-list-item>
        <v-list-item prepend-icon="mdi-timer-sand" title="Jornada" value="jornada" @click="selected = 'jornada'"></v-list-item>
        <v-list-item prepend-icon="mdi-calendar-account-outline" title="Asistencia" value="asistencia" @click="selected = 'asistencia'"></v-list-item>
        <v-list-item prepend-icon="mdi-cash-100" title="Nómina" value="nomina" @click="selected = 'nomina'"></v-list-item>
        <v-list-item prepend-icon="mdi-clipboard-text" title="Detalle Nomina" value="detalleNomina" @click="selected = 'detalleNomina'"></v-list-item>
        <v-list-item prepend-icon="mdi-list-box-outline" title="Auditoría" value="auditoria" @click="selected = 'auditoria'"></v-list-item>
      </v-list>
    </v-navigation-drawer>
    <v-main class="ml-4 mr-4 mt-4 mb-4 rounded-lg">
      <CategoriaConceptoComponent v-if="selected === 'categoriaConcepto'"></CategoriaConceptoComponent>
      <ConceptoNominaComponent v-if="selected === 'conceptoNomina'"></ConceptoNominaComponent>
      <CargoComponent v-if="selected === 'cargo'"></CargoComponent>
      <EmpleadoComponent v-if="selected === 'empleado'"></EmpleadoComponent>
      <JornadaComponent v-if="selected === 'jornada'"></JornadaComponent>
      <AsistenciaComponent v-if="selected === 'asistencia'"></AsistenciaComponent>
      <NominaComponent v-if="selected === 'nomina'"></NominaComponent>
      <DetalleNominaComponent v-if="selected === 'detalleNomina'"></DetalleNominaComponent>
      <AuditoriaComponent v-if="selected === 'auditoria'"></AuditoriaComponent>
    </v-main>
  </v-app>
</template>

<script setup>
import { ref } from "vue";
import CategoriaConceptoComponent from "./components/CategoriaConceptoComponent.vue";
import ConceptoNominaComponent from "./components/ConceptoNominaComponent.vue";
import CargoComponent from "./components/CargoComponent.vue";
import EmpleadoComponent from "./components/EmpleadoComponent.vue";
import JornadaComponent from "./components/JornadaComponent.vue";
import AsistenciaComponent from "./components/AsistenciaComponent.vue";
import NominaComponent from "./components/NominaComponent.vue";
import DetalleNominaComponent from "./components/DetalleNominaComponent.vue";
import AuditoriaComponent from "./components/AuditoriaComponent.vue";

const selected = ref('empleado')
</script>
