# Contexto del Proyecto - Sistema de Servicios
ahora necesito que hagamos un front end especifico para el administrador del sistema, este front end se accederia con el usuario admin@app.com y su clave seria Admin1234. Evidentemente no habria opcion de registrar este tipo de usuario. por ende quiero que me ayudes a poner este usuario en la base de datos con su hash adecuadamente sin interactuar con la app. Este usuario tendria acceso a las vistas, a una lista de todos los clientes y de todas las empresas.


## Información General del Proyecto

### Stack Tecnológico
- **Frontend**: Flutter/Dart (aplicación macOS)
- **Backend**: Node.js con Express
- **Base de Datos**: MySQL
- **Arquitectura**: REST API

### Estructura del Proyecto
```
PROYECTO_DB/
├── backend/           # API Node.js/Express
│   ├── src/
│   │   ├── controllers/
│   │   ├── models/
│   │   ├── routes/
│   │   ├── validators/
│   │   └── middleware/
│   └── package.json
│
└── flutter_app/      # Aplicación Flutter
    ├── lib/
    │   ├── core/
    │   │   ├── models/
    │   │   ├── services/
    │   │   └── api/
    │   ├── features/
    │   │   ├── empresa/
    │   │   └── cliente/
    │   └── config/
    └── pubspec.yaml
```

## Estado Actual del Desarrollo

### Funcionalidades Implementadas

#### 1. Sistema de Autenticación
- Login para empresas y clientes
- JWT tokens
- Middleware de autenticación y roles

#### 2. Gestión de Sucursales (RECIÉN COMPLETADO)
- **Backend** (`/api/sucursales`):
  - `GET /sucursales` - Obtener todas las sucursales (con paginación)
  - `GET /sucursales/active` - Obtener solo sucursales activas
  - `GET /sucursales/:id` - Obtener sucursal por ID
  - `POST /sucursales` - Crear nueva sucursal
  - `PUT /sucursales/:id` - Actualizar sucursal
  - `DELETE /sucursales/:id` - Eliminar sucursal (soft delete - inactiva)
  - `PATCH /sucursales/:id/reactivate` - Reactivar sucursal inactiva

- **Frontend**:
  - Pantalla de listado de sucursales (`ManageSucursalesScreen`)
  - Pantalla de crear/editar sucursal (`CreateSucursalScreen`)
  - Botón "Sucursales" en el dashboard de empresa
  - Funcionalidad de reactivación de sucursales inactivas

#### 3. Dashboard de Empresa
- Estadísticas de servicios y sucursales
- Botones de acceso rápido:
  - Nuevo Servicio
  - Sucursales
  - Cupones (placeholder para futura implementación)

## Problemas Resueltos Recientemente

### Problema 1: Routes no registradas
- **Error**: Las pantallas de gestión de sucursales existían pero no se podían acceder
- **Solución**: Agregamos las rutas en `/flutter_app/lib/config/routes.dart`

### Problema 2: Error SQL "Unknown column 's.fecha_creacion'"
- **Ubicación**: `/backend/src/models/Sucursal.js:51`
- **Causa**: ORDER BY referenciaba columna inexistente
- **Solución**: Cambiado a `ORDER BY s.id_sucursal DESC`

### Problema 3: Error SQL "Unknown column 'email'"
- **Ubicación**: `/backend/src/models/Sucursal.js:128`
- **Causa**: INSERT intentaba usar columna `email` que no existe en la tabla
- **Solución**: Eliminamos el campo email de las queries de CREATE y UPDATE

### Problema 4: Parsing error de fechaCreacion
- **Error**: Frontend esperaba campo `fecha_creacion` que backend no devolvía
- **Solución**: Hicimos `fechaCreacion` nullable en el modelo Dart

### Problema 5: Type casting error "Null is not a subtype of int" (ÚLTIMO ARREGLADO)
- **Error**: Al cargar sucursales en dropdown de crear servicio
- **Causa**: Backend endpoint `/sucursales/active` solo devuelve campos limitados (id_sucursal, nombre_sucursal, telefono, estado, ciudad, calle_principal, provincia_estado) pero el modelo Dart esperaba `idEmpresa` e `idDireccion` como int requeridos
- **Solución**:
  - Cambiamos `idEmpresa` e `idDireccion` a nullable (int?) en `/flutter_app/lib/core/models/sucursal.dart`
  - Actualizamos fromJson para manejar valores null

## Archivos Clave Modificados

### Backend

#### `/backend/src/models/Sucursal.js`
```javascript
// Método getActiveSucursalesByEmpresa (líneas 67-83)
// Solo devuelve campos esenciales para rendimiento
static async getActiveSucursalesByEmpresa(idEmpresa) {
  const query = `
    SELECT
      s.id_sucursal,
      s.nombre_sucursal,
      s.telefono,
      s.estado,
      d.ciudad,
      d.calle_principal,
      d.provincia_estado
    FROM sucursal s
    INNER JOIN direccion d ON s.id_direccion = d.id_direccion
    WHERE s.id_empresa = ? AND s.estado = 'activa'
    ORDER BY s.nombre_sucursal ASC
  `;
  return executeQuery(query, [idEmpresa]);
}

// Método reactivate agregado (líneas 232-236)
static async reactivate(id) {
  const query = "UPDATE sucursal SET estado = 'activa' WHERE id_sucursal = ?";
  await executeQuery(query, [id]);
  return true;
}
```

#### `/backend/src/controllers/sucursalController.js`
- Agregado controlador `reactivateSucursal` (líneas 189-220)
- Verifica que la empresa sea dueña antes de reactivar

#### `/backend/src/routes/sucursalRoutes.js`
- Agregada ruta `PATCH /:id/reactivate` (líneas 191-197)

### Frontend

#### `/flutter_app/lib/core/models/sucursal.dart`
```dart
class Sucursal {
  final int idSucursal;
  final int? idEmpresa;        // NULLABLE
  final int? idDireccion;      // NULLABLE
  final String nombreSucursal;
  final String? telefono;
  final String? email;
  final String estado;
  final DateTime? fechaCreacion; // NULLABLE

  // Campos de dirección
  final String callePrincipal;
  final String? calleSecundaria;
  final String? numero;
  final String ciudad;
  final String provinciaEstado;
  final String? codigoPostal;
  final String? pais;
  final double? latitud;
  final double? longitud;
  final String? referencia;

  // Constructor y métodos...
  factory Sucursal.fromJson(Map<String, dynamic> json) {
    return Sucursal(
      idSucursal: json['id_sucursal'] as int,
      idEmpresa: json['id_empresa'] as int?,      // Maneja null
      idDireccion: json['id_direccion'] as int?,  // Maneja null
      // ... resto de campos
    );
  }

  bool get isActive => estado == 'activa';
}
```

#### `/flutter_app/lib/core/services/sucursal_service.dart`
```dart
// Método agregado para reactivación (líneas 131-134)
Future<void> reactivateSucursal(int id) async {
  await _dioClient.patch('/sucursales/$id/reactivate');
}
```

#### `/flutter_app/lib/config/routes.dart`
```dart
// Rutas agregadas
static const String manageSucursales = '/empresa/sucursales';
static const String createSucursal = '/empresa/sucursal/create';
static const String editSucursal = '/empresa/sucursal/edit';

// Handlers
case manageSucursales:
  return MaterialPageRoute(builder: (_) => const ManageSucursalesScreen());

case createSucursal:
  return MaterialPageRoute(builder: (_) => const CreateSucursalScreen());

case editSucursal:
  final args = settings.arguments as Sucursal;
  return MaterialPageRoute(
    builder: (_) => CreateSucursalScreen(sucursal: args),
  );
```

#### `/flutter_app/lib/features/empresa/screens/manage_sucursales_screen.dart`
- Método `_reactivateSucursal` agregado (líneas 94-141)
- Botón de reactivación mostrado para sucursales inactivas (líneas 421-428)

## Validaciones del Backend

### Crear Sucursal (POST /sucursales)
Campos requeridos:
- `nombre_sucursal` (min 3 caracteres)
- `calle_principal` (min 3 caracteres)
- `ciudad` (min 2 caracteres)
- `provincia_estado` (requerido)

Campos opcionales:
- `telefono`
- `calle_secundaria`
- `numero`
- `codigo_postal`
- `pais` (default: 'Ecuador')
- `latitud`
- `longitud`
- `referencia`

## Esquema de Base de Datos

### Tabla: sucursal
```sql
CREATE TABLE sucursal (
  id_sucursal INT PRIMARY KEY AUTO_INCREMENT,
  id_empresa INT NOT NULL,
  id_direccion INT NOT NULL,
  nombre_sucursal VARCHAR(100) NOT NULL,
  telefono VARCHAR(20),
  estado ENUM('activa', 'inactiva') DEFAULT 'activa',
  FOREIGN KEY (id_empresa) REFERENCES empresa(id_empresa),
  FOREIGN KEY (id_direccion) REFERENCES direccion(id_direccion)
);
```

### Tabla: direccion
```sql
CREATE TABLE direccion (
  id_direccion INT PRIMARY KEY AUTO_INCREMENT,
  calle_principal VARCHAR(100) NOT NULL,
  calle_secundaria VARCHAR(100),
  numero VARCHAR(20),
  ciudad VARCHAR(50) NOT NULL,
  provincia_estado VARCHAR(50) NOT NULL,
  codigo_postal VARCHAR(20),
  pais VARCHAR(50) DEFAULT 'Ecuador',
  latitud DECIMAL(10, 8),
  longitud DECIMAL(11, 8),
  referencia TEXT
);
```

## Flujo de Trabajo Actual

### Para Gestionar Sucursales (Empresa)
1. Login como empresa
2. En dashboard → Click en "Sucursales"
3. Ver lista de sucursales (activas e inactivas)
4. Opciones disponibles:
   - Crear nueva sucursal (botón FAB)
   - Editar sucursal existente
   - Eliminar sucursal (marca como inactiva)
   - Reactivar sucursal inactiva

### Para Crear un Servicio (Empresa)
1. Login como empresa
2. En dashboard → Click en "Nuevo Servicio"
3. Seleccionar sucursal del dropdown (solo muestra sucursales activas)
4. Llenar detalles del servicio
5. Guardar

## Comandos Útiles

### Backend
```bash
cd /Users/jarodtierra/Desktop/PROYECTO_DB/backend
npm run dev  # Puerto 5000
```

### Frontend
```bash
cd /Users/jarodtierra/Desktop/PROYECTO_DB/flutter_app
flutter run -d macos
```

### Hot Reload Forzado (Flutter)
```bash
killall -9 flutter dart servicios_app 2>/dev/null
sleep 3
flutter run -d macos
```

## Datos de Prueba

### Usuario Empresa de Prueba
- Email: empresa@test.com
- Password: password123
- ID Empresa: 3

### Sucursal de Prueba Creada
- Nombre: "prueba"
- Estado: activa
- Ciudad: [ciudad configurada]

## Próximos Pasos Sugeridos

1. **Implementar gestión de servicios completa**
   - Crear servicio asociado a sucursal
   - Editar servicios
   - Eliminar servicios

2. **Implementar sistema de cupones**
   - El botón ya existe en el dashboard
   - Necesita backend y frontend completo

3. **Mejorar UX**
   - Agregar imágenes a sucursales
   - Validación de coordenadas GPS
   - Mapa para seleccionar ubicación

4. **Testing**
   - Tests unitarios para modelos
   - Tests de integración para API

## Notas Importantes

### Patrón de Soft Delete
- No eliminamos registros de la base de datos
- Usamos campo `estado` con valores 'activa' / 'inactiva'
- Endpoint `/active` solo devuelve registros activos
- Función de reactivación disponible

### Manejo de Errores
- Backend usa formato estándar de respuesta
- Frontend muestra SnackBar con mensajes de error/éxito
- Colores temáticos: verde (éxito), rojo (error)

### Performance
- Endpoint `/active` devuelve campos mínimos para dropdowns
- Endpoint regular devuelve todos los campos con JOIN a direccion
- Paginación implementada en listados completos

## Troubleshooting Común

### Error: "Flutter process already running"
```bash
killall -9 flutter dart servicios_app
```

### Error: "Backend not responding"
- Verificar que backend esté corriendo en puerto 5000
- Revisar logs: backend usa nodemon con hot reload

### Error de parsing JSON
- Verificar que campos nullable en Dart coincidan con respuesta backend
- Usar `as Type?` para campos opcionales
- Verificar que todos los campos requeridos vengan del backend

### Error de validación al crear sucursal
- `calle_principal`: mínimo 3 caracteres
- `ciudad`: mínimo 2 caracteres
- `nombre_sucursal`: mínimo 3 caracteres

## Contacto y Recursos

- Documentación API: http://localhost:5000/api-docs (Swagger)
- Base de datos: MySQL local
- Flutter version: [verificar con `flutter --version`]
- Node version: [verificar con `node --version`]

---

**Última actualización**: 2025-11-24
**Estado del proyecto**: Gestión de sucursales completamente funcional, incluyendo reactivación
**Último fix**: Type casting error en modelo Sucursal (idEmpresa e idDireccion ahora nullables)
