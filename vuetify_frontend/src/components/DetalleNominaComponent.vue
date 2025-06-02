<template>
  <v-data-table :headers="headers" :items="items" :loading="loading" density="comfortable" items-per-page="16">
    <template v-slot:top>
      <v-toolbar flat class="rounded">
        <v-toolbar-title>
          <v-icon start>mdi-clipboard-text</v-icon>
          Detalles Nóminas
        </v-toolbar-title>
      </v-toolbar>
    </template>
  </v-data-table>
</template>

<script setup>
import { ref, onMounted } from "vue";

function updateTable() {
  fetch("http://localhost:3001/api/detallesNomina/")
    .then((response) => response.json())
    .then((data) => {
      items.value = data[0].map((det) => ({
        ...det,
        monto_aplicado: formatMoney(det.monto_aplicado),
        porcentaje_aplicado: formatPercent(det.porcentaje_aplicado),
        monto_final: formatMoney(det.monto_final),
      }));
    })
    .catch((error) => console.error("Error fetching data:", error))
    .finally(() => {
      loading.value = false;
    });
};

function formatMoney(value) {
  if (typeof value !== "number") value = Number(value);
  if (isNaN(value)) return value;
  return value.toLocaleString("en-US");
};

function formatPercent(value) {
  const num = Number(value);
  if (isNaN(num)) return value;
  // If integer, show as is; else, show 3 decimals
  return Number.isInteger(num)
    ? `${num} %`
    : `${num.toFixed(2)} %`;
}

const headers = [
  { title: "ID", key: "id_detalle" },
  { title: "ID Nómina", key: "id_nomina" },
  { title: "ID Concepto", key: "id_concepto" },
  { title: "Monto Aplicado (COP)", key: "monto_aplicado" },
  { title: "Porcentaje Aplicado", key: "porcentaje_aplicado" },
  { title: "Monto Final (COP)", key: "monto_final" },
];

const items = ref([]);
const loading = ref(true);

onMounted(() => {
  updateTable();
});

</script>
