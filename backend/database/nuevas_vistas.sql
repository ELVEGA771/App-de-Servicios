-- ============================================================================
-- VISTAS NUEVAS - App de Servicios
-- ============================================================================
-- Fecha: 2025
-- Descripci�n: Vistas para reemplazar queries complejas en la aplicaci�n
--
-- IMPORTANTE: Estas vistas complementan las que ya existen:
--   - vista_servicios_completos
--   - vista_estadisticas_empresa
--   - vista_contrataciones_detalle
-- ============================================================================

USE app_servicios;

-- ============================================================================
-- VISTA 1: Favoritos con Detalles Completos
-- ============================================================================
-- Reemplaza: Favorito.js - getFavoritosPorCliente()
-- JOIN x4: servicio_favorito + servicio + empresa + categoria_servicio

DROP VIEW IF EXISTS vista_favoritos_detalle;

CREATE VIEW vista_favoritos_detalle AS
SELECT
    sf.id_cliente,
    sf.id_servicio,
    sf.fecha_agregado,
    sf.notas_cliente,
    -- Datos del servicio
    s.id_empresa,
    s.id_categoria,
    s.nombre as servicio_nombre,
    s.descripcion as servicio_descripcion,
    s.precio_base,
    s.duracion_estimada,
    s.imagen_url,
    s.estado as servicio_estado,
    s.fecha_creacion as servicio_fecha_creacion,
    -- Datos de la empresa
    e.razon_social as empresa_nombre,
    e.calificacion_promedio as empresa_calificacion,
    e.logo_url as empresa_logo,
    e.descripcion as empresa_descripcion,
    -- Datos de la categor�a
    c.nombre as categoria_nombre,
    c.icono_url as categoria_icono
FROM servicio_favorito sf
JOIN servicio s ON sf.id_servicio = s.id_servicio
JOIN empresa e ON s.id_empresa = e.id_empresa
JOIN categoria_servicio c ON s.id_categoria = c.id_categoria;


-- ============================================================================
-- VISTA 2: Conversaciones con Nombres y Mensajes No Le�dos (Cliente)
-- ============================================================================
-- Reemplaza: Conversacion.js - getConversacionesPorCliente()
-- JOIN x4 + SUBQUERY para contar mensajes no le�dos

DROP VIEW IF EXISTS vista_conversaciones_cliente;

CREATE VIEW vista_conversaciones_cliente AS
SELECT
    c.id_conversacion,
    c.id_cliente,
    c.id_empresa,
    c.id_contratacion,
    c.fecha_inicio,
    c.fecha_ultimo_mensaje,
    c.estado,
    -- Datos de la empresa
    e.razon_social as empresa_nombre,
    e.logo_url as empresa_foto,
    ue.id_usuario as empresa_id_usuario,
    ue.telefono as empresa_telefono,
    -- Datos del cliente
    cli.id_usuario as cliente_id_usuario,
    CONCAT(uc.nombre, ' ', uc.apellido) as cliente_nombre,
    uc.foto_perfil_url as cliente_foto
FROM conversacion c
JOIN cliente cli ON c.id_cliente = cli.id_cliente
JOIN usuario uc ON cli.id_usuario = uc.id_usuario
JOIN empresa e ON c.id_empresa = e.id_empresa
JOIN usuario ue ON e.id_usuario = ue.id_usuario;


-- ============================================================================
-- VISTA 3: Conversaciones con Nombres y Mensajes No Le�dos (Empresa)
-- ============================================================================
-- Reemplaza: Conversacion.js - getConversacionesPorEmpresa()

DROP VIEW IF EXISTS vista_conversaciones_empresa;

CREATE VIEW vista_conversaciones_empresa AS
SELECT
    c.id_conversacion,
    c.id_cliente,
    c.id_empresa,
    c.id_contratacion,
    c.fecha_inicio,
    c.fecha_ultimo_mensaje,
    c.estado,
    -- Datos del cliente
    CONCAT(uc.nombre, ' ', uc.apellido) as cliente_nombre,
    uc.foto_perfil_url as cliente_foto,
    cli.id_usuario as cliente_id_usuario,
    -- Datos de la empresa
    e.razon_social as empresa_nombre,
    e.id_usuario as empresa_id_usuario
FROM conversacion c
JOIN cliente cli ON c.id_cliente = cli.id_cliente
JOIN usuario uc ON cli.id_usuario = uc.id_usuario
JOIN empresa e ON c.id_empresa = e.id_empresa;


-- ============================================================================
-- VISTA 4: Mensajes con Detalles del Remitente
-- ============================================================================
-- Reemplaza: Conversacion.js - getMensajesPorConversacion()
-- JOIN x2: mensaje + usuario

DROP VIEW IF EXISTS vista_mensajes_detalle;

CREATE VIEW vista_mensajes_detalle AS
SELECT
    m.id_mensaje,
    m.id_conversacion,
    m.id_remitente,
    m.contenido,
    m.tipo_mensaje,
    m.archivo_url,
    m.fecha_envio,
    m.leido,
    m.fecha_lectura,
    -- Datos del remitente
    CONCAT(u.nombre, ' ', u.apellido) as remitente_nombre,
    u.foto_perfil_url as remitente_foto,
    u.email as remitente_email,
    u.tipo_usuario as remitente_tipo
FROM mensaje m
JOIN usuario u ON m.id_remitente = u.id_usuario;


-- ============================================================================
-- VISTA 5: Servicios de Sucursal con Detalles
-- ============================================================================
-- Reemplaza: Sucursal.js - getServiciosPorSucursal()
-- JOIN x3: servicio_sucursal + servicio + categoria_servicio

DROP VIEW IF EXISTS vista_servicios_sucursal;

CREATE VIEW vista_servicios_sucursal AS
SELECT
    ss.id_servicio,
    ss.id_sucursal,
    ss.disponible,
    ss.precio_sucursal,
    -- Datos del servicio
    s.id_empresa,
    s.id_categoria,
    s.nombre as servicio_nombre,
    s.descripcion as servicio_descripcion,
    s.precio_base,
    s.duracion_estimada,
    s.imagen_url,
    s.estado as servicio_estado,
    -- Datos de la categor�a
    c.nombre as categoria_nombre,
    c.descripcion as categoria_descripcion,
    c.icono_url as categoria_icono
FROM servicio_sucursal ss
JOIN servicio s ON ss.id_servicio = s.id_servicio
JOIN categoria_servicio c ON s.id_categoria = c.id_categoria;


-- ============================================================================
-- VISTA 6: Sucursales con Direcci�n Completa
-- ============================================================================
-- Reemplaza: Sucursal.js - getSucursalPorId(), getSucursalesPorEmpresa()
-- JOIN x2: sucursal + direccion

DROP VIEW IF EXISTS vista_sucursales_detalle;

CREATE VIEW vista_sucursales_detalle AS
SELECT
    s.id_sucursal,
    s.id_empresa,
    s.id_direccion,
    s.nombre_sucursal,
    s.telefono,
    s.horario_apertura,
    s.horario_cierre,
    s.dias_laborales,
    s.estado,
    -- Datos de la direcci�n
    d.calle_principal,
    d.calle_secundaria,
    d.numero,
    d.ciudad,
    d.provincia_estado,
    d.codigo_postal,
    d.pais,
    d.latitud,
    d.longitud,
    d.referencia
FROM sucursal s
JOIN direccion d ON s.id_direccion = d.id_direccion;


-- ============================================================================
-- VISTA 7: Calificaciones de Servicio con Cliente
-- ============================================================================
-- Reemplaza: Calificacion.js - getCalificacionesPorServicio()
-- JOIN x4: calificacion + contratacion + cliente + usuario

DROP VIEW IF EXISTS vista_calificaciones_servicio;

CREATE VIEW vista_calificaciones_servicio AS
SELECT
    cal.id_calificacion,
    cal.id_contratacion,
    cal.id_servicio,
    cal.calificacion,
    cal.comentario,
    cal.fecha_calificacion,
    -- Datos de la contrataci�n
    con.id_cliente,
    con.fecha_completada,
    -- Datos del cliente (quien califica)
    cli.id_usuario as cliente_id_usuario,
    CONCAT(u.nombre, ' ', u.apellido) as cliente_nombre,
    u.foto_perfil_url as cliente_foto,
    u.email as cliente_email
FROM calificacion cal
JOIN contratacion con ON cal.id_contratacion = con.id_contratacion
JOIN cliente cli ON con.id_cliente = cli.id_cliente
JOIN usuario u ON cli.id_usuario = u.id_usuario;


-- ============================================================================
-- VISTA 8: Calificaciones de Empresa con Servicio
-- ============================================================================
-- Reemplaza: Calificacion.js - getCalificacionesPorEmpresa()
-- JOIN x5: calificacion + contratacion + cliente + usuario + servicio

DROP VIEW IF EXISTS vista_calificaciones_empresa;

CREATE VIEW vista_calificaciones_empresa AS
SELECT
    cal.id_calificacion,
    cal.id_contratacion,
    cal.id_servicio,
    cal.calificacion,
    cal.comentario,
    cal.fecha_calificacion,
    -- Datos de la contrataci�n
    con.id_cliente,
    con.id_sucursal,
    con.fecha_completada,
    -- Datos del cliente
    cli.id_usuario as cliente_id_usuario,
    CONCAT(u.nombre, ' ', u.apellido) as cliente_nombre,
    u.foto_perfil_url as cliente_foto,
    -- Datos del servicio
    s.id_empresa,
    s.nombre as servicio_nombre,
    s.imagen_url as servicio_imagen
FROM calificacion cal
JOIN contratacion con ON cal.id_contratacion = con.id_contratacion
JOIN cliente cli ON con.id_cliente = cli.id_cliente
JOIN usuario u ON cli.id_usuario = u.id_usuario
JOIN servicio s ON con.id_servicio = s.id_servicio;


-- ============================================================================
-- VISTA 9: Calificaciones Pendientes de Usuario
-- ============================================================================
-- Reemplaza: Calificacion.js - getCalificacionesPendientes()
-- LEFT JOIN para encontrar contrataciones sin calificaci�n

DROP VIEW IF EXISTS vista_calificaciones_pendientes;

CREATE VIEW vista_calificaciones_pendientes AS
SELECT
    c.id_contratacion,
    c.id_cliente,
    c.id_servicio,
    c.fecha_completada,
    -- Datos del cliente
    cli.id_usuario as cliente_id_usuario,
    -- Datos del servicio
    s.nombre as servicio_nombre,
    s.imagen_url as imagen_principal,
    -- Datos de la empresa
    e.id_empresa,
    e.razon_social as empresa_nombre,
    e.logo_url as empresa_logo
FROM contratacion c
JOIN cliente cli ON c.id_cliente = cli.id_cliente
JOIN servicio s ON c.id_servicio = s.id_servicio
JOIN empresa e ON s.id_empresa = e.id_empresa
WHERE c.estado = 'completado'
AND NOT EXISTS (
    SELECT 1 
    FROM calificacion cal 
    WHERE cal.id_contratacion = c.id_contratacion
);


-- ============================================================================
-- VISTA 10: Clientes con Usuario
-- ============================================================================
-- Reemplaza: Cliente.js - getTodosLosClientes(), getClientePorId()
-- JOIN x2: cliente + usuario

DROP VIEW IF EXISTS vista_clientes_detalle;

CREATE VIEW vista_clientes_detalle AS
SELECT
    c.id_cliente,
    c.id_usuario,
    c.calificacion_promedio,
    -- Datos del usuario
    u.email,
    u.nombre,
    u.apellido,
    u.telefono,
    u.foto_perfil_url,
    u.estado,
    u.fecha_registro,
    u.tipo_usuario
FROM cliente c
JOIN usuario u ON c.id_usuario = u.id_usuario;


-- ============================================================================
-- VISTA 11: Empresas con Usuario
-- ============================================================================
-- Reemplaza: Empresa.js - getEmpresaPorId(), getEmpresaPorIdUsuario()
-- JOIN x2: empresa + usuario

DROP VIEW IF EXISTS vista_empresas_detalle;

CREATE VIEW vista_empresas_detalle AS
SELECT
    e.id_empresa,
    e.id_usuario,
    e.razon_social,
    e.ruc_nit,
    e.descripcion,
    e.logo_url,
    e.calificacion_promedio,
    e.fecha_verificacion,
    e.pais,
    -- Datos del usuario
    u.email,
    u.nombre,
    u.apellido,
    u.telefono,
    u.foto_perfil_url,
    u.estado,
    u.fecha_registro,
    u.tipo_usuario
FROM empresa e
JOIN usuario u ON e.id_usuario = u.id_usuario;


-- ============================================================================
-- VISTA 12: Direcciones del Cliente
-- ============================================================================
-- Reemplaza: Cliente.js - getDireccionesPorCliente()
-- JOIN x2: direcciones_del_cliente + direccion

DROP VIEW IF EXISTS vista_direcciones_cliente;

CREATE VIEW vista_direcciones_cliente AS
SELECT
    dc.id_cliente,
    dc.id_direccion,
    dc.alias,
    dc.es_principal,
    -- Datos de la direcci�n
    d.calle_principal,
    d.calle_secundaria,
    d.numero,
    d.ciudad,
    d.provincia_estado,
    d.codigo_postal,
    d.pais,
    d.latitud,
    d.longitud,
    d.referencia
FROM direcciones_del_cliente dc
JOIN direccion d ON dc.id_direccion = d.id_direccion;


-- ============================================================================
-- VISTA 13: Historial de Estados de Contrataci�n con Detalles
-- ============================================================================
-- Reemplaza: Contratacion.js - getHistorialEstados()
-- JOIN x4: historial + contratacion + servicio + usuario

DROP VIEW IF EXISTS vista_historial_estados;

CREATE VIEW vista_historial_estados AS
SELECT
    h.id_historial,
    h.id_contratacion,
    h.estado_anterior,
    h.estado_nuevo,
    h.fecha_cambio,
    h.notas,
    h.id_usuario_responsable,
    -- Datos de la contrataci�n
    c.id_cliente,
    c.id_servicio,
    c.id_sucursal,
    -- Datos del servicio
    s.id_empresa,
    s.nombre as servicio_nombre,
    -- Datos del usuario responsable
    u.nombre as usuario_nombre,
    u.apellido as usuario_apellido,
    CONCAT(u.nombre, ' ', u.apellido) as usuario_nombre_completo
FROM historial_estado_contratacion h
JOIN contratacion c ON h.id_contratacion = c.id_contratacion
JOIN servicio s ON c.id_servicio = s.id_servicio
LEFT JOIN usuario u ON h.id_usuario_responsable = u.id_usuario;


-- ============================================================================
-- VISTA 14: Cupones Activos Disponibles con Empresa
-- ============================================================================
-- Reemplaza: Cupon.js - getCuponesActivos()
-- JOIN x2: cupon + empresa

DROP VIEW IF EXISTS vista_cupones_activos;

CREATE VIEW vista_cupones_activos AS
SELECT
    c.id_cupon,
    c.id_empresa,
    c.codigo,
    c.descripcion,
    c.tipo_descuento,
    c.valor_descuento,
    c.monto_minimo_compra,
    c.cantidad_disponible,
    c.cantidad_usada,
    c.fecha_inicio,
    c.fecha_expiracion,
    c.activo,
    c.aplicable_a,
    -- Datos de la empresa
    e.razon_social as empresa_nombre,
    e.logo_url as empresa_logo,
    e.calificacion_promedio as empresa_calificacion
FROM cupon c
JOIN empresa e ON c.id_empresa = e.id_empresa
WHERE c.activo = 1
  AND (c.fecha_expiracion IS NULL OR c.fecha_expiracion > NOW())
  AND (c.cantidad_disponible IS NULL OR c.cantidad_usada < c.cantidad_disponible);


-- ============================================================================
-- VISTA 15: Servicio con Sucursales Disponibles
-- ============================================================================
-- Reemplaza: Servicio.js - getSucursalesPorServicio()
-- JOIN x3: servicio_sucursal + sucursal + direccion

DROP VIEW IF EXISTS vista_servicio_sucursales;

CREATE VIEW vista_servicio_sucursales AS
SELECT
    ss.id_servicio,
    ss.id_sucursal,
    ss.disponible,
    ss.precio_sucursal,
    -- Datos de la sucursal
    s.id_empresa,
    s.nombre_sucursal,
    s.telefono,
    s.horario_apertura,
    s.horario_cierre,
    s.dias_laborales,
    s.estado as sucursal_estado,
    -- Datos de la direcci�n
    d.id_direccion,
    d.calle_principal,
    d.calle_secundaria,
    d.numero,
    d.ciudad,
    d.provincia_estado,
    d.codigo_postal,
    d.pais,
    d.latitud,
    d.longitud,
    d.referencia
FROM servicio_sucursal ss
JOIN sucursal s ON ss.id_sucursal = s.id_sucursal
JOIN direccion d ON s.id_direccion = d.id_direccion;


-- ============================================================================
-- FIN DE VISTAS
-- ============================================================================
--
-- Total: 15 vistas nuevas creadas
--
-- Para aplicar:
-- mysql -u root -p app_servicios < backend/database/nuevas_vistas.sql
--
-- Para verificar:
-- SHOW FULL TABLES WHERE Table_type = 'VIEW';
--
-- ============================================================================
