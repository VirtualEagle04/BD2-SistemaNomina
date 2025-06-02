🔴🟠🟡🟢🔵🟣
VERSIÓN: 3
FECHA: 5/5/2025
DESCRIPCIÓN: Orden de ejecución del aplicativo
AUTOR: Federico Vargas Rozo
CREDENCIALES IMPORTANTES:

	Debian GNU/Linux 10 (Buster) (64-bit)
	----------------------------------------
	SSH Host: 127.0.0.1
	SSH Port: 2222
	SSH Username: dev
	SSH Password: 123
	----------------------------------------
	MySQL Host: localhost
	MySQL Port: 3306
	MySQL Username: dev
	MySQL Password: 123
	----------------------------------------
	MongoDB Host: localhost
	MongoDB Port: 27017
	MongoDB Username: n/a (no hay usuario todavía)
	MongoDB Password: n/a (no hay usuario todavía)
	----------------------------------------
🟢 Los servidores están corriendo por defecto, no es necesario iniciarlos.
🟢 Al iniciar la máquina virtual, se abrirá la terminal, y mostrará el estado de los 3 servidores (el SSH, el MySQL y el MongoDB) los cuales estarán escuchando.
🟢 Por lo tanto, NO SE DEBE HACER NADA EN LA MÁQUINA VIRTUAL. Se abre y se deja ahí.

🔴 De aquí en adelante todo se debe estar haciendo en sus Sistemas Operativos locales (Windows).
🔴 En este documento todavía no hay nada respecto a MongoDB.

==== INICIAR BACKEND ====
1. Abrir VS Code (o el IDE que estén utilizando) y abrir la carpeta "backend" que es una carpeta dentro de la carpeta madre "ProjFinal_BD2".
2. Abrir una terminal ahí en VS Code (CTRL + SHIFT + Ñ) y confirmar que el entorno es el correcto:
	> npm ls 
	🔵 Debe salirles la ruta del directorio hasta la carpeta "backend" y todas las dependencias que tiene el backend (dotenv, express, etc.).

3. Para iniciar el servidor backend:
	> npm run dev
	🔵 Debe salirles algo similar a esto:
	
		> backend@1.0.0 dev
		> node index.js

		🟡 Iniciando túnel SSH...
		🟢 Servidor Express escuchando en http://localhost:3001
		🟢 Conexión por túnel SSH establecida! (dev@127.0.0.1:2222)
		🟡 Iniciando conexión al servidor MySQL...
		🟢 Conexión al servidor MySQL establecida! (dev@localhost:3306)
		┌ ───────┬─────────────────────── ┐
		│ (index) │ Tables_in_nomina    	 │
		├ ───────┼─────────────────────── ┤
		│ 0       │ 'Asistencia'        	 │
		│ 1       │ 'Cargo'             	 │
		│ 2       │ 'CategoriaConcepto' 	 │
		│ 3       │ 'ConceptoNomina'    	 │
		│ 4       │ 'DetalleNomina'     	 │
		│ 5       │ 'Empleado'          	 │
		│ 6       │ 'Jornada'           	 │
		│ 7       │ 'Nomina'            	 │
		│ 8       │ 'Riesgo'            	 │
		└ ────── ┴─────────────────────── ┘

🟢 En este punto, ya el backend debería estar conectado a la BD y toca mantenerlo encendido para que el front funcione.

==== INICIAR FRONTEND ====
1. Abrir otra ventana de VS Code (File > New Window) (Archivo > Nueva Ventana) y abrir la carpeta "vuetify_frontend" que es una carpeta dentro de la carpeta madre "ProjFinal_BD2".
2. Abrir una terminal ahí en VS Code (CTRL + SHIFT + Ñ) y confirmar que el entorno es el correcto:
	> npm ls
	🔵 Debe salirles la ruta del directorio hasta la carpeta "vuetify_frontend" y todas las dependencias que tiene el frontend (vite, sass, vue, vuetify, etc.)

3. Para iniciar el servidor frontend:
	> npm run dev
	🔵 Debe salirles algo similar a esto:
		
		> vuetify_frontend@0.0.0 dev
		> vite


  		VITE v5.4.17  ready in 485 ms

  		➜  Local:   http://localhost:3000/
  		➜  Network: use --host to expose
  		➜  press h + enter to show help

4. Para ver la página, pues abren un navegador y ponen la dirección que les aparece: http://localhost:3000/

🟢 En este punto, ya todo el aplicativo debería estar funcionando.

==== CERRAR BACK Y FRONT ====
En las dos terminales (tanto del back como del front) pueden ingresar: CTRL + C para cerrar los dos servidores.

==== CERRAR MÁQUINA VIRTUAL ====
- Pueden cerrar la máquina virtual apagándola común y corriente.
- O pueden cerrar la máquina virtual ejecutando:
	> sudo poweroff

🟢 La VM ya debería estar apagada y los servidores cerrados.
🟢 En este punto todo el aplicativo ya debería estar apagado.


==== CONECTARSE A LA BD MySQL POR MySQL Workbench ====
Les sugiero que las consultas SQL que vayan a hacer las hagan por un programa como este, no por la terminal de MySQL.

Si quieren conectarse a la BD para hacer código SQL en Workbench:
1. Abran MySQL Workbench
2. Presionar el "+" para añadir una conexión
3. Denle un nombre. Yo le tengo "BD2_Debian10"
4. En "Connection Method" presionar "Standard TCP/IP over SSH"
5. Ingresar los datos:
	a. SSH Hostname: 127.0.0.1:2222
	b. SSH User: dev
	c. SSH Password > Store in Vault: 123
	d. MySQL Hostname: localhost
	e. MySQL Server Port: 3306
	f. Username: dev
	g. Password > Store in Vault: 123
6. Test Connection para probar la conexión. (Claramente la máquina virtual y la BD deben estar corriendo)
7. Presionar: "Ok" para guardar la conexión
8. Ya

==== CONECTARSE A LA BD MongoDB por MongoDB Compass ====
MongoDB también ofrece una interfaz parecida a Workbench, que se llama MongoDB Compass, y la pueden descargar: https://www.mongodb.com/try/download/compass

Si quieren conectarse a la BD para hacer código en Compass:
1. Abran MongoDB Compass
2. Presionar: "Add new connection" para añadir una conexión
3. Denle un nombre. Yo le tengo "BD_Debian10"
4. Amplíen la parte que dice "Advanced Connection Options"
5. Abran la pestaña que dice "Proxy/SSH"
6. Presionen la opción: "SSH with Password"
7. Ingresen los datos:
	a. SSH Hostname: 127.0.0.1
	b. SSH Port: 2222
	c. SSH Username: dev
	d. SSH Password: 123
8. Presionar: "Save & Connect" para guardar la conexión y conectarse
9. Ya
