const mysql = require("mysql2/promise");
const { Client } = require("ssh2");
require("dotenv").config();

const sshClient = new Client();

let connectionPromise;

sshClient.on("ready", () => {
  console.log(`🟢 Conexión por tunel SSH establecida para MySQL! (${process.env.SSH_USER}@${process.env.SSH_HOST}:${process.env.SSH_PORT})`);

  connectionPromise = new Promise((resolve, reject) => {
    sshClient.forwardOut(
      process.env.SRC_HOST,
      parseInt(process.env.SRC_PORT, 10),
      process.env.DB_HOST,
      parseInt(process.env.DB_PORT, 10),
      async (err, stream) => {
        if (err) {
          console.error("🔴 Error en tunel SSH para MySQL |", err);
          sshClient.end();
          return reject(err);
        }

        try {
          console.log("🟡 Iniciando conexión al servidor MySQL...");
          const connection = await mysql.createConnection({
            user: process.env.DB_USER,
            password: process.env.DB_PASS,
            database: process.env.DB_NAME,
            stream: stream,
          });

          console.log(`🟢 Conexión al servidor MySQL establecida! (${process.env.DB_USER}@${process.env.DB_HOST}:${process.env.DB_PORT})`);

          const [rows] = await connection.execute("SHOW TABLES");
          console.table(rows);
					resolve(connection);
        } catch (err) {
          console.error("🔴 Error de conexión al servidor MySQL |", err);
          sshClient.end();
					reject(err);
        }
      }
    );
  });
});

sshClient.on("error", (err) => {
  console.error("🔴 Error en tunel SSH para MySQL |", err);
});

console.log("🟡 Iniciando tunel SSH para MySQL...");
sshClient.connect({
  host: process.env.SSH_HOST,
  port: parseInt(process.env.SSH_PORT, 10),
  username: process.env.SSH_USER,
  password: process.env.SSH_PASS,
});

module.exports = async () => {
	if (!connectionPromise)
	{
		throw new Error("🔴 La conexión a la base de datos no está lista")
	}
	return connectionPromise;
}
