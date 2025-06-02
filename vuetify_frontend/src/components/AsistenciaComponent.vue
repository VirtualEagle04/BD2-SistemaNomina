<template>
  <v-data-table
    :headers="headers"
    :items="items"
    :loading="loading"
    density="comfortable"
    return-object
    v-model="selected"
    show-select
  >
    <template v-slot:top>
      <v-toolbar flat class="rounded">
        <v-toolbar-title>
          <v-icon start>mdi-calendar-account-outline</v-icon>
          Asistencias
        </v-toolbar-title>
        <v-btn class="me-2" prepend-icon="mdi-plus" @click="add">
          Registrar una Asistencia
        </v-btn>
        <v-btn
          class="me-2"
          prepend-icon="mdi-delete"
          color="red-darken-2"
          @click="removeSelected"
          :disabled="selected.length === 0"
        >
          Eliminar Asistencias
        </v-btn>
      </v-toolbar>
    </template>

    <template v-slot:item.acciones="{ item }">
      <div class="d-flex ga-2">
        <v-icon
          color="medium-emphasis"
          icon="mdi-pencil"
          size="small"
          @click="edit(item.id_asistencia)"
        ></v-icon>

        <v-icon
          color="medium-emphasis"
          icon="mdi-delete"
          size="small"
          @click="remove(item.id_asistencia)"
        ></v-icon>
      </div>
    </template>
  </v-data-table>
  
  <v-dialog v-model="dialog" max-width="500">
    <v-card :title="`${isEditing ? 'Editar' : 'Registrar'} una Asistencia`">
      <template v-slot:text>
        <v-row>
          <v-col cols="12">
            <v-text-field
              v-model="record.id_empleado"
              label="ID Empleado"
            ></v-text-field>
          </v-col>
          
          <v-col cols="12" md="6">
            <v-text-field
              v-model="record.tiempo_ingreso"
              label="Tiempo Ingreso"
            ></v-text-field>
          </v-col>
          <v-col cols="12" md="6">
            <v-text-field
              v-model="record.tiempo_salida"
              label="Tiempo Salida"
            ></v-text-field>
          </v-col>
        </v-row>
      </template>

      <v-divider></v-divider>

      <v-card-actions class="bg-surface-light">
        <v-btn text="Cancelar" variant="plain" @click="dialog = false"></v-btn>
        <v-spacer></v-spacer>
        <v-btn text="Guardar" @click="save"></v-btn>
      </v-card-actions>
    </v-card>
  </v-dialog>

  <v-snackbar v-model="snackbar" :color="snackbarColor" timeout="3000">
    {{ snackbarText }}
  </v-snackbar>
</template>

<script setup>
import { ref, onMounted, shallowRef } from "vue";
import { useDate } from "vuetify";

function updateTable() {
  fetch("http://localhost:3001/api/asistencias/")
    .then((response) => response.json())
    .then((data) => {
      items.value = data[0].map((asi) => ({
        ...asi,
        tiempo_ingreso: formatDateTime(asi.tiempo_ingreso),
        tiempo_salida: formatDateTime(asi.tiempo_salida),
      }));
    })
    .catch((error) => console.error("Error fetching data:", error))
    .finally(() => {
      loading.value = false;
    });
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

const adapter = useDate();
function format(date) {
  return adapter.toISO(date);
}

const headers = [
  { title: "ID", key: "id_asistencia" },
  { title: "ID Empleado", key: "id_empleado" },
  { title: "Tiempo Ingreso", key: "tiempo_ingreso" },
  { title: "Tiempo Salida", key: "tiempo_salida" },
  { title: "Acciones", key: "acciones" },
];

const items = ref([]);
const loading = ref(true);
const selected = ref([]);

onMounted(() => {
  updateTable();
});

const snackbar = ref(false);
const snackbarColor = ref("success");
const snackbarText = ref("");

function showSnackbar(message, color = "success") {
  snackbarText.value = message;
  snackbarColor.value = color;
  snackbar.value = true;
}

const DEFAULT_RECORD = {
  id_empleado: 0,
  tiempo_ingreso: "",
  tiempo_salida: "",
};

const record = ref(DEFAULT_RECORD);
const dialog = shallowRef(false);
const isEditing = shallowRef(false);

function add() {
  isEditing.value = false;
  record.value = { ...DEFAULT_RECORD };
  dialog.value = true;
}

function edit(id) {
  isEditing.value = true;

  let found = {};

  fetch(`http://localhost:3001/api/asistencias/${id}`)
    .then((response) => response.json())
    .then((data) => {
      found = data[0].map((asi) => ({
        ...asi,
        tiempo_ingreso: formatDateTime(asi.tiempo_ingreso),
        tiempo_salida: formatDateTime(asi.tiempo_salida),
      }));

      record.value = {
        id_asistencia: found[0].id_asistencia,
        id_empleado: found[0].id_empleado,
        tiempo_ingreso: found[0].tiempo_ingreso,
        tiempo_salida: found[0].tiempo_salida,
      };

      dialog.value = true;
    })
    .catch((error) => console.error("Error fetching data:", error))
    .finally(() => {
      loading.value = false;
    });
}

function remove(id) {
  fetch(`http://localhost:3001/api/asistencias/${id}`, {
    method: "DELETE",
    headers: { "Content-Type": "application/json; charset=utf-8" },
  })
    .then(() => {
      loading.value = true;
      updateTable();
      showSnackbar("Asistencia eliminada exitosamente");
    })
    .catch((error) => {
      showSnackbar(error.message, "red-darken-2");
    });

  updateTable();
}

function removeSelected() {
  if (selected.value.length === 0) return;
  // Confirmación opcional
  if (!confirm("¿Está seguro de eliminar las asistencias seleccionadas?"))
    return;

  loading.value = true;
  Promise.all(
    selected.value.map((asi) =>
      fetch(`http://localhost:3001/api/asistencias/${asi.id_asistencia}`, {
        method: "DELETE",
        headers: { "Content-Type": "application/json; charset=utf-8" },
      })
    )
  )
    .then(() => {
      showSnackbar("Asistencias eliminadas exitosamente");
      selected.value = [];
      updateTable();
    })
    .catch((error) => {
      showSnackbar(error.message, "error");
    })
    .finally(() => {
      loading.value = false;
    });
}

function save() {
  if (isEditing.value) {
    // ACTUALIZAR
    const payload = { ...record.value };
    payload.tiempo_ingreso = formatDateTime(payload.tiempo_ingreso);
    payload.tiempo_salida = formatDateTime(payload.tiempo_salida);

    fetch(`http://localhost:3001/api/asistencias/${payload.id_asistencia}`, {
      method: "PUT",
      headers: { "Content-Type": "application/json; charset=utf-8" },
      body: JSON.stringify(payload),
    })
      .then(async (response) => {
        const data = await response.json();
        if (!response.ok) throw new Error(data.sqlMessage);
        return data;
      })
      .then(() => {
        dialog.value = false;
        loading.value = true;
        updateTable();
        showSnackbar("Asistencia actualizada exitosamente");
      })
      .catch((error) => {
        showSnackbar(error.message, "red-darken-2");
      });
  } else {
    // INSERTAR
    const payload = { ...record.value };
    payload.tiempo_ingreso = formatDateTime(payload.tiempo_ingreso);
    payload.tiempo_salida = formatDateTime(payload.tiempo_salida);

    fetch("http://localhost:3001/api/asistencias/", {
      method: "POST",
      headers: { "Content-Type": "application/json; charset=utf-8" },
      body: JSON.stringify(payload),
    })
      .then(async (response) => {
        const data = await response.json();
        if (!response.ok) throw new Error(data.sqlMessage);
        return data;
      })
      .then(() => {
        dialog.value = false;
        loading.value = true;
        updateTable();
        showSnackbar("Asistencia registrada exitosamente");
      })
      .catch((error) => {
        showSnackbar(error.message, "red-darken-2");
      });
  }
}
</script>
