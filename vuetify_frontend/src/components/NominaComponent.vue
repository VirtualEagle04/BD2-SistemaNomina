<template>
  <v-data-table :headers="headers" :items="items" :loading="loading" density="comfortable">
    <template v-slot:top>
      <v-toolbar flat class="rounded">
        <v-toolbar-title>
          <v-icon start>mdi-cash-100</v-icon>
          Nóminas
        </v-toolbar-title>
      </v-toolbar>
    </template>
  </v-data-table>
</template>

<script setup>
import { ref, onMounted } from "vue";

function updateTable() {
  fetch("http://localhost:3001/api/nominas/")
    .then((response) => response.json())
    .then((data) => {
      items.value = data[0].map((nom) => ({
        ...nom,
        fecha_inicio: formatDate(nom.fecha_inicio),
        fecha_fin: formatDate(nom.fecha_fin),
        fecha_liquidacion: formatDateTime(nom.fecha_liquidacion),
        total_devengado: formatMoney(nom.total_devengado),
        total_deducido: formatMoney(nom.total_deducido),
        total_apropiado: formatMoney(nom.total_apropiado),
        total_prestaciones: formatMoney(nom.total_prestaciones),
        neto_pagado: formatMoney(nom.neto_pagado),
        gran_total: formatMoney(nom.gran_total),
      }));
    })
    .catch((error) => console.error("Error fetching data:", error))
    .finally(() => {
      loading.value = false;
    });
};

function formatDate(dateStr) {
  const date = new Date(dateStr);
  const day = String(date.getDate()).padStart(2, "0");
  const month = String(date.getMonth() + 1).padStart(2, "0");
  const year = date.getFullYear();
  return `${year}-${month}-${day}`;
};

function formatDateTime(dateStr) {
  const date = new Date(dateStr);
  const day = String(date.getDate()).padStart(2, "0");
  const month = String(date.getMonth() + 1).padStart(2, "0");
  const year = date.getFullYear();
  const hours = String(date.getHours()).padStart(2, "0");
  const minutes = String(date.getMinutes()).padStart(2, "0");
  const seconds = String(date.getSeconds()).padStart(2, "0");
  return `${year}-${month}-${day} ${hours}:${minutes}:${seconds}`;
};

function formatMoney(value) {
  if (typeof value !== "number") value = Number(value);
  if (isNaN(value)) return value;
  return value.toLocaleString("en-US");
};

const headers = [
  { title: "ID", key: "id_nomina"},
  { title: "ID Empleado", key: "id_empleado"},
  { title: "Fecha Inicio", key: "fecha_inicio"},
  { title: "Fecha Fin", key: "fecha_fin"},
  { title: "Fecha Liquidación", key: "fecha_liquidacion"},
  { title: "Total Devengado (COP)", key: "total_devengado"},
  { title: "Total Deducido (COP)", key: "total_deducido"},
  { title: "Total Apropiado (COP)", key: "total_apropiado"},
  { title: "Total Prestaciones (COP)", key: "total_prestaciones"},
  { title: "Neto Pagado (COP)", key: "neto_pagado"},
  { title: "Gran Total (COP)", key: "gran_total"},
];

const items = ref([]);
const loading = ref(true);

onMounted(() => {
  updateTable();
});

</script>
