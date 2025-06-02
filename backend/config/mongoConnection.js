const { MongoClient } = require("mongodb");
const { Client } = require("ssh2");
const net = require("net");
require("dotenv").config();

const sshClient = new Client();
const LOCAL_PORT = 27018;

const mongoPromise = new Promise((resolve, reject) => {
  sshClient.on("ready", () => {
    console.log(`🟢 Conexión por tunel SSH establecida para MongoDB! (${process.env.SSH_USER}@${process.env.SSH_HOST}:${process.env.SSH_PORT})`);

    // Crear un servidor TCP local para reenviar conexiones al MongoDB remoto
    net.createServer(function (localSocket) {
      sshClient.forwardOut(
        localSocket.remoteAddress,
        localSocket.remotePort,
        process.env.MONGODB_HOST,
        parseInt(process.env.MONGODB_PORT, 10),
        function (err, stream) {
          if (err) {
            console.error("🔴 Error en tunel SSH para MongoDB |", err);
            localSocket.end();
            return;
          }
          localSocket.pipe(stream).pipe(localSocket);
        }
      );
    }).listen(LOCAL_PORT, "127.0.0.1", async () => {
      console.log(`🟢 Servidor TCP local escuchando en 127.0.0.1:${LOCAL_PORT}`);
      try {
        const mongoUrl = `mongodb://localhost:${LOCAL_PORT}`;
        const client = new MongoClient(mongoUrl, {});
        await client.connect();
        console.log(`🟢 Conexión al servidor MongoDB establecida! (localhost:27017)`);
        console.table((await client.db().admin().listDatabases()).databases.map(db => ({
          name: db.name,
          sizeOnDisk: db.sizeOnDisk,
          empty: db.empty,
        })));
        resolve(client);
      } catch (err) {
        console.error("🔴 Error de conexión al servidor MongoDB |", err);
        sshClient.end();
        reject(err);
      }
    });
  });

  sshClient.on("error", (err) => {
    console.error("🔴 Error en tunel SSH para MongoDB |", err);
    reject(err);
  });

  console.log("🟡 Iniciando tunel SSH para MongoDB...");
  sshClient.connect({
    host: process.env.SSH_HOST,
    port: parseInt(process.env.SSH_PORT, 10),
    username: process.env.SSH_USER,
    password: process.env.SSH_PASS,
  });
});

module.exports = async () => mongoPromise;