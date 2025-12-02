
GUÍA DE INSTALACIÓN Y COMPILACIÓN - APP DE SERVICIOS

Jarod Tierra, Andres Vega, Pablo Jarrin
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
Tener instalado el siguiente software:

- Git (para clonar el repositorio)
- Docker Desktop (Recomendado para una configuración rápida)
- Visual Studio Code (Editor recomendado)


PASOS
------------------------------------------------------------------------------


1. Abra una terminal en la raíz del proyecto (donde está docker-compose.yml).
2. Ejecute el siguiente comando:
   docker-compose up --build

3. Espere a que los contenedores se inicien.
   - Frontend (Web): http://localhost:8080
   - Backend API:    http://localhost:3000
   - Base de Datos:  Puerto 3307 (externo), 3306 (interno)

   Nota: La base de datos se inicializará automáticamente con el archivo
   'BASEVERSIONFINAL9.sql'.

USUARIOS DEMO CREADOS CLAVE PARA PROBAR LA FUNCIONALIDAD DESDE EL PRIMER LAUNCH DE LA APP

email: admin@app.com
clave: Admin1234

email: Cliente@app.com
clave: Cliente1234

email: empresa1@app.com
clave: Empresa1

email: empresa2@app.com
clave: Empresa2
