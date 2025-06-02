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
          <v-icon start>mdi-percent-box</v-icon>
          Conceptos Nómina
        </v-toolbar-title>
        <v-btn class="me-2" prepend-icon="mdi-plus" @click="add">
          Agregar un Concepto
        </v-btn>
        <v-btn
          class="me-2"
          prepend-icon="mdi-delete"
          color="red-darken-2"
          @click="removeSelected"
          :disabled="selected.length === 0"
        >
          Eliminar Conceptos
        </v-btn>
      </v-toolbar>
    </template>

    <template v-slot:item.acciones="{ item }">
      <div class="d-flex ga-2">
        <v-icon
          color="medium-emphasis"
          icon="mdi-pencil"
          size="small"
          @click="edit(item.id_concepto)"
        ></v-icon>

        <v-icon
          color="medium-emphasis"
          icon="mdi-delete"
          size="small"
          @click="remove(item.id_concepto)"
        ></v-icon>
      </div>
    </template>
  </v-data-table>

  <v-dialog v-model="dialog" max-width="500">
    <v-card :title="`${isEditing ? 'Editar' : 'Agregar'} un Concepto Nómina`">
      <template v-slot:text>
        <v-row>
          <v-col cols="12">
            <v-text-field
              v-model="record.nombre_concepto"
              label="Nombre Concepto"
            ></v-text-field>
          </v-col>

          <v-col cols="12" md="6">
            <v-text-field
              v-model="record.porcentaje"
              label="Porcentaje"
            ></v-text-field>
          </v-col>
          <v-col cols="12" md="6">
            <v-text-field
              v-model="record.id_categoria"
              label="ID Categoría"
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

function updateTable() {
  fetch("http://localhost:3001/api/conceptosNomina/")
    .then((response) => response.json())
    .then((data) => {
      items.value = data[0].map((con) => ({
        ...con,
        porcentaje: formatPercent(con.porcentaje),
      }));
    })
    .catch((error) => console.error("Error fetching data:", error))
    .finally(() => {
      loading.value = false;
    });
}

function formatPercent(value) {
  const num = Number(value);
  if (isNaN(num)) return value;
  // If integer, show as is; else, show 3 decimals
  return Number.isInteger(num) ? `${num} %` : `${num.toFixed(2)} %`;
}

const headers = [
  { title: "ID", key: "id_concepto" },
  { title: "Nombre Concepto", key: "nombre_concepto" },
  { title: "Porcentaje", key: "porcentaje" },
  { title: "ID Categoría", key: "id_categoria" },
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
  nombre_concepto: "",
  porcentaje: 0,
  id_categoria: 0,
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

  fetch(`http://localhost:3001/api/conceptosNomina/${id}`)
    .then((response) => response.json())
    .then((data) => {
      found = data[0].map((cat) => ({
        ...cat,
      }));

      record.value = {
        id_concepto: found[0].id_concepto,
        nombre_concepto: found[0].nombre_concepto,
        porcentaje: Number(found[0].porcentaje).toFixed(2),
        id_categoria: found[0].id_categoria,
      };

      dialog.value = true;
    })
    .catch((error) => console.error("Error fetching data:", error))
    .finally(() => {
      loading.value = false;
    });
}

function remove(id) {
  fetch(`http://localhost:3001/api/conceptosNomina/${id}`, {
    method: "DELETE",
    headers: { "Content-Type": "application/json; charset=utf-8" },
  })
    .then(() => {
      loading.value = true;
      updateTable();
      showSnackbar("Concepto Nómina eliminado exitosamente");
    })
    .catch((error) => {
      showSnackbar(error.message, "red-darken-2");
    });

  updateTable();
}

function removeSelected() {
  if (selected.value.length === 0) return;
  if (!confirm("¿Está seguro de eliminar los conceptos seleccionados?")) return;

  loading.value = true;
  Promise.all(
    selected.value.map((con) =>
      fetch(`http://localhost:3001/api/conceptosNomina/${con.id_concepto}`, {
        method: "DELETE",
        headers: { "Content-Type": "application/json; charset=utf-8" },
      })
    )
  )
    .then(() => {
      showSnackbar("Conceptos Nómina eliminados exitosamente");
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

    fetch(`http://localhost:3001/api/conceptosNomina/${payload.id_concepto}`, {
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
        showSnackbar("Concepto Nómina actualizado exitosamente");
      })
      .catch((error) => {
        showSnackbar(error.message, "red-darken-2");
      });
  } else {
    // INSERTAR
    const payload = { ...record.value };

    fetch("http://localhost:3001/api/conceptosNomina/", {
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
        showSnackbar("Concepto Nómina agregado exitosamente");
      })
      .catch((error) => {
        showSnackbar(error.message, "red-darken-2");
      });
  }
}
</script>
