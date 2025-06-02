// 🔴🟠🟡🟢🔵🟣

const express = require("express");
require("dotenv").config();

const categoriaConceptoRoutes = require("./routes/categoriaConcepto.routes");
const conceptoNominaRoutes = require("./routes/conceptoNomina.routes");
const cargoRoutes = require("./routes/cargo.routes");
const empleadoRoutes = require("./routes/empleado.routes");
const jornadaRoutes = require("./routes/jornada.routes");
const asistenciaRoutes = require("./routes/asistencia.routes");
const nominaRoutes = require("./routes/nomina.routes");
const detalleNominaRoutes = require("./routes/detalleNomina.routes");

const auditoriaRoutes = require("./routes/auditoria.routes");

const app = express();

// ---- ENABLE CORS FOR ALL ROUTES ----
app.use((req, res, next) => {
  res.setHeader("Access-Control-Allow-Origin", "*");
  res.setHeader("Access-Control-Allow-Methods", "GET,POST,PUT,DELETE,OPTIONS");
  res.setHeader("Access-Control-Allow-Headers", "Content-Type, Authorization");
  next();
});

// Middleware to parse JSON requests
app.use(express.json());

// Use Routes
app.use("/api/categoriasConcepto", categoriaConceptoRoutes);
app.use("/api/conceptosNomina", conceptoNominaRoutes);
app.use("/api/cargos", cargoRoutes);
app.use("/api/empleados", empleadoRoutes);
app.use("/api/jornadas", jornadaRoutes);
app.use("/api/asistencias", asistenciaRoutes);
app.use("/api/nominas", nominaRoutes);
app.use("/api/detallesNomina", detalleNominaRoutes);

app.use("/api/auditorias", auditoriaRoutes);

// ---- START EXPRESS SERVER ----
app.listen(process.env.API_PORT, () => {
  console.log(`🟢 Servidor Express escuchando en http://localhost:${process.env.API_PORT}`);
});