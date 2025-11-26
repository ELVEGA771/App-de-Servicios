# Stored Procedures - Guía Completa (Versión 2.0)

## 🎯 Cambios Importantes en esta Versión

### ✅ Eliminada Dependencia de Triggers
- **Toda** la lógica de triggers ahora está implementada en stored procedures
- Los triggers son **obsoletos** y deben eliminarse
- Mejor control, debugging y mantenibilidad

### ✅ Soporte para Nueva Estructura de BD
- Tabla `historial_estado_contratacion` para auditoría
- Columnas calculadas de comisiones en `contratacion`:
  - `porcentaje_comision` (default 15%)
  - `comision_plataforma` (GENERATED)
  - `ganancia_empresa` (GENERATED)

---

## 📋 Stored Procedures Implementados (8 SPs)

| # | SP | Descripción | Reemplaza Trigger |
|---|---|---|---|
| 1 | `sp_registrar_usuario` | Registro cliente/empresa | - |
| 2 | `sp_crear_sucursal` | Sucursal + dirección | - |
| 3 | `sp_crear_calificacion` | Calificación + promedio empresa | ✅ `trg_actualizar_calificacion_empresa` |
| 4 | `sp_establecer_direccion_principal` | Dirección principal | - |
| 5 | `sp_asociar_servicio_sucursal` | Servicio-sucursal (upsert) | - |
| 6 | `sp_actualizar_estado_contratacion` | Cambio estado + historial | - |
| 7 | `sp_crear_contratacion` | Contratación + cupón + historial | ✅ `trg_incrementar_uso_cupon` |
| 8 | `sp_crear_mensaje` | Mensaje + actualizar conversación | ✅ `trg_actualizar_ultimo_mensaje` |

---

## 🚀 Instalación Completa

### Paso 1: Aplicar Cambios al DER

Primero aplica los cambios a la estructura de la base de datos:

```bash
# Ejecutar script con cambios del DER
mysql -u root -p app_servicios < BASEVERSIONFINAL3.sql
```

**Cambios aplicados:**
1. Nueva tabla `historial_estado_contratacion`
2. Nuevas columnas en `contratacion`: `porcentaje_comision`, `comision_plataforma`, `ganancia_empresa`

### Paso 2: Instalar Stored Procedures

```bash
# Instalar los 8 stored procedures
mysql -u root -p app_servicios < backend/database/stored_procedures.sql
```

### Paso 3: Eliminar Triggers Obsoletos

```bash
# Eliminar los 3 triggers que ya no son necesarios
mysql -u root -p app_servicios < backend/database/drop_triggers.sql
```

### Paso 4: Verificar Instalación

```bash
# Ver stored procedures instalados
mysql -u root -p -e "SHOW PROCEDURE STATUS WHERE Db = 'app_servicios';"

# Verificar que no hay triggers (debe estar vacío)
mysql -u root -p -e "SHOW TRIGGERS FROM app_servicios;"
```

**Deberías ver:**
- ✅ 8 stored procedures
- ✅ 0 triggers (o solo triggers personalizados que no están en drop_triggers.sql)

---

## 📖 Documentación de SPs

### SP 1: sp_registrar_usuario

**Descripción**: Crea usuario y entidad relacionada (cliente o empresa).

**Parámetros IN**:
- `p_email`, `p_password_hash`, `p_nombre`, `p_apellido`, `p_telefono`, `p_tipo_usuario`
- `p_razon_social`, `p_ruc_nit`, `p_pais` (para empresas)

**Parámetros OUT**:
- `p_out_id_usuario`, `p_out_id_entidad`, `p_out_mensaje`

**Validaciones**:
- Email único
- Tipo usuario válido
- Razón social obligatoria para empresas

---

### SP 2: sp_crear_sucursal

**Descripción**: Crea sucursal con su dirección en transacción.

**Parámetros OUT**:
- `p_out_id_sucursal`, `p_out_id_direccion`, `p_out_mensaje`

**Validaciones**:
- Empresa existe
- Datos obligatorios completos

---

### SP 3: sp_crear_calificacion ⚡ SIN TRIGGER

**Descripción**: Crea calificación y **actualiza promedio de empresa manualmente**.

**Lógica implementada (antes en trigger)**:
```sql
-- Si es calificación cliente_a_empresa:
-- 1. Obtener ID de empresa
-- 2. Calcular nuevo promedio
-- 3. Actualizar empresa.calificacion_promedio
```

**Parámetros OUT**:
- `p_out_id_calificacion`, `p_out_mensaje`

**Validaciones**:
- Contratación completada
- No existe calificación previa
- Calificación entre 1-5

---

### SP 4: sp_establecer_direccion_principal

**Descripción**: Operación atómica para marcar dirección principal.

**Parámetros OUT**:
- `p_out_mensaje`

---

### SP 5: sp_asociar_servicio_sucursal

**Descripción**: Asocia servicio a sucursal (upsert).

**Parámetros OUT**:
- `p_out_mensaje`

---

### SP 6: sp_actualizar_estado_contratacion 📊 CON HISTORIAL

**Descripción**: Actualiza estado y **registra en historial**.

**Nueva funcionalidad**:
```sql
-- Inserta en historial_estado_contratacion:
-- - estado_anterior
-- - estado_nuevo
-- - fecha_cambio (automático)
-- - notas
```

**Parámetros IN**:
- `p_id_contratacion`, `p_nuevo_estado`, `p_notas`

**Parámetros OUT**:
- `p_out_mensaje`

**Validaciones**:
- No se puede modificar si está cancelado/completado/rechazado
- Auto-actualiza `fecha_completada` si estado = 'completado'

---

### SP 7: sp_crear_contratacion ⚡ SIN TRIGGER + 📊 CON HISTORIAL

**Descripción**: Crea contratación, **incrementa cupón manualmente**, registra historial.

**Lógica implementada (antes en trigger)**:
```sql
-- Si id_cupon IS NOT NULL:
-- - UPDATE cupon SET cantidad_usada = cantidad_usada + 1
```

**Nueva funcionalidad**:
```sql
-- Inserta en historial_estado_contratacion:
-- - estado_anterior = NULL (nueva contratación)
-- - estado_nuevo = 'pendiente'
-- - notas = 'Contratación creada'
```

**Parámetros IN** (NUEVO):
- Incluye `p_porcentaje_comision` (default 15.00)
- Las columnas calculadas se generan automáticamente

**Parámetros OUT**:
- `p_out_id_contratacion`, `p_out_mensaje`

**Validaciones**:
- Cliente existe
- Servicio existe
- Cupón válido (si se usa)

---

### SP 8: sp_crear_mensaje ⚡ SIN TRIGGER

**Descripción**: Crea mensaje y **actualiza fecha en conversación manualmente**.

**Lógica implementada (antes en trigger)**:
```sql
-- UPDATE conversacion
-- SET fecha_ultimo_mensaje = NOW()
-- WHERE id_conversacion = p_id_conversacion
```

**Parámetros IN**:
- `p_id_conversacion`, `p_id_remitente`, `p_contenido`
- `p_tipo_mensaje` ('texto', 'imagen', 'archivo')
- `p_archivo_url`

**Parámetros OUT**:
- `p_out_id_mensaje`, `p_out_mensaje`

**Validaciones**:
- Conversación existe
- Contenido no vacío (para tipo 'texto')

---

## 🏗️ Arquitectura: SPs vs Backend

### ✅ En Stored Procedures (MySQL):
- INSERT/UPDATE/DELETE con transacciones
- Validaciones de integridad y existencia
- Operaciones atómicas críticas
- **Lógica que antes estaba en triggers**
- Auditoría y logging (historial)
- Incrementos/decrementos automáticos

### ✅ En Backend (Node.js):
- **Hashing de contraseñas** (bcrypt) - NUNCA en BD
- **Generación de tokens** (JWT)
- SELECTs (simples y complejos)
- Validaciones de negocio complejas
- Integraciones con servicios externos
- Upload de archivos

---

## 📊 Tabla Historial de Estados

### Estructura

```sql
CREATE TABLE historial_estado_contratacion (
  id_historial INT AUTO_INCREMENT,
  id_contratacion INT NOT NULL,
  estado_anterior ENUM(...) NULL,  -- NULL para creación
  estado_nuevo ENUM(...) NOT NULL,
  fecha_cambio DATETIME DEFAULT CURRENT_TIMESTAMP,
  notas TEXT NULL,
  PRIMARY KEY (id_historial)
);
```

### Usos

1. **Auditoría completa**: Ver todos los cambios de estado
2. **Debugging**: Identificar cuándo y cómo cambió un estado
3. **Reportes**: Tiempo promedio en cada estado
4. **Compliance**: Trazabilidad para regulaciones

### Consultar Historial

```sql
-- Ver historial de una contratación
SELECT * FROM historial_estado_contratacion
WHERE id_contratacion = 123
ORDER BY fecha_cambio DESC;
```

---

## 💰 Comisiones y Columnas Calculadas

### Nuevas Columnas en Contratacion

```sql
ALTER TABLE contratacion
  ADD COLUMN porcentaje_comision DECIMAL(5,2) DEFAULT 15.00,
  ADD COLUMN comision_plataforma DECIMAL(10,2)
    GENERATED ALWAYS AS ((precio_total * porcentaje_comision) / 100) STORED,
  ADD COLUMN ganancia_empresa DECIMAL(10,2)
    GENERATED ALWAYS AS (precio_total - ((precio_total * porcentaje_comision) / 100)) STORED;
```

### ¿Cómo Funciona?

1. **Backend envía** `porcentaje_comision` (o usa default 15%)
2. **MySQL calcula automáticamente**:
   - `comision_plataforma = (total * porcentaje) / 100`
   - `ganancia_empresa = total - comision_plataforma`

### Ejemplo

```javascript
// Backend
await Contratacion.create({
  precio_total: 100.00,
  porcentaje_comision: 20.00,  // 20%
  // ...otros campos
});

// MySQL almacena automáticamente:
// comision_plataforma: 20.00  (100 * 20 / 100)
// ganancia_empresa: 80.00     (100 - 20)
```

---

## ⚠️ IMPORTANTE: SPs Obligatorios

**Los stored procedures son OBLIGATORIOS**. Sin ellos, el backend NO funciona.

### Antes de iniciar el servidor:

```bash
# 1. Aplicar DER actualizado
mysql -u root -p app_servicios < BASEVERSIONFINAL3.sql

# 2. Instalar SPs
mysql -u root -p app_servicios < backend/database/stored_procedures.sql

# 3. Eliminar triggers
mysql -u root -p app_servicios < backend/database/drop_triggers.sql

# 4. Verificar
mysql -u root -p -e "SHOW PROCEDURE STATUS WHERE Db = 'app_servicios';"
mysql -u root -p -e "SHOW TRIGGERS FROM app_servicios;"
```

### Si no instalas los SPs:
- ❌ Registro de usuarios → ERROR
- ❌ Crear sucursal → ERROR
- ❌ Crear calificación → ERROR (y el promedio NO se actualiza)
- ❌ Crear contratación → ERROR (y el cupón NO se incrementa)
- ❌ Crear mensaje → ERROR (y la conversación NO se actualiza)
- ❌ Actualizar estado → ERROR (y NO se registra en historial)

---

## 🔧 Mantenimiento

### Ver un SP específico:
```sql
SHOW CREATE PROCEDURE sp_crear_contratacion;
```

### Actualizar un SP:
```sql
-- 1. Eliminar
DROP PROCEDURE IF EXISTS sp_crear_contratacion;

-- 2. Recrear con cambios
DELIMITER $$
CREATE PROCEDURE sp_crear_contratacion(...)
BEGIN
  -- Nueva lógica
END$$
DELIMITER ;
```

### Eliminar todos los SPs:
```bash
mysql -u root -p app_servicios << EOF
DROP PROCEDURE IF EXISTS sp_registrar_usuario;
DROP PROCEDURE IF EXISTS sp_crear_sucursal;
DROP PROCEDURE IF EXISTS sp_crear_calificacion;
DROP PROCEDURE IF EXISTS sp_establecer_direccion_principal;
DROP PROCEDURE IF EXISTS sp_asociar_servicio_sucursal;
DROP PROCEDURE IF EXISTS sp_actualizar_estado_contratacion;
DROP PROCEDURE IF EXISTS sp_crear_contratacion;
DROP PROCEDURE IF EXISTS sp_crear_mensaje;
EOF
```

---

## 🧪 Pruebas

### Probar SP manualmente:

```sql
-- Crear contratación de prueba
CALL sp_crear_contratacion(
  1,              -- id_cliente
  2,              -- id_servicio
  3,              -- id_sucursal
  4,              -- id_direccion_entrega
  NULL,           -- id_cupon (sin cupón)
  NOW(),          -- fecha_programada
  100.00,         -- precio_subtotal
  0.00,           -- descuento_aplicado
  100.00,         -- precio_total
  15.00,          -- porcentaje_comision (15%)
  'Nota test',    -- notas_cliente
  @id_contratacion,
  @mensaje
);

SELECT @id_contratacion, @mensaje;

-- Ver historial generado
SELECT * FROM historial_estado_contratacion
WHERE id_contratacion = @id_contratacion;

-- Ver comisiones calculadas
SELECT
  id_contratacion,
  precio_total,
  porcentaje_comision,
  comision_plataforma,  -- Debería ser 15.00
  ganancia_empresa      -- Debería ser 85.00
FROM contratacion
WHERE id_contratacion = @id_contratacion;
```

---

## 📈 Ventajas de Esta Implementación

### vs Triggers:
✅ Mejor debugging (logs en backend)
✅ Control explícito de ejecución
✅ Más fácil de testear
✅ No hay "magia" oculta
✅ Mejor rendimiento (menos overhead)

### vs Código Manual:
✅ Transacciones atómicas garantizadas
✅ Validaciones en BD (primera línea de defensa)
✅ Menos tráfico de red
✅ Procedures precompilados (más rápidos)
✅ Reutilizable desde otras aplicaciones

---

## 🐛 Troubleshooting

### Error: "PROCEDURE does not exist"
```bash
# Reinstalar SPs
mysql -u root -p app_servicios < backend/database/stored_procedures.sql
```

### Error: "Column 'porcentaje_comision' doesn't exist"
```bash
# Aplicar cambios del DER primero
mysql -u root -p app_servicios < BASEVERSIONFINAL3.sql
```

### Error: "Trigger already exists"
```bash
# Eliminar triggers obsoletos
mysql -u root -p app_servicios < backend/database/drop_triggers.sql
```

### Ver logs de MySQL:
```bash
# Linux/Mac
tail -f /var/log/mysql/error.log

# Windows
# Buscar en C:\ProgramData\MySQL\MySQL Server 8.0\Data\*.err
```

---

## 🎓 Recursos Adicionales

- [MySQL Stored Procedures](https://dev.mysql.com/doc/refman/8.0/en/stored-routines.html)
- [Generated Columns](https://dev.mysql.com/doc/refman/8.0/en/create-table-generated-columns.html)
- [Transacciones ACID](https://dev.mysql.com/doc/refman/8.0/en/mysql-acid.html)

---

## 📝 Changelog

**Versión 2.0** (Actual)
- ✅ Eliminada dependencia de triggers
- ✅ Soporte para historial de estados
- ✅ Soporte para comisiones calculadas
- ✅ SP para crear contrataciones
- ✅ SP para crear mensajes

**Versión 1.0** (Inicial)
- Implementación básica de 6 SPs
- Fallback automático (eliminado en v2.0)

---

**Autor**: Sistema de Stored Procedures v2.0
**Fecha**: 2025
**Licencia**: Proyecto Interno
