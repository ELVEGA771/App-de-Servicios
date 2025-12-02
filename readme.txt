==============================================================================
GUÍA DE INSTALACIÓN Y COMPILACIÓN - APP DE SERVICIOS
==============================================================================

Este documento detalla los pasos necesarios para configurar, compilar y ejecutar
el proyecto "App de Servicios" desde cero en un nuevo entorno de desarrollo.

El proyecto consta de tres componentes principales:
1. Base de Datos (MySQL 8.0)
2. Backend (Node.js + Express)
3. Frontend (Flutter - Móvil y Web)

------------------------------------------------------------------------------
1. PRERREQUISITOS
------------------------------------------------------------------------------
Asegúrese de tener instalado el siguiente software:

- Git (para clonar el repositorio)
- Docker Desktop (Recomendado para una configuración rápida)
- Node.js (v18 o superior) y npm (si ejecuta el backend manualmente)
- Flutter SDK (v3.6.0 o superior) (si ejecuta la app móvil/web manualmente)
- MySQL Server (v8.0) (si ejecuta la base de datos manualmente)
- Android Studio / Xcode (para emuladores y compilación móvil)
- Visual Studio Code (Editor recomendado)

------------------------------------------------------------------------------
2. MÉTODO RÁPIDO: DOCKER (RECOMENDADO)
------------------------------------------------------------------------------
Este método levanta todo el entorno (BD, Backend, Frontend Web) automáticamente.

1. Abra una terminal en la raíz del proyecto (donde está docker-compose.yml).
2. Ejecute el siguiente comando:
   docker-compose up --build

3. Espere a que los contenedores se inicien.
   - Frontend (Web): http://localhost:8080
   - Backend API:    http://localhost:3000
   - Base de Datos:  Puerto 3307 (externo), 3306 (interno)

   Nota: La base de datos se inicializará automáticamente con el archivo
   'BASEVERSIONFINAL9.sql'.

------------------------------------------------------------------------------
3. MÉTODO MANUAL (DESARROLLO LOCAL)
------------------------------------------------------------------------------

PASO A: BASE DE DATOS (MySQL)
1. Instale MySQL Server y asegúrese de que el servicio esté corriendo.
2. Cree una base de datos llamada 'app_servicios'.
3. Importe el archivo SQL proporcionado:
   mysql -u root -p app_servicios < BASEVERSIONFINAL9.sql

PASO B: BACKEND (Node.js)
1. Navegue a la carpeta del backend:
   cd backend

2. Instale las dependencias:
   npm install

3. Cree un archivo '.env' en la carpeta 'backend' con el siguiente contenido
   (ajuste las credenciales según su configuración de MySQL):

   PORT=3000
   DB_HOST=localhost
   DB_USER=root
   DB_PASSWORD=su_contraseña
   DB_NAME=app_servicios
   JWT_SECRET=clave_secreta_para_jwt
   BCRYPT_ROUNDS=10
   # Opcional: Configuración de Cloudinary si se usa subida de imágenes
   CLOUDINARY_CLOUD_NAME=...
   CLOUDINARY_API_KEY=...
   CLOUDINARY_API_SECRET=...

4. Inicie el servidor:
   npm run dev   (modo desarrollo)
   o
   npm start     (modo producción)

PASO C: FRONTEND (Flutter)
1. Navegue a la carpeta de la app:
   cd flutter_app

2. Obtenga las dependencias:
   flutter pub get

3. Configuración de API (IMPORTANTE):
   Abra el archivo 'lib/config/constants.dart'.
   
   - Para Web: No requiere cambios (usa localhost).
   - Para Emulador Android: Usa '10.0.2.2' (configurado por defecto).
   - Para Dispositivo Físico: 
     Debe cambiar la IP en 'AppConstants.API_BASE_URL' y 'fixImageUrl' 
     por la IP local de su computadora (ej. 192.168.1.X o 172.20.10.3).
     
     Ejemplo en constants.dart:
     if (defaultTargetPlatform == TargetPlatform.android) {
       return 'http://SU_IP_LOCAL:3000/api';
     }

4. Ejecutar la aplicación:
   - Web:     flutter run -d chrome
   - Android: flutter run -d <id_dispositivo>

------------------------------------------------------------------------------
4. NOTAS IMPORTANTES Y SOLUCIÓN DE PROBLEMAS
------------------------------------------------------------------------------

- CONEXIÓN EN DISPOSITIVO FÍSICO:
  Si prueba la app en un celular real conectado por USB/Wifi:
  1. Asegúrese de que el celular y la PC estén en la misma red Wifi.
  2. Configure el Firewall de Windows para permitir conexiones entrantes 
     en el puerto 3000 (Backend).
  3. Actualice la IP en 'lib/config/constants.dart' con la IP de su PC.

- ERRORES DE BASE DE DATOS:
  Si el backend falla al conectar, verifique que las credenciales en el 
  archivo '.env' coincidan con su instalación local de MySQL.
  Si usa Docker, asegúrese de que el puerto 3307 no esté ocupado.

- SUBIDA DE IMÁGENES:
  El proyecto puede requerir credenciales de Cloudinary para subir fotos.
  Si no las tiene, la funcionalidad de subida de imágenes podría fallar.
  Revise 'backend/src/config/cloudinary.js'.

- DEPENDENCIAS DE FLUTTER:
  Si encuentra conflictos de versiones al hacer 'flutter pub get', intente:
  flutter pub upgrade --major-versions
  o revise el archivo 'pubspec.yaml' para ajustar versiones manualmente.

==============================================================================
