<template>
  <v-data-table
    :headers="headers"
    :items="items"
    :loading="loading"
    density="comfortable"
  >
    <template v-slot:top>
      <v-toolbar flat class="rounded">
        <v-toolbar-title>
          <v-icon start>mdi-list-box-outline</v-icon>
          Auditorías
        </v-toolbar-title>
      </v-toolbar>
    </template>

    <!-- Custom slot for 'datos' column -->
    <template #item.datos_previos="{ item }">
      <v-card flat class="pa-2" style="background: transparent">
        <pre style="white-space: pre-wrap; word-break: break-word"
          >{{ formatDatos(item.datos_previos) }}
        </pre>
      </v-card>
    </template>
    
    <template #item.datos_nuevos="{ item }">
      <v-card flat class="pa-2" style="background: transparent">
        <pre style="white-space: pre-wrap; word-break: break-word"
          >{{ formatDatos(item.datos_nuevos) }}
        </pre>
      </v-card>
    </template>
  </v-data-table>
</template>

<script setup>
import { ref, onMounted } from "vue";

function updateTable() {
  fetch("http://localhost:3001/api/auditorias/")
    .then((response) => response.json())
    .then((data) => {
      items.value = data.map((aud) => ({
        ...aud,
        fecha: formatDateTime(aud.fecha),
      }));
    })
    .catch((error) => console.error("Error fetching data:", error))
    .finally(() => {
      loading.value = false;
    });
}

function formatDate(dateStr) {
  const date = new Date(dateStr);
  const day = String(date.getDate()).padStart(2, "0");
  const month = String(date.getMonth() + 1).padStart(2, "0");
  const year = date.getFullYear();
  return `${year}-${month}-${day}`;
}

function formatDateTime(dateStr) {
  const date = new Date(dateStr);
  const day = String(date.getDate()).padStart(2, "0");
  const month = String(date.getMonth() + 1).padStart(2, "0");
  const year = date.getFullYear();
  const hours = String(date.getHours()).padStart(2, "0");
  const minutes = String(date.getMinutes()).padStart(2, "0");
  const seconds = String(date.getSeconds()).padStart(2, "0");
  return `${year}-${month}-${day} ${hours}:${minutes}:${seconds}`;
}

function formatMoney(value) {
  if (typeof value !== "number") value = Number(value);
  if (isNaN(value)) return value;
  return value.toLocaleString("en-US");
}

// Add this function to pretty-print the datos object
function formatDatos(datos) {
  if (typeof datos === "object" && datos !== null) {
    return JSON.stringify(datos, null, 2);
  }
  return datos;
}

const headers = [
  { title: "ID Auditoría", key: "_id" },
  { title: "Operación", key: "operacion" },
  { title: "Tabla", key: "tabla" },
  { title: "Procedimiento", key: "procedimiento" },
  { title: "ID", key: "id" },
  { title: "Datos Previos", key: "datos_previos" },
  { title: "Datos Nuevos", key: "datos_nuevos" },
  { title: "Fecha", key: "fecha" },
];

const items = ref([]);
const loading = ref(true);

onMounted(() => {
  updateTable();
});
</script>
