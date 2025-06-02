# Sistema de Nómina

## Descripción

Sistema de nómina desarrollado para la gestión de empleados, cargos, jornadas, asistencias y generación de nóminas. Incluye integración con bases de datos MySQL y MongoDB, así como auditoría de operaciones.

La aplicación fue desarrollada bajo los requerimientos del Proyecto Final de la asignatura Bases de Datos II.

## Autor

Federico Vargas Rozo

## Requisitos

- Node.js
- npm
- Máquina virtual Debian GNU/Linux 10 (Buster) con MySQL y MongoDB para túneles SSH

## Credenciales de Conexión

### SSH (Debian 10 en VirtualBox)
- **Host:** 127.0.0.1
- **Port:** 2222
- **Username:** dev
- **Password:** 123

### MySQL
- **Host:** localhost
- **Port:** 3306
- **Username:** dev
- **Password:** 123

### MongoDB
- **Host:** localhost
- **Port:** 27017

## Instrucciones de Ejecución

### 1. Iniciar las Bases de Datos en la VM

1. En Oracle VirtualBox importa el archivo `Debian10-MongoDB-MySQL.ova` del repositorio.
2. Inicia la VM
3. Deja la VM corriendo en segundo plano, pues los servicios SSH, MySQL y MongoDB estarán corriendo por defecto.

### 2. Iniciar el Backend

1. Abre la carpeta `backend` en tu IDE (por ejemplo, VS Code).
2. Abre una terminal y ejecuta:
   ```sh
   npm install
   npm run dev
   ```
3. El servidor Express estará disponible en [http://localhost:3001](http://localhost:3001).

### 3. Iniciar el Frontend

1. Abre la carpeta `vuetify_frontend` en una nueva ventana de tu IDE.
2. Abre una terminal y ejecuta:
   ```sh
   npm install
   npm run dev
   ```
3. El frontend estará disponible en [http://localhost:3000](http://localhost:3000).

### 4. Apagar los servidores

Para detener los servidores, presiona `CTRL + C` en las terminales correspondientes.

### 5. Apagar la VM

Puedes apagar la máquina virtual normalmente o ejecutando:
```sh
sudo poweroff
```

## Acceso a las Bases de Datos

### MySQL Workbench

1. Método de conexión: **Standard TCP/IP over SSH**
2. Configuración:
   - SSH Hostname: 127.0.0.1:2222
   - SSH User: dev
   - SSH Password: 123
   - MySQL Hostname: localhost
   - MySQL Server Port: 3306
   - Username: dev
   - Password: 123

### MongoDB Compass

1. Método de conexión: **SSH with Password**
2. Configuración:
   - SSH Hostname: 127.0.0.1
   - SSH Port: 2222
   - SSH Username: dev
   - SSH Password: 123

## Notas

- Los servidores (SSH, MySQL, MongoDB) se inician automáticamente al arrancar la máquina virtual.
- No es necesario realizar ninguna acción adicional en la máquina virtual.
- Todas las operaciones deben realizarse desde el sistema operativo local (Windows).