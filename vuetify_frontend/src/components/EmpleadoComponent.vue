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
          <v-icon start>mdi-account</v-icon>
          Empleados
        </v-toolbar-title>
        <v-btn class="me-2" prepend-icon="mdi-plus" @click="add">
          Agregar un Empleado
        </v-btn>
        <v-btn
          class="me-2"
          prepend-icon="mdi-delete"
          color="red-darken-2"
          @click="removeSelected"
          :disabled="selected.length === 0"
        >
          Eliminar Empleados
        </v-btn>
        <v-btn
          class="me-2"
          prepend-icon="mdi-clipboard-text"
          @click="openNominaDialog(selected.map((e) => e.id_empleado))"
          :disabled="selected.length === 0"
        >
          Generar Nóminas
        </v-btn>
      </v-toolbar>
    </template>

    <template v-slot:item.acciones="{ item }">
      <div class="d-flex ga-2">
        <v-icon
          color="medium-emphasis"
          icon="mdi-pencil"
          size="small"
          @click="edit(item.id_empleado)"
        ></v-icon>

        <v-icon
          color="medium-emphasis"
          icon="mdi-delete"
          size="small"
          @click="remove(item.id_empleado)"
        ></v-icon>

        <v-icon
          color="medium-emphasis"
          icon="mdi-clipboard-text"
          size="small"
          @click="openNominaDialog([item.id_empleado])"
        ></v-icon>
      </div>
    </template>
  </v-data-table>

  <v-dialog v-model="dialog" max-width="500">
    <v-card :title="`${isEditing ? 'Editar' : 'Agregar'} un Empleado`">
      <template v-slot:text>
        <v-row>
          <v-col cols="12">
            <v-text-field v-model="record.cedula" label="Cédula"></v-text-field>
          </v-col>

          <v-col cols="12" md="6">
            <v-text-field
              v-model="record.nombres"
              label="Nombres"
            ></v-text-field>
          </v-col>
          <v-col cols="12" md="6">
            <v-text-field
              v-model="record.apellidos"
              label="Apellidos"
            ></v-text-field>
          </v-col>

          <v-col cols="12">
            <v-date-input
              v-model="record.fecha_nacimiento"
              label="Fecha de Nacimiento"
              :display-format="format"
            ></v-date-input>
          </v-col>

          <v-col cols="12">
            <v-text-field
              v-model="record.direccion"
              label="Dirección"
            ></v-text-field>
          </v-col>

          <v-col cols="12">
            <v-text-field
              v-model="record.telefono"
              label="Teléfono"
            ></v-text-field>
          </v-col>

          <v-col cols="12">
            <v-text-field v-model="record.email" label="Email"></v-text-field>
          </v-col>

          <v-col cols="12" md="6">
            <v-text-field
              v-model="record.id_cargo"
              label="ID Cargo"
            ></v-text-field>
          </v-col>
          <v-col cols="12" md="6">
            <v-text-field
              v-model="record.id_jornada"
              label="ID Jornada"
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

  <v-dialog v-model="nominaDialog" max-width="500">
    <v-card
      title="Generar Nómina"
      :subtitle="`${
        selected.length === 0
          ? 'Genera una Nómina para un Empleado'
          : 'Genera Nóminas para varios Empleados'
      }`"
    >
      <template v-slot:text>
        <v-row>
          <v-col cols="12" md="6">
            <v-date-input
              v-model="nominaFechaInicio"
              label="Fecha de Inicio"
              :display-format="format"
            ></v-date-input>
          </v-col>
          <v-col cols="12" md="6">
            <v-date-input
              v-model="nominaFechaFin"
              label="Fecha de Fin"
              :display-format="format"
            ></v-date-input>
          </v-col>
        </v-row>
      </template>
      <v-divider></v-divider>
      <v-card-actions class="bg-surface-light">
        <v-btn
          text="Cancelar"
          variant="plain"
          @click="nominaDialog = false"
        ></v-btn>
        <v-spacer></v-spacer>
        <v-btn text="Generar" @click="generarNominas"></v-btn>
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
  fetch("http://localhost:3001/api/empleados/")
    .then((response) => response.json())
    .then((data) => {
      items.value = data[0].map((emp) => ({
        ...emp,
        fecha_nacimiento: formatDate(emp.fecha_nacimiento),
        fecha_contratacion: formatDateTime(emp.fecha_contratacion),
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

const adapter = useDate();
function format(date) {
  return adapter.toISO(date);
}

const headers = [
  { title: "ID", key: "id_empleado" },
  { title: "Cédula", key: "cedula" },
  { title: "Nombres", key: "nombres" },
  { title: "Apellidos", key: "apellidos" },
  { title: "Fecha de Nacimiento", key: "fecha_nacimiento" },
  { title: "Dirección", key: "direccion" },
  { title: "Teléfono", key: "telefono" },
  { title: "Email", key: "email" },
  { title: "Fecha de Contratación", key: "fecha_contratacion" },
  { title: "ID Cargo", key: "id_cargo" },
  { title: "ID Jornada", key: "id_jornada" },
  { title: "Acciones", key: "acciones" },
];

const items = ref([]);
const loading = ref(true);
const selected = ref([]);

const nominaDialog = shallowRef(false);
const nominaFechaInicio = shallowRef(null);
const nominaFechaFin = shallowRef(null);
const nominaEmpleadoIds = ref([]);

function openNominaDialog(ids) {
  nominaEmpleadoIds.value = ids;
  nominaFechaInicio.value = null;
  nominaFechaFin.value = null;
  nominaDialog.value = true;
}

function generarNominas() {
  if (!nominaFechaInicio.value || !nominaFechaFin.value) {
    showSnackbar("Seleccione ambas fechas", "red-darken-2");
    return;
  }
  const fecha_inicio = formatDate(nominaFechaInicio.value);
  const fecha_fin = formatDate(nominaFechaFin.value);
  Promise.all(
    nominaEmpleadoIds.value.map((id) =>
      fetch("http://localhost:3001/api/nominas/generar", {
        method: "POST",
        headers: { "Content-Type": "application/json; charset=utf-8" },
        body: JSON.stringify({ id_empleado: id, fecha_inicio, fecha_fin }),
      }).then(async (response) => {
        if (!response.ok) {
          const data = await response.json();
          throw new Error(data.sqlMessage);
        }
      })
    )
  )
    .then(() => {
      nominaDialog.value = false;
      showSnackbar("Nómina(s) generada(s) exitosamente");
    })
    .catch((error) => {
      showSnackbar(error.message, "red-darken-2");
    });
}

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
  cedula: "",
  nombres: "",
  apellidos: "",
  fecha_nacimiento: "",
  direccion: "",
  telefono: "",
  email: "",
  id_cargo: 0,
  id_jornada: 0,
};

const record = ref(DEFAULT_RECORD);
const dialog = shallowRef(false);
const isEditing = shallowRef(false);

function add() {
  isEditing.value = false;
  record.value = {...DEFAULT_RECORD};
  dialog.value = true;
}

function edit(id) {
  isEditing.value = true;

  let found = {};

  fetch(`http://localhost:3001/api/empleados/${id}`)
    .then((response) => response.json())
    .then((data) => {
      found = data[0].map((emp) => ({
        ...emp,
        fecha_nacimiento: formatDate(emp.fecha_nacimiento),
        fecha_contratacion: formatDateTime(emp.fecha_contratacion),
      }));

      record.value = {
        id_empleado: found[0].id_empleado,
        cedula: found[0].cedula,
        nombres: found[0].nombres,
        apellidos: found[0].apellidos,
        fecha_nacimiento: found[0].fecha_nacimiento,
        direccion: found[0].direccion,
        telefono: found[0].telefono,
        email: found[0].email,
        fecha_contratacion: found[0].fecha_contratacion,
        id_cargo: found[0].id_cargo,
        id_jornada: found[0].id_jornada,
      };

      dialog.value = true;
    })
    .catch((error) => console.error("Error fetching data:", error))
    .finally(() => {
      loading.value = false;
    });
}

function remove(id) {
  fetch(`http://localhost:3001/api/empleados/${id}`, {
    method: "DELETE",
    headers: { "Content-Type": "application/json; charset=utf-8" },
  })
    .then(() => {
      loading.value = true;
      updateTable();
      showSnackbar("Empleado eliminado exitosamente");
    })
    .catch((error) => {
      showSnackbar(error.message, "red-darken-2");
    });

  updateTable();
}

function removeSelected() {
  if (selected.value.length === 0) return;
  // Confirmación opcional
  if (!confirm("¿Está seguro de eliminar los empleados seleccionados?")) return;

  loading.value = true;
  Promise.all(
    selected.value.map(emp =>
      fetch(`http://localhost:3001/api/empleados/${emp.id_empleado}`, {
        method: "DELETE",
        headers: { "Content-Type": "application/json; charset=utf-8" },
      })
    )
  )
    .then(() => {
      showSnackbar("Empleados eliminados exitosamente");
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
    payload.fecha_nacimiento = formatDate(payload.fecha_nacimiento);

    fetch(`http://localhost:3001/api/empleados/${payload.id_empleado}`, {
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
        showSnackbar("Empleado actualizado exitosamente");
      })
      .catch((error) => {
        showSnackbar(error.message, "red-darken-2");
      });
  } else {
    // INSERTAR
    const payload = { ...record.value };
    payload.fecha_nacimiento = formatDate(payload.fecha_nacimiento);

    fetch("http://localhost:3001/api/empleados/", {
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
        showSnackbar("Empleado agregado exitosamente");
      })
      .catch((error) => {
        showSnackbar(error.message, "red-darken-2");
      });
  }
}
</script>
