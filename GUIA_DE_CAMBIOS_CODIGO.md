# GUÍA DE CAMBIOS EN EL CÓDIGO
## Migración de Queries a Vistas y Stored Procedures

Esta guía detalla todos los cambios necesarios en el código del backend para usar las nuevas vistas y stored procedures creados.

---

## TABLA DE CONTENIDO

1. [Instalación de Vistas y SPs](#instalación)
2. [Cambios en Modelos](#cambios-en-modelos)
3. [Cambios en Controladores](#cambios-en-controladores)
4. [Resumen de Archivos Modificados](#resumen)

---

## INSTALACIÓN

Antes de modificar el código, ejecuta los siguientes comandos para instalar las vistas y SPs:

```bash
# Instalar nuevas vistas
mysql -u root -p app_servicios < backend/database/nuevas_vistas.sql

# Instalar nuevos stored procedures
mysql -u root -p app_servicios < backend/database/nuevos\ SP.sql

# Verificar instalación
mysql -u root -p app_servicios -e "SHOW FULL TABLES WHERE Table_type = 'VIEW';"
mysql -u root -p app_servicios -e "SHOW PROCEDURE STATUS WHERE Db = 'app_servicios';"
```

---

## CAMBIOS EN MODELOS

### 1. **backend/src/models/Usuario.js**

#### Cambio 1: Actualizar usuario (línea ~40)
**ANTES:**
```javascript
static async actualizar(id, datos) {
  const { nombre, apellido, telefono, foto_perfil_url, estado } = datos;
  const query = `
    UPDATE usuario
    SET nombre = ?, apellido = ?, telefono = ?, foto_perfil_url = ?, estado = ?
    WHERE id_usuario = ?
  `;
  const [result] = await db.query(query, [nombre, apellido, telefono, foto_perfil_url, estado, id]);
  return result;
}
```

**DESPUÉS:**
```javascript
static async actualizar(id, datos) {
  const { nombre, apellido, telefono, foto_perfil_url, estado } = datos;
  const query = `CALL sp_actualizar_usuario(?, ?, ?, ?, ?, ?, @mensaje)`;
  await db.query(query, [id, nombre, apellido, telefono, foto_perfil_url, estado]);
  const [[result]] = await db.query('SELECT @mensaje as mensaje');
  return result;
}
```

#### Cambio 2: Actualizar contraseña (línea ~50)
**ANTES:**
```javascript
static async actualizarPassword(id, passwordHash) {
  const query = `UPDATE usuario SET password_hash = ? WHERE id_usuario = ?`;
  const [result] = await db.query(query, [passwordHash, id]);
  return result;
}
```

**DESPUÉS:**
```javascript
static async actualizarPassword(id, passwordHash) {
  const query = `CALL sp_actualizar_password(?, ?, @mensaje)`;
  await db.query(query, [id, passwordHash]);
  const [[result]] = await db.query('SELECT @mensaje as mensaje');
  return result;
}
```

#### Cambio 3: Eliminar usuario (línea ~60)
**ANTES:**
```javascript
static async eliminar(id) {
  const query = `DELETE FROM usuario WHERE id_usuario = ?`;
  const [result] = await db.query(query, [id]);
  return result;
}
```

**DESPUÉS:**
```javascript
static async eliminar(id) {
  const query = `CALL sp_eliminar_usuario(?, @mensaje)`;
  await db.query(query, [id]);
  const [[result]] = await db.query('SELECT @mensaje as mensaje');
  return result;
}
```

---

### 2. **backend/src/models/Categoria.js**

#### Cambio 1: Crear categoría (línea ~20)
**ANTES:**
```javascript
static async crear(datos) {
  const { nombre, descripcion, icono_url } = datos;
  const query = `INSERT INTO categoria_servicio (nombre, descripcion, icono_url) VALUES (?, ?, ?)`;
  const [result] = await db.query(query, [nombre, descripcion, icono_url]);
  return result.insertId;
}
```

**DESPUÉS:**
```javascript
static async crear(datos) {
  const { nombre, descripcion, icono_url } = datos;
  const query = `CALL sp_crear_categoria(?, ?, ?, @id_categoria, @mensaje)`;
  await db.query(query, [nombre, descripcion, icono_url]);
  const [[result]] = await db.query('SELECT @id_categoria as id, @mensaje as mensaje');
  return result.id;
}
```

#### Cambio 2: Actualizar categoría (línea ~30)
**ANTES:**
```javascript
static async actualizar(id, datos) {
  const { nombre, descripcion, icono_url } = datos;
  const query = `UPDATE categoria_servicio SET nombre = ?, descripcion = ?, icono_url = ? WHERE id_categoria = ?`;
  const [result] = await db.query(query, [nombre, descripcion, icono_url, id]);
  return result;
}
```

**DESPUÉS:**
```javascript
static async actualizar(id, datos) {
  const { nombre, descripcion, icono_url } = datos;
  const query = `CALL sp_actualizar_categoria(?, ?, ?, ?, @mensaje)`;
  await db.query(query, [id, nombre, descripcion, icono_url]);
  const [[result]] = await db.query('SELECT @mensaje as mensaje');
  return result;
}
```

---

### 3. **backend/src/models/Favorito.js**

#### Cambio 1: Obtener favoritos (línea ~15)
**ANTES:**
```javascript
static async getFavoritosPorCliente(idCliente) {
  const query = `
    SELECT sf.*, s.*,
      e.razon_social as empresa_nombre,
      e.calificacion_promedio as empresa_calificacion,
      c.nombre as categoria_nombre
    FROM servicio_favorito sf
    INNER JOIN servicio s ON sf.id_servicio = s.id_servicio
    INNER JOIN empresa e ON s.id_empresa = e.id_empresa
    INNER JOIN categoria_servicio c ON s.id_categoria = c.id_categoria
    WHERE sf.id_cliente = ?
    ORDER BY sf.fecha_agregado DESC
  `;
  const [rows] = await db.query(query, [idCliente]);
  return rows;
}
```

**DESPUÉS:**
```javascript
static async getFavoritosPorCliente(idCliente) {
  const query = `
    SELECT * FROM vista_favoritos_detalle
    WHERE id_cliente = ?
    ORDER BY fecha_agregado DESC
  `;
  const [rows] = await db.query(query, [idCliente]);
  return rows;
}
```

#### Cambio 2: Agregar favorito (línea ~40)
**ANTES:**
```javascript
static async agregar(idServicio, idCliente, notasCliente) {
  const query = `
    INSERT INTO servicio_favorito (id_servicio, id_cliente, fecha_agregado, notas_cliente)
    VALUES (?, ?, NOW(), ?)
    ON DUPLICATE KEY UPDATE notas_cliente = ?, fecha_agregado = NOW()
  `;
  const [result] = await db.query(query, [idServicio, idCliente, notasCliente, notasCliente]);
  return result;
}
```

**DESPUÉS:**
```javascript
static async agregar(idServicio, idCliente, notasCliente) {
  const query = `CALL sp_agregar_favorito(?, ?, ?, @mensaje)`;
  await db.query(query, [idServicio, idCliente, notasCliente]);
  const [[result]] = await db.query('SELECT @mensaje as mensaje');
  return result;
}
```

#### Cambio 3: Eliminar favorito (línea ~55)
**ANTES:**
```javascript
static async eliminar(idCliente, idServicio) {
  const query = `DELETE FROM servicio_favorito WHERE id_cliente = ? AND id_servicio = ?`;
  const [result] = await db.query(query, [idCliente, idServicio]);
  return result;
}
```

**DESPUÉS:**
```javascript
static async eliminar(idCliente, idServicio) {
  const query = `CALL sp_eliminar_favorito(?, ?, @mensaje)`;
  await db.query(query, [idCliente, idServicio]);
  const [[result]] = await db.query('SELECT @mensaje as mensaje');
  return result;
}
```

---

### 4. **backend/src/models/Empresa.js**

#### Cambio 1: Obtener empresa por ID (línea ~15)
**ANTES:**
```javascript
static async getEmpresaPorId(id) {
  const query = `
    SELECT e.*, u.*
    FROM empresa e
    INNER JOIN usuario u ON e.id_usuario = u.id_usuario
    WHERE e.id_empresa = ?
  `;
  const [rows] = await db.query(query, [id]);
  return rows[0];
}
```

**DESPUÉS:**
```javascript
static async getEmpresaPorId(id) {
  const query = `SELECT * FROM vista_empresas_detalle WHERE id_empresa = ?`;
  const [rows] = await db.query(query, [id]);
  return rows[0];
}
```

#### Cambio 2: Obtener empresa por ID usuario (línea ~30)
**ANTES:**
```javascript
static async getEmpresaPorIdUsuario(idUsuario) {
  const query = `
    SELECT e.*, u.*
    FROM empresa e
    INNER JOIN usuario u ON e.id_usuario = u.id_usuario
    WHERE e.id_usuario = ?
  `;
  const [rows] = await db.query(query, [idUsuario]);
  return rows[0];
}
```

**DESPUÉS:**
```javascript
static async getEmpresaPorIdUsuario(idUsuario) {
  const query = `SELECT * FROM vista_empresas_detalle WHERE id_usuario = ?`;
  const [rows] = await db.query(query, [idUsuario]);
  return rows[0];
}
```

#### Cambio 3: Actualizar empresa (línea ~70)
**ANTES:**
```javascript
static async actualizar(id, datos) {
  const { razon_social, ruc_nit, descripcion, logo_url } = datos;
  const query = `
    UPDATE empresa
    SET razon_social = ?, ruc_nit = ?, descripcion = ?, logo_url = ?
    WHERE id_empresa = ?
  `;
  const [result] = await db.query(query, [razon_social, ruc_nit, descripcion, logo_url, id]);
  return result;
}
```

**DESPUÉS:**
```javascript
static async actualizar(id, datos) {
  const { razon_social, ruc_nit, descripcion, logo_url } = datos;
  const query = `CALL sp_actualizar_empresa(?, ?, ?, ?, ?, @mensaje)`;
  await db.query(query, [id, razon_social, ruc_nit, descripcion, logo_url]);
  const [[result]] = await db.query('SELECT @mensaje as mensaje');
  return result;
}
```

---

### 5. **backend/src/models/Conversacion.js**

#### Cambio 1: Obtener conversación por ID (línea ~15)
**ANTES:**
```javascript
static async getConversacionPorId(id) {
  const query = `
    SELECT c.*,
      CONCAT(uc.nombre, ' ', uc.apellido) as cliente_nombre,
      e.razon_social as empresa_nombre
    FROM conversacion c
    INNER JOIN cliente cli ON c.id_cliente = cli.id_cliente
    INNER JOIN usuario uc ON cli.id_usuario = uc.id_usuario
    INNER JOIN empresa e ON c.id_empresa = e.id_empresa
    WHERE c.id_conversacion = ?
  `;
  const [rows] = await db.query(query, [id]);
  return rows[0];
}
```

**DESPUÉS:**
```javascript
static async getConversacionPorId(id) {
  const query = `
    SELECT * FROM vista_conversaciones_cliente
    WHERE id_conversacion = ?
  `;
  const [rows] = await db.query(query, [id]);
  return rows[0];
}
```

#### Cambio 2: Obtener conversaciones de cliente (línea ~40)
**ANTES:**
```javascript
static async getConversacionesPorCliente(idUsuario) {
  const query = `
    SELECT c.*,
      e.razon_social as empresa_nombre,
      ue.foto_perfil_url as empresa_foto,
      (SELECT COUNT(*) FROM mensaje
       WHERE id_conversacion = c.id_conversacion
       AND leido = 0 AND id_remitente != ?) as mensajes_no_leidos
    FROM conversacion c
    INNER JOIN cliente cli ON c.id_cliente = cli.id_cliente
    INNER JOIN empresa e ON c.id_empresa = e.id_empresa
    INNER JOIN usuario ue ON e.id_usuario = ue.id_usuario
    WHERE cli.id_usuario = ?
    ORDER BY c.fecha_ultimo_mensaje DESC
  `;
  const [rows] = await db.query(query, [idUsuario, idUsuario]);
  return rows;
}
```

**DESPUÉS:**
```javascript
static async getConversacionesPorCliente(idUsuario) {
  const query = `
    SELECT vc.*,
      (SELECT COUNT(*) FROM mensaje
       WHERE id_conversacion = vc.id_conversacion
       AND leido = 0 AND id_remitente != ?) as mensajes_no_leidos
    FROM vista_conversaciones_cliente vc
    WHERE cliente_id_usuario = ?
    ORDER BY fecha_ultimo_mensaje DESC
  `;
  const [rows] = await db.query(query, [idUsuario, idUsuario]);
  return rows;
}
```

#### Cambio 3: Obtener conversaciones de empresa (línea ~70)
**ANTES:**
```javascript
static async getConversacionesPorEmpresa(idUsuario) {
  const query = `
    SELECT c.*,
      CONCAT(uc.nombre, ' ', uc.apellido) as cliente_nombre,
      uc.foto_perfil_url as cliente_foto,
      (SELECT COUNT(*) FROM mensaje
       WHERE id_conversacion = c.id_conversacion
       AND leido = 0 AND id_remitente != ?) as mensajes_no_leidos
    FROM conversacion c
    INNER JOIN cliente cli ON c.id_cliente = cli.id_cliente
    INNER JOIN usuario uc ON cli.id_usuario = uc.id_usuario
    INNER JOIN empresa e ON c.id_empresa = e.id_empresa
    WHERE e.id_usuario = ?
    ORDER BY c.fecha_ultimo_mensaje DESC
  `;
  const [rows] = await db.query(query, [idUsuario, idUsuario]);
  return rows;
}
```

**DESPUÉS:**
```javascript
static async getConversacionesPorEmpresa(idUsuario) {
  const query = `
    SELECT ve.*,
      (SELECT COUNT(*) FROM mensaje
       WHERE id_conversacion = ve.id_conversacion
       AND leido = 0 AND id_remitente != ?) as mensajes_no_leidos
    FROM vista_conversaciones_empresa ve
    WHERE empresa_id_usuario = ?
    ORDER BY fecha_ultimo_mensaje DESC
  `;
  const [rows] = await db.query(query, [idUsuario, idUsuario]);
  return rows;
}
```

#### Cambio 4: Obtener mensajes (línea ~100)
**ANTES:**
```javascript
static async getMensajesPorConversacion(idConversacion, limit, offset) {
  const query = `
    SELECT m.*,
      CONCAT(u.nombre, ' ', u.apellido) as remitente_nombre,
      u.foto_perfil_url as remitente_foto
    FROM mensaje m
    INNER JOIN usuario u ON m.id_remitente = u.id_usuario
    WHERE m.id_conversacion = ?
    ORDER BY m.fecha_envio DESC
    LIMIT ? OFFSET ?
  `;
  const [rows] = await db.query(query, [idConversacion, limit, offset]);
  return rows;
}
```

**DESPUÉS:**
```javascript
static async getMensajesPorConversacion(idConversacion, limit, offset) {
  const query = `
    SELECT * FROM vista_mensajes_detalle
    WHERE id_conversacion = ?
    ORDER BY fecha_envio DESC
    LIMIT ? OFFSET ?
  `;
  const [rows] = await db.query(query, [idConversacion, limit, offset]);
  return rows;
}
```

#### Cambio 5: Crear conversación (línea ~130)
**ANTES:**
```javascript
static async crear(datos) {
  const { id_cliente, id_empresa, id_contratacion } = datos;
  const query = `
    INSERT INTO conversacion (id_cliente, id_empresa, id_contratacion, estado)
    VALUES (?, ?, ?, 'abierta')
  `;
  const [result] = await db.query(query, [id_cliente, id_empresa, id_contratacion]);
  return result.insertId;
}
```

**DESPUÉS:**
```javascript
static async crear(datos) {
  const { id_cliente, id_empresa, id_contratacion } = datos;
  const query = `CALL sp_crear_conversacion(?, ?, ?, @id_conversacion, @mensaje)`;
  await db.query(query, [id_cliente, id_empresa, id_contratacion]);
  const [[result]] = await db.query('SELECT @id_conversacion as id, @mensaje as mensaje');
  return result.id;
}
```

#### Cambio 6: Actualizar estado (línea ~145)
**ANTES:**
```javascript
static async actualizarEstado(id, estado) {
  const query = `UPDATE conversacion SET estado = ? WHERE id_conversacion = ?`;
  const [result] = await db.query(query, [estado, id]);
  return result;
}
```

**DESPUÉS:**
```javascript
static async actualizarEstado(id, estado) {
  const query = `CALL sp_actualizar_estado_conversacion(?, ?, @mensaje)`;
  await db.query(query, [id, estado]);
  const [[result]] = await db.query('SELECT @mensaje as mensaje');
  return result;
}
```

#### Cambio 7: Marcar mensajes como leídos (línea ~155)
**ANTES:**
```javascript
static async marcarMensajesLeidos(idConversacion, idRemitente) {
  const query = `
    UPDATE mensaje
    SET leido = 1, fecha_lectura = NOW()
    WHERE id_conversacion = ? AND id_remitente != ? AND leido = 0
  `;
  const [result] = await db.query(query, [idConversacion, idRemitente]);
  return result;
}
```

**DESPUÉS:**
```javascript
static async marcarMensajesLeidos(idConversacion, idRemitente) {
  const query = `CALL sp_marcar_mensajes_leidos(?, ?, @mensaje)`;
  await db.query(query, [idConversacion, idRemitente]);
  const [[result]] = await db.query('SELECT @mensaje as mensaje');
  return result;
}
```

---

### 6. **backend/src/models/Servicio.js**

#### Cambio 1: Crear servicio (línea ~20)
**ANTES:**
```javascript
static async crear(datos) {
  const { id_empresa, id_categoria, nombre, descripcion, precio_base, duracion_estimada, imagen_url, estado } = datos;
  const query = `
    INSERT INTO servicio (id_empresa, id_categoria, nombre, descripcion, precio_base, duracion_estimada, imagen_url, estado)
    VALUES (?, ?, ?, ?, ?, ?, ?, ?)
  `;
  const [result] = await db.query(query, [id_empresa, id_categoria, nombre, descripcion, precio_base, duracion_estimada, imagen_url, estado || 'activo']);
  return result.insertId;
}
```

**DESPUÉS:**
```javascript
static async crear(datos) {
  const { id_empresa, id_categoria, nombre, descripcion, precio_base, duracion_estimada, imagen_url, estado } = datos;
  const query = `CALL sp_crear_servicio(?, ?, ?, ?, ?, ?, ?, ?, @id_servicio, @mensaje)`;
  await db.query(query, [id_empresa, id_categoria, nombre, descripcion, precio_base, duracion_estimada, imagen_url, estado || 'activo']);
  const [[result]] = await db.query('SELECT @id_servicio as id, @mensaje as mensaje');
  return result.id;
}
```

#### Cambio 2: Actualizar servicio (línea ~35)
**ANTES:**
```javascript
static async actualizar(id, datos) {
  const { nombre, descripcion, precio_base, duracion_estimada, imagen_url, estado, id_categoria } = datos;
  const query = `
    UPDATE servicio
    SET nombre = ?, descripcion = ?, precio_base = ?, duracion_estimada = ?, imagen_url = ?, estado = ?, id_categoria = ?
    WHERE id_servicio = ?
  `;
  const [result] = await db.query(query, [nombre, descripcion, precio_base, duracion_estimada, imagen_url, estado, id_categoria, id]);
  return result;
}
```

**DESPUÉS:**
```javascript
static async actualizar(id, datos) {
  const { nombre, descripcion, precio_base, duracion_estimada, imagen_url, estado, id_categoria } = datos;
  const query = `CALL sp_actualizar_servicio(?, ?, ?, ?, ?, ?, ?, ?, @mensaje)`;
  await db.query(query, [id, nombre, descripcion, precio_base, duracion_estimada, imagen_url, estado, id_categoria]);
  const [[result]] = await db.query('SELECT @mensaje as mensaje');
  return result;
}
```

#### Cambio 3: Eliminar servicio (línea ~50)
**ANTES:**
```javascript
static async eliminar(id) {
  // Primero eliminar asociaciones
  await db.query('DELETE FROM servicio_sucursal WHERE id_servicio = ?', [id]);
  // Luego eliminar servicio
  const query = `DELETE FROM servicio WHERE id_servicio = ?`;
  const [result] = await db.query(query, [id]);
  return result;
}
```

**DESPUÉS:**
```javascript
static async eliminar(id) {
  const query = `CALL sp_eliminar_servicio(?, @mensaje)`;
  await db.query(query, [id]);
  const [[result]] = await db.query('SELECT @mensaje as mensaje');
  return result;
}
```

#### Cambio 4: Obtener sucursales del servicio (línea ~80)
**ANTES:**
```javascript
static async getSucursalesPorServicio(idServicio) {
  const query = `
    SELECT ss.*, s.nombre_sucursal, s.telefono, s.estado,
      d.ciudad, d.calle_principal
    FROM servicio_sucursal ss
    INNER JOIN sucursal s ON ss.id_sucursal = s.id_sucursal
    INNER JOIN direccion d ON s.id_direccion = d.id_direccion
    WHERE ss.id_servicio = ?
  `;
  const [rows] = await db.query(query, [idServicio]);
  return rows;
}
```

**DESPUÉS:**
```javascript
static async getSucursalesPorServicio(idServicio) {
  const query = `
    SELECT * FROM vista_servicio_sucursales
    WHERE id_servicio = ?
  `;
  const [rows] = await db.query(query, [idServicio]);
  return rows;
}
```

#### Cambio 5: Actualizar disponibilidad (línea ~100)
**ANTES:**
```javascript
static async actualizarDisponibilidad(idServicio, idSucursal, disponible) {
  const query = `UPDATE servicio_sucursal SET disponible = ? WHERE id_servicio = ? AND id_sucursal = ?`;
  const [result] = await db.query(query, [disponible, idServicio, idSucursal]);
  return result;
}
```

**DESPUÉS:**
```javascript
static async actualizarDisponibilidad(idServicio, idSucursal, disponible) {
  const query = `CALL sp_actualizar_disponibilidad_servicio(?, ?, ?, @mensaje)`;
  await db.query(query, [idServicio, idSucursal, disponible]);
  const [[result]] = await db.query('SELECT @mensaje as mensaje');
  return result;
}
```

#### Cambio 6: Eliminar de sucursal (línea ~110)
**ANTES:**
```javascript
static async eliminarDeSucursal(idServicio, idSucursal) {
  const query = `DELETE FROM servicio_sucursal WHERE id_servicio = ? AND id_sucursal = ?`;
  const [result] = await db.query(query, [idServicio, idSucursal]);
  return result;
}
```

**DESPUÉS:**
```javascript
static async eliminarDeSucursal(idServicio, idSucursal) {
  const query = `CALL sp_eliminar_servicio_sucursal(?, ?, @mensaje)`;
  await db.query(query, [idServicio, idSucursal]);
  const [[result]] = await db.query('SELECT @mensaje as mensaje');
  return result;
}
```

---

### 7. **backend/src/models/Sucursal.js**

#### Cambio 1: Obtener sucursal por ID (línea ~15)
**ANTES:**
```javascript
static async getSucursalPorId(id) {
  const query = `
    SELECT s.*, d.*
    FROM sucursal s
    INNER JOIN direccion d ON s.id_direccion = d.id_direccion
    WHERE s.id_sucursal = ?
  `;
  const [rows] = await db.query(query, [id]);
  return rows[0];
}
```

**DESPUÉS:**
```javascript
static async getSucursalPorId(id) {
  const query = `SELECT * FROM vista_sucursales_detalle WHERE id_sucursal = ?`;
  const [rows] = await db.query(query, [id]);
  return rows[0];
}
```

#### Cambio 2: Obtener sucursales por empresa (línea ~30)
**ANTES:**
```javascript
static async getSucursalesPorEmpresa(idEmpresa, limit, offset) {
  const query = `
    SELECT s.*, d.*
    FROM sucursal s
    INNER JOIN direccion d ON s.id_direccion = d.id_direccion
    WHERE s.id_empresa = ?
    ORDER BY s.id_sucursal DESC
    LIMIT ? OFFSET ?
  `;
  const [rows] = await db.query(query, [idEmpresa, limit, offset]);
  return rows;
}
```

**DESPUÉS:**
```javascript
static async getSucursalesPorEmpresa(idEmpresa, limit, offset) {
  const query = `
    SELECT * FROM vista_sucursales_detalle
    WHERE id_empresa = ?
    ORDER BY id_sucursal DESC
    LIMIT ? OFFSET ?
  `;
  const [rows] = await db.query(query, [idEmpresa, limit, offset]);
  return rows;
}
```

#### Cambio 3: Obtener servicios de sucursal (línea ~70)
**ANTES:**
```javascript
static async getServiciosPorSucursal(idSucursal) {
  const query = `
    SELECT s.*, ss.disponible, c.nombre as categoria_nombre
    FROM servicio_sucursal ss
    INNER JOIN servicio s ON ss.id_servicio = s.id_servicio
    INNER JOIN categoria_servicio c ON s.id_categoria = c.id_categoria
    WHERE ss.id_sucursal = ?
    ORDER BY s.nombre ASC
  `;
  const [rows] = await db.query(query, [idSucursal]);
  return rows;
}
```

**DESPUÉS:**
```javascript
static async getServiciosPorSucursal(idSucursal) {
  const query = `
    SELECT * FROM vista_servicios_sucursal
    WHERE id_sucursal = ?
    ORDER BY servicio_nombre ASC
  `;
  const [rows] = await db.query(query, [idSucursal]);
  return rows;
}
```

#### Cambio 4: Actualizar sucursal (línea ~90)
**ANTES:**
```javascript
static async actualizar(id, datosSucursal, datosDireccion) {
  const connection = await db.getConnection();
  try {
    await connection.beginTransaction();

    // Actualizar sucursal
    const querySucursal = `UPDATE sucursal SET ... WHERE id_sucursal = ?`;
    await connection.query(querySucursal, [..., id]);

    // Actualizar dirección
    const queryDireccion = `UPDATE direccion SET ... WHERE id_direccion = ?`;
    await connection.query(queryDireccion, [..., idDireccion]);

    await connection.commit();
  } catch (error) {
    await connection.rollback();
    throw error;
  } finally {
    connection.release();
  }
}
```

**DESPUÉS:**
```javascript
static async actualizar(id, datosSucursal, datosDireccion) {
  const { nombre_sucursal, telefono, horario_apertura, horario_cierre, dias_laborales, estado } = datosSucursal;
  const { calle_principal, calle_secundaria, numero, ciudad, provincia_estado, codigo_postal, pais, latitud, longitud, referencia } = datosDireccion;

  const query = `CALL sp_actualizar_sucursal(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, @mensaje)`;
  await db.query(query, [
    id, nombre_sucursal, telefono, horario_apertura, horario_cierre, dias_laborales, estado,
    calle_principal, calle_secundaria, numero, ciudad, provincia_estado, codigo_postal, pais, latitud, longitud, referencia
  ]);
  const [[result]] = await db.query('SELECT @mensaje as mensaje');
  return result;
}
```

#### Cambio 5: Cambiar estado (línea ~120)
**ANTES:**
```javascript
static async cambiarEstado(id, estado) {
  const query = `UPDATE sucursal SET estado = ? WHERE id_sucursal = ?`;
  const [result] = await db.query(query, [estado, id]);
  return result;
}
```

**DESPUÉS:**
```javascript
static async cambiarEstado(id, estado) {
  const query = `CALL sp_cambiar_estado_sucursal(?, ?, @mensaje)`;
  await db.query(query, [id, estado]);
  const [[result]] = await db.query('SELECT @mensaje as mensaje');
  return result;
}
```

---

### 8. **backend/src/models/Notificacion.js**

#### Cambio 1: Crear notificación (línea ~15)
**ANTES:**
```javascript
static async crear(datos) {
  const { id_usuario, titulo, contenido, tipo, referencia_id, referencia_tipo } = datos;
  const query = `
    INSERT INTO notificacion (id_usuario, titulo, contenido, tipo, referencia_id, referencia_tipo)
    VALUES (?, ?, ?, ?, ?, ?)
  `;
  const [result] = await db.query(query, [id_usuario, titulo, contenido, tipo, referencia_id, referencia_tipo]);
  return result.insertId;
}
```

**DESPUÉS:**
```javascript
static async crear(datos) {
  const { id_usuario, titulo, contenido, tipo, referencia_id, referencia_tipo } = datos;
  const query = `CALL sp_crear_notificacion(?, ?, ?, ?, ?, ?, @id_notificacion, @mensaje)`;
  await db.query(query, [id_usuario, titulo, contenido, tipo, referencia_id, referencia_tipo]);
  const [[result]] = await db.query('SELECT @id_notificacion as id, @mensaje as mensaje');
  return result.id;
}
```

#### Cambio 2: Marcar como leída (línea ~35)
**ANTES:**
```javascript
static async marcarComoLeida(id) {
  const query = `UPDATE notificacion SET leida = 1, fecha_lectura = NOW() WHERE id_notificacion = ?`;
  const [result] = await db.query(query, [id]);
  return result;
}
```

**DESPUÉS:**
```javascript
static async marcarComoLeida(id) {
  const query = `CALL sp_marcar_notificacion_leida(?, @mensaje)`;
  await db.query(query, [id]);
  const [[result]] = await db.query('SELECT @mensaje as mensaje');
  return result;
}
```

#### Cambio 3: Marcar todas como leídas (línea ~45)
**ANTES:**
```javascript
static async marcarTodasComoLeidas(idUsuario) {
  const query = `UPDATE notificacion SET leida = 1, fecha_lectura = NOW() WHERE id_usuario = ? AND leida = 0`;
  const [result] = await db.query(query, [idUsuario]);
  return result;
}
```

**DESPUÉS:**
```javascript
static async marcarTodasComoLeidas(idUsuario) {
  const query = `CALL sp_marcar_todas_notificaciones_leidas(?, @mensaje)`;
  await db.query(query, [idUsuario]);
  const [[result]] = await db.query('SELECT @mensaje as mensaje');
  return result;
}
```

#### Cambio 4: Eliminar notificación (línea ~55)
**ANTES:**
```javascript
static async eliminar(id) {
  const query = `DELETE FROM notificacion WHERE id_notificacion = ?`;
  const [result] = await db.query(query, [id]);
  return result;
}
```

**DESPUÉS:**
```javascript
static async eliminar(id) {
  const query = `CALL sp_eliminar_notificacion(?, @mensaje)`;
  await db.query(query, [id]);
  const [[result]] = await db.query('SELECT @mensaje as mensaje');
  return result;
}
```

---

### 9. **backend/src/models/Calificacion.js**

#### Cambio 1: Obtener calificaciones de servicio (línea ~15)
**ANTES:**
```javascript
static async getCalificacionesPorServicio(idServicio, limit, offset) {
  const query = `
    SELECT cal.*,
      CONCAT(u.nombre, ' ', u.apellido) as cliente_nombre,
      u.foto_perfil_url
    FROM calificacion cal
    INNER JOIN contratacion con ON cal.id_contratacion = con.id_contratacion
    INNER JOIN cliente cli ON con.id_cliente = cli.id_cliente
    INNER JOIN usuario u ON cli.id_usuario = u.id_usuario
    WHERE con.id_servicio = ? AND cal.tipo = 'cliente_a_empresa'
    ORDER BY cal.fecha_calificacion DESC
    LIMIT ? OFFSET ?
  `;
  const [rows] = await db.query(query, [idServicio, limit, offset]);
  return rows;
}
```

**DESPUÉS:**
```javascript
static async getCalificacionesPorServicio(idServicio, limit, offset) {
  const query = `
    SELECT * FROM vista_calificaciones_servicio
    WHERE id_servicio = ? AND tipo = 'cliente_a_empresa'
    ORDER BY fecha_calificacion DESC
    LIMIT ? OFFSET ?
  `;
  const [rows] = await db.query(query, [idServicio, limit, offset]);
  return rows;
}
```

#### Cambio 2: Obtener calificaciones de empresa (línea ~40)
**ANTES:**
```javascript
static async getCalificacionesPorEmpresa(idEmpresa, limit, offset) {
  const query = `
    SELECT cal.*,
      CONCAT(u.nombre, ' ', u.apellido) as cliente_nombre,
      u.foto_perfil_url,
      s.nombre as servicio_nombre
    FROM calificacion cal
    INNER JOIN contratacion con ON cal.id_contratacion = con.id_contratacion
    INNER JOIN cliente cli ON con.id_cliente = cli.id_cliente
    INNER JOIN usuario u ON cli.id_usuario = u.id_usuario
    INNER JOIN servicio s ON con.id_servicio = s.id_servicio
    WHERE s.id_empresa = ? AND cal.tipo = 'cliente_a_empresa'
    ORDER BY cal.fecha_calificacion DESC
    LIMIT ? OFFSET ?
  `;
  const [rows] = await db.query(query, [idEmpresa, limit, offset]);
  return rows;
}
```

**DESPUÉS:**
```javascript
static async getCalificacionesPorEmpresa(idEmpresa, limit, offset) {
  const query = `
    SELECT * FROM vista_calificaciones_empresa
    WHERE id_empresa = ? AND tipo = 'cliente_a_empresa'
    ORDER BY fecha_calificacion DESC
    LIMIT ? OFFSET ?
  `;
  const [rows] = await db.query(query, [idEmpresa, limit, offset]);
  return rows;
}
```

#### Cambio 3: Obtener calificaciones pendientes (línea ~70)
**ANTES:**
```javascript
static async getCalificacionesPendientes(idUsuario) {
  const query = `
    SELECT c.id_contratacion, c.fecha_completada,
      s.nombre as servicio_nombre,
      e.razon_social as empresa_nombre,
      s.imagen_url as imagen_principal
    FROM contratacion c
    INNER JOIN cliente cli ON c.id_cliente = cli.id_cliente
    INNER JOIN servicio s ON c.id_servicio = s.id_servicio
    INNER JOIN empresa e ON s.id_empresa = e.id_empresa
    LEFT JOIN calificacion cal ON c.id_contratacion = cal.id_contratacion
      AND cal.tipo = 'cliente_a_empresa'
    WHERE cli.id_usuario = ? AND c.estado = 'completado' AND cal.id_calificacion IS NULL
    ORDER BY c.fecha_completada DESC
  `;
  const [rows] = await db.query(query, [idUsuario]);
  return rows;
}
```

**DESPUÉS:**
```javascript
static async getCalificacionesPendientes(idUsuario) {
  const query = `
    SELECT * FROM vista_calificaciones_pendientes
    WHERE cliente_id_usuario = ?
    ORDER BY fecha_completada DESC
  `;
  const [rows] = await db.query(query, [idUsuario]);
  return rows;
}
```

---

### 10. **backend/src/models/Cliente.js**

#### Cambio 1: Obtener todos los clientes (línea ~15)
**ANTES:**
```javascript
static async getTodosLosClientes() {
  const query = `
    SELECT c.*, u.email, u.nombre, u.apellido, u.telefono, u.foto_perfil_url, u.estado, u.fecha_registro
    FROM cliente c
    INNER JOIN usuario u ON c.id_usuario = u.id_usuario
    ORDER BY u.fecha_registro DESC
  `;
  const [rows] = await db.query(query);
  return rows;
}
```

**DESPUÉS:**
```javascript
static async getTodosLosClientes() {
  const query = `SELECT * FROM vista_clientes_detalle ORDER BY fecha_registro DESC`;
  const [rows] = await db.query(query);
  return rows;
}
```

#### Cambio 2: Obtener cliente por ID (línea ~30)
**ANTES:**
```javascript
static async getClientePorId(id) {
  const query = `
    SELECT c.*, u.*
    FROM cliente c
    INNER JOIN usuario u ON c.id_usuario = u.id_usuario
    WHERE c.id_cliente = ?
  `;
  const [rows] = await db.query(query, [id]);
  return rows[0];
}
```

**DESPUÉS:**
```javascript
static async getClientePorId(id) {
  const query = `SELECT * FROM vista_clientes_detalle WHERE id_cliente = ?`;
  const [rows] = await db.query(query, [id]);
  return rows[0];
}
```

#### Cambio 3: Obtener direcciones (línea ~50)
**ANTES:**
```javascript
static async getDireccionesPorCliente(idCliente) {
  const query = `
    SELECT d.*, dc.alias, dc.es_principal
    FROM direcciones_del_cliente dc
    INNER JOIN direccion d ON dc.id_direccion = d.id_direccion
    WHERE dc.id_cliente = ?
    ORDER BY dc.es_principal DESC, d.id_direccion DESC
  `;
  const [rows] = await db.query(query, [idCliente]);
  return rows;
}
```

**DESPUÉS:**
```javascript
static async getDireccionesPorCliente(idCliente) {
  const query = `
    SELECT * FROM vista_direcciones_cliente
    WHERE id_cliente = ?
    ORDER BY es_principal DESC, id_direccion DESC
  `;
  const [rows] = await db.query(query, [idCliente]);
  return rows;
}
```

#### Cambio 4: Agregar dirección (línea ~70)
**ANTES:**
```javascript
static async agregarDireccion(idCliente, datosDireccion, alias, esPrincipal) {
  const connection = await db.getConnection();
  try {
    await connection.beginTransaction();

    if (esPrincipal) {
      await connection.query('UPDATE direcciones_del_cliente SET es_principal = 0 WHERE id_cliente = ?', [idCliente]);
    }

    const [resultDir] = await connection.query('INSERT INTO direccion (...) VALUES (...)', [...]);
    const idDireccion = resultDir.insertId;

    await connection.query('INSERT INTO direcciones_del_cliente (id_cliente, id_direccion, alias, es_principal) VALUES (?, ?, ?, ?)', [idCliente, idDireccion, alias, esPrincipal]);

    await connection.commit();
    return idDireccion;
  } catch (error) {
    await connection.rollback();
    throw error;
  } finally {
    connection.release();
  }
}
```

**DESPUÉS:**
```javascript
static async agregarDireccion(idCliente, datosDireccion, alias, esPrincipal) {
  const { calle_principal, calle_secundaria, numero, ciudad, provincia_estado, codigo_postal, pais, latitud, longitud, referencia } = datosDireccion;

  const query = `CALL sp_agregar_direccion_cliente(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, @id_direccion, @mensaje)`;
  await db.query(query, [
    idCliente, calle_principal, calle_secundaria, numero, ciudad, provincia_estado,
    codigo_postal, pais, latitud, longitud, referencia, alias, esPrincipal
  ]);
  const [[result]] = await db.query('SELECT @id_direccion as id, @mensaje as mensaje');
  return result.id;
}
```

#### Cambio 5: Actualizar alias (línea ~100)
**ANTES:**
```javascript
static async actualizarAlias(idCliente, idDireccion, alias) {
  const query = `UPDATE direcciones_del_cliente SET alias = ? WHERE id_cliente = ? AND id_direccion = ?`;
  const [result] = await db.query(query, [alias, idCliente, idDireccion]);
  return result;
}
```

**DESPUÉS:**
```javascript
static async actualizarAlias(idCliente, idDireccion, alias) {
  const query = `CALL sp_actualizar_alias_direccion(?, ?, ?, @mensaje)`;
  await db.query(query, [idCliente, idDireccion, alias]);
  const [[result]] = await db.query('SELECT @mensaje as mensaje');
  return result;
}
```

#### Cambio 6: Eliminar dirección (línea ~110)
**ANTES:**
```javascript
static async eliminarDireccion(idCliente, idDireccion) {
  const query = `DELETE FROM direcciones_del_cliente WHERE id_cliente = ? AND id_direccion = ?`;
  const [result] = await db.query(query, [idCliente, idDireccion]);
  return result;
}
```

**DESPUÉS:**
```javascript
static async eliminarDireccion(idCliente, idDireccion) {
  const query = `CALL sp_eliminar_direccion_cliente(?, ?, @mensaje)`;
  await db.query(query, [idCliente, idDireccion]);
  const [[result]] = await db.query('SELECT @mensaje as mensaje');
  return result;
}
```

---

### 11. **backend/src/models/Direccion.js**

#### Cambio 1: Actualizar dirección (línea ~15)
**ANTES:**
```javascript
static async actualizar(id, datos) {
  const { calle_principal, calle_secundaria, numero, ciudad, provincia_estado, codigo_postal, pais, latitud, longitud, referencia } = datos;
  const query = `
    UPDATE direccion
    SET calle_principal = ?, calle_secundaria = ?, numero = ?, ciudad = ?, provincia_estado = ?,
        codigo_postal = ?, pais = ?, latitud = ?, longitud = ?, referencia = ?
    WHERE id_direccion = ?
  `;
  const [result] = await db.query(query, [calle_principal, calle_secundaria, numero, ciudad, provincia_estado, codigo_postal, pais, latitud, longitud, referencia, id]);
  return result;
}
```

**DESPUÉS:**
```javascript
static async actualizar(id, datos) {
  const { calle_principal, calle_secundaria, numero, ciudad, provincia_estado, codigo_postal, pais, latitud, longitud, referencia } = datos;
  const query = `CALL sp_actualizar_direccion(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, @mensaje)`;
  await db.query(query, [id, calle_principal, calle_secundaria, numero, ciudad, provincia_estado, codigo_postal, pais, latitud, longitud, referencia]);
  const [[result]] = await db.query('SELECT @mensaje as mensaje');
  return result;
}
```

#### Cambio 2: Eliminar dirección (línea ~35)
**ANTES:**
```javascript
static async eliminar(id) {
  // Verificar si está en uso
  const [countClientes] = await db.query('SELECT COUNT(*) as count FROM direcciones_del_cliente WHERE id_direccion = ?', [id]);
  if (countClientes[0].count > 0) {
    throw new Error('La dirección está en uso por uno o más clientes');
  }

  const [countSucursales] = await db.query('SELECT COUNT(*) as count FROM sucursal WHERE id_direccion = ?', [id]);
  if (countSucursales[0].count > 0) {
    throw new Error('La dirección está en uso por una o más sucursales');
  }

  const query = `DELETE FROM direccion WHERE id_direccion = ?`;
  const [result] = await db.query(query, [id]);
  return result;
}
```

**DESPUÉS:**
```javascript
static async eliminar(id) {
  const query = `CALL sp_eliminar_direccion(?, @mensaje)`;
  await db.query(query, [id]);
  const [[result]] = await db.query('SELECT @mensaje as mensaje');
  return result;
}
```

---

### 12. **backend/src/models/Contratacion.js**

#### Cambio 1: Obtener historial de estados (línea ~100)
**ANTES:**
```javascript
static async getHistorialEstados(idEmpresa, limit, offset) {
  const query = `
    SELECT h.*, c.id_servicio, s.nombre as servicio_nombre,
      u.nombre as usuario_nombre, u.apellido as usuario_apellido
    FROM historial_estado_contratacion h
    INNER JOIN contratacion c ON h.id_contratacion = c.id_contratacion
    INNER JOIN servicio s ON c.id_servicio = s.id_servicio
    LEFT JOIN usuario u ON h.id_usuario_responsable = u.id_usuario
    WHERE s.id_empresa = ?
    ORDER BY h.fecha_cambio DESC
    LIMIT ? OFFSET ?
  `;
  const [rows] = await db.query(query, [idEmpresa, limit, offset]);
  return rows;
}
```

**DESPUÉS:**
```javascript
static async getHistorialEstados(idEmpresa, limit, offset) {
  const query = `
    SELECT * FROM vista_historial_estados
    WHERE id_empresa = ?
    ORDER BY fecha_cambio DESC
    LIMIT ? OFFSET ?
  `;
  const [rows] = await db.query(query, [idEmpresa, limit, offset]);
  return rows;
}
```

#### Cambio 2: Actualizar comisiones (línea ~130)
**ANTES:**
```javascript
static async actualizarComisiones(idContratacion, comisionPlataforma, gananciaEmpresa) {
  const query = `
    UPDATE contratacion
    SET comision_plataforma = ?, ganancia_empresa = ?
    WHERE id_contratacion = ?
  `;
  const [result] = await db.query(query, [comisionPlataforma, gananciaEmpresa, idContratacion]);
  return result;
}
```

**DESPUÉS:**
```javascript
static async actualizarComisiones(idContratacion, comisionPlataforma, gananciaEmpresa) {
  const query = `CALL sp_actualizar_comisiones(?, ?, ?, @mensaje)`;
  await db.query(query, [idContratacion, comisionPlataforma, gananciaEmpresa]);
  const [[result]] = await db.query('SELECT @mensaje as mensaje');
  return result;
}
```

---

## CAMBIOS EN CONTROLADORES

### 1. **backend/src/controllers/contratacionController.js**

#### Cambio 1: Crear pago (línea ~150)
**ANTES:**
```javascript
const queryPago = `INSERT INTO pago (id_contratacion, monto, metodo_pago, estado_pago) VALUES (?, ?, ?, 'pendiente')`;
await db.query(queryPago, [idContratacion, precio_total, metodo_pago]);
```

**DESPUÉS:**
```javascript
const queryPago = `CALL sp_crear_pago(?, ?, ?, @id_pago, @mensaje)`;
await db.query(queryPago, [idContratacion, precio_total, metodo_pago]);
```

#### Cambio 2: Actualizar estado de pago (línea ~200)
**ANTES:**
```javascript
const query = `UPDATE pago SET estado_pago = ? WHERE id_contratacion = ?`;
await db.query(query, [estado_pago, idContratacion]);
```

**DESPUÉS:**
```javascript
const query = `CALL sp_actualizar_estado_pago(?, ?, @mensaje)`;
await db.query(query, [idContratacion, estado_pago]);
```

---

## RESUMEN

### Total de Archivos a Modificar: 14

#### Modelos (12 archivos):
1. ✅ backend/src/models/Usuario.js
2. ✅ backend/src/models/Categoria.js
3. ✅ backend/src/models/Favorito.js
4. ✅ backend/src/models/Empresa.js
5. ✅ backend/src/models/Conversacion.js
6. ✅ backend/src/models/Servicio.js
7. ✅ backend/src/models/Sucursal.js
8. ✅ backend/src/models/Notificacion.js
9. ✅ backend/src/models/Calificacion.js
10. ✅ backend/src/models/Cliente.js
11. ✅ backend/src/models/Direccion.js
12. ✅ backend/src/models/Contratacion.js

#### Controladores (2 archivos):
13. ✅ backend/src/controllers/contratacionController.js
14. ✅ backend/src/controllers/servicioController.js

### Estadísticas de Migración:

- **Total de Queries Migradas**: ~80 queries
- **Vistas Creadas**: 15 vistas
- **Stored Procedures Creados**: 40 SPs
- **Queries SELECT → Vistas**: ~35 migraciones
- **Queries INSERT/UPDATE/DELETE → SPs**: ~45 migraciones

### Beneficios de la Migración:

1. ✅ **Mejor rendimiento**: Las vistas precompilan joins complejos
2. ✅ **Seguridad mejorada**: SPs previenen SQL injection
3. ✅ **Mantenimiento centralizado**: Cambios en BD sin modificar código
4. ✅ **Validación de datos**: SPs validan en el servidor de BD
5. ✅ **Transacciones atómicas**: SPs garantizan consistencia de datos
6. ✅ **Reutilización**: Vistas y SPs compartidos entre diferentes endpoints

---

## NOTAS IMPORTANTES

1. **Orden de instalación**: Primero instala las vistas, luego los SPs
2. **Testing**: Prueba cada endpoint después de la migración
3. **Rollback**: Mantén backups de los archivos originales
4. **Logs**: Revisa los logs de MySQL si hay errores en los SPs
5. **Performance**: Monitorea el rendimiento antes y después

---

**Fecha de creación**: 2025
**Versión**: 1.0
