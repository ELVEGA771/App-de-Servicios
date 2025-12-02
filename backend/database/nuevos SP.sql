-- ============================================================================
-- STORED PROCEDURES NUEVOS - App de Servicios
-- ============================================================================
-- Fecha: 2025
-- Descripción: Stored procedures para operaciones CRUD de la aplicación
--
-- IMPORTANTE: Estos SPs complementan los que ya existen en stored_procedures.sql
-- ============================================================================

USE app_servicios;

DELIMITER $$

-- ============================================================================
-- SP: USUARIO - Actualizar Perfil
-- ============================================================================
DROP PROCEDURE IF EXISTS sp_actualizar_usuario$$

CREATE PROCEDURE sp_actualizar_usuario(
    IN p_id_usuario INT,
    IN p_nombre VARCHAR(100),
    IN p_apellido VARCHAR(100),
    IN p_telefono VARCHAR(20),
    IN p_foto_perfil_url VARCHAR(500),
    IN p_estado ENUM('activo', 'inactivo', 'suspendido'),
    OUT p_out_mensaje VARCHAR(255)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET p_out_mensaje = 'Error al actualizar usuario';
        ROLLBACK;
    END;

    START TRANSACTION;

    -- Verificar que el usuario exista
    IF NOT EXISTS (SELECT 1 FROM usuario WHERE id_usuario = p_id_usuario) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'El usuario no existe';
    END IF;

    -- Actualizar usuario
    UPDATE usuario
    SET nombre = IFNULL(p_nombre, nombre),
        apellido = IFNULL(p_apellido, apellido),
        telefono = IFNULL(p_telefono, telefono),
        foto_perfil_url = IFNULL(p_foto_perfil_url, foto_perfil_url),
        estado = IFNULL(p_estado, estado)
    WHERE id_usuario = p_id_usuario;

    SET p_out_mensaje = 'Usuario actualizado exitosamente';
    COMMIT;
END$$


-- ============================================================================
-- SP: USUARIO - Actualizar Contraseña
-- ============================================================================
DROP PROCEDURE IF EXISTS sp_actualizar_password$$

CREATE PROCEDURE sp_actualizar_password(
    IN p_id_usuario INT,
    IN p_password_hash VARCHAR(255),
    OUT p_out_mensaje VARCHAR(255)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET p_out_mensaje = 'Error al actualizar contraseña';
        ROLLBACK;
    END;

    START TRANSACTION;

    -- Verificar que el usuario exista
    IF NOT EXISTS (SELECT 1 FROM usuario WHERE id_usuario = p_id_usuario) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'El usuario no existe';
    END IF;

    -- Actualizar contraseña
    UPDATE usuario
    SET password_hash = p_password_hash
    WHERE id_usuario = p_id_usuario;

    SET p_out_mensaje = 'Contraseña actualizada exitosamente';
    COMMIT;
END$$


-- ============================================================================
-- SP: USUARIO - Eliminar Usuario
-- ============================================================================
DROP PROCEDURE IF EXISTS sp_eliminar_usuario$$

CREATE PROCEDURE sp_eliminar_usuario(
    IN p_id_usuario INT,
    OUT p_out_mensaje VARCHAR(255)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET p_out_mensaje = 'Error al eliminar usuario';
        ROLLBACK;
    END;

    START TRANSACTION;

    -- Verificar que el usuario exista
    IF NOT EXISTS (SELECT 1 FROM usuario WHERE id_usuario = p_id_usuario) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'El usuario no existe';
    END IF;

    -- Eliminar usuario (cascade eliminará cliente/empresa asociados)
    DELETE FROM usuario WHERE id_usuario = p_id_usuario;

    SET p_out_mensaje = 'Usuario eliminado exitosamente';
    COMMIT;
END$$


-- ============================================================================
-- SP: CATEGORIA - Crear Categoría
-- ============================================================================
DROP PROCEDURE IF EXISTS sp_crear_categoria$$

CREATE PROCEDURE sp_crear_categoria(
    IN p_nombre VARCHAR(100),
    IN p_descripcion TEXT,
    IN p_icono_url VARCHAR(500),
    OUT p_out_id_categoria INT,
    OUT p_out_mensaje VARCHAR(255)
)
BEGIN
    DECLARE v_count INT DEFAULT 0;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET p_out_id_categoria = NULL;
        SET p_out_mensaje = 'Error al crear categoría';
        ROLLBACK;
    END;

    START TRANSACTION;

    -- Verificar si la categoría ya existe
    SELECT COUNT(*) INTO v_count FROM categoria_servicio WHERE nombre = p_nombre;
    IF v_count > 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Ya existe una categoría con ese nombre';
    END IF;

    -- Crear categoría
    INSERT INTO categoria_servicio (nombre, descripcion, icono_url)
    VALUES (p_nombre, p_descripcion, p_icono_url);

    SET p_out_id_categoria = LAST_INSERT_ID();
    SET p_out_mensaje = 'Categoría creada exitosamente';
    COMMIT;
END$$


-- ============================================================================
-- SP: CATEGORIA - Actualizar Categoría
-- ============================================================================
DROP PROCEDURE IF EXISTS sp_actualizar_categoria$$

CREATE PROCEDURE sp_actualizar_categoria(
    IN p_id_categoria INT,
    IN p_nombre VARCHAR(100),
    IN p_descripcion TEXT,
    IN p_icono_url VARCHAR(500),
    OUT p_out_mensaje VARCHAR(255)
)
BEGIN
    DECLARE v_count INT DEFAULT 0;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET p_out_mensaje = 'Error al actualizar categoría';
        ROLLBACK;
    END;

    START TRANSACTION;

    -- Verificar que la categoría exista
    IF NOT EXISTS (SELECT 1 FROM categoria_servicio WHERE id_categoria = p_id_categoria) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'La categoría no existe';
    END IF;

    -- Verificar si el nuevo nombre ya existe en otra categoría
    SELECT COUNT(*) INTO v_count
    FROM categoria_servicio
    WHERE nombre = p_nombre AND id_categoria != p_id_categoria;

    IF v_count > 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Ya existe otra categoría con ese nombre';
    END IF;

    -- Actualizar categoría
    UPDATE categoria_servicio
    SET nombre = p_nombre,
        descripcion = p_descripcion,
        icono_url = p_icono_url
    WHERE id_categoria = p_id_categoria;

    SET p_out_mensaje = 'Categoría actualizada exitosamente';
    COMMIT;
END$$


-- ============================================================================
-- SP: FAVORITO - Agregar/Actualizar Favorito
-- ============================================================================
DROP PROCEDURE IF EXISTS sp_agregar_favorito$$

CREATE PROCEDURE sp_agregar_favorito(
    IN p_id_servicio INT,
    IN p_id_cliente INT,
    IN p_notas_cliente TEXT,
    OUT p_out_mensaje VARCHAR(255)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET p_out_mensaje = 'Error al agregar favorito';
        ROLLBACK;
    END;

    START TRANSACTION;

    -- Verificar que el servicio exista
    IF NOT EXISTS (SELECT 1 FROM servicio WHERE id_servicio = p_id_servicio) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'El servicio no existe';
    END IF;

    -- Verificar que el cliente exista
    IF NOT EXISTS (SELECT 1 FROM cliente WHERE id_cliente = p_id_cliente) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'El cliente no existe';
    END IF;

    -- Agregar o actualizar favorito
    INSERT INTO servicio_favorito (id_servicio, id_cliente, fecha_agregado, notas_cliente)
    VALUES (p_id_servicio, p_id_cliente, NOW(), p_notas_cliente)
    ON DUPLICATE KEY UPDATE
        notas_cliente = p_notas_cliente,
        fecha_agregado = NOW();

    SET p_out_mensaje = 'Favorito agregado exitosamente';
    COMMIT;
END$$


-- ============================================================================
-- SP: FAVORITO - Eliminar Favorito
-- ============================================================================
DROP PROCEDURE IF EXISTS sp_eliminar_favorito$$

CREATE PROCEDURE sp_eliminar_favorito(
    IN p_id_cliente INT,
    IN p_id_servicio INT,
    OUT p_out_mensaje VARCHAR(255)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET p_out_mensaje = 'Error al eliminar favorito';
        ROLLBACK;
    END;

    START TRANSACTION;

    -- Eliminar favorito
    DELETE FROM servicio_favorito
    WHERE id_cliente = p_id_cliente AND id_servicio = p_id_servicio;

    IF ROW_COUNT() = 0 THEN
        SET p_out_mensaje = 'El favorito no existe';
    ELSE
        SET p_out_mensaje = 'Favorito eliminado exitosamente';
    END IF;

    COMMIT;
END$$


-- ============================================================================
-- SP: EMPRESA - Actualizar Empresa
-- ============================================================================
DROP PROCEDURE IF EXISTS sp_actualizar_empresa$$

CREATE PROCEDURE sp_actualizar_empresa(
    IN p_id_empresa INT,
    IN p_razon_social VARCHAR(255),
    IN p_ruc_nit VARCHAR(50),
    IN p_descripcion TEXT,
    IN p_logo_url VARCHAR(500),
    OUT p_out_mensaje VARCHAR(255)
)
BEGIN
    DECLARE v_count INT DEFAULT 0;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET p_out_mensaje = 'Error al actualizar empresa';
        ROLLBACK;
    END;

    START TRANSACTION;

    -- Verificar que la empresa exista
    IF NOT EXISTS (SELECT 1 FROM empresa WHERE id_empresa = p_id_empresa) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'La empresa no existe';
    END IF;

    -- Verificar si el RUC ya existe en otra empresa
    IF p_ruc_nit IS NOT NULL THEN
        SELECT COUNT(*) INTO v_count
        FROM empresa
        WHERE ruc_nit = p_ruc_nit AND id_empresa != p_id_empresa;

        IF v_count > 0 THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'Ya existe otra empresa con ese RUC/NIT';
        END IF;
    END IF;

    -- Actualizar empresa
    UPDATE empresa
    SET razon_social = IFNULL(p_razon_social, razon_social),
        ruc_nit = IFNULL(p_ruc_nit, ruc_nit),
        descripcion = IFNULL(p_descripcion, descripcion),
        logo_url = IFNULL(p_logo_url, logo_url)
    WHERE id_empresa = p_id_empresa;

    SET p_out_mensaje = 'Empresa actualizada exitosamente';
    COMMIT;
END$$


-- ============================================================================
-- SP: CONVERSACION - Crear Conversación
-- ============================================================================
DROP PROCEDURE IF EXISTS sp_crear_conversacion$$

CREATE PROCEDURE sp_crear_conversacion(
    IN p_id_cliente INT,
    IN p_id_empresa INT,
    IN p_id_contratacion INT,
    OUT p_out_id_conversacion INT,
    OUT p_out_mensaje VARCHAR(255)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET p_out_id_conversacion = NULL;
        SET p_out_mensaje = 'Error al crear conversación';
        ROLLBACK;
    END;

    START TRANSACTION;

    -- Verificar que el cliente exista
    IF NOT EXISTS (SELECT 1 FROM cliente WHERE id_cliente = p_id_cliente) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'El cliente no existe';
    END IF;

    -- Verificar que la empresa exista
    IF NOT EXISTS (SELECT 1 FROM empresa WHERE id_empresa = p_id_empresa) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'La empresa no existe';
    END IF;

    -- Crear conversación
    INSERT INTO conversacion (id_cliente, id_empresa, id_contratacion, estado)
    VALUES (p_id_cliente, p_id_empresa, p_id_contratacion, 'abierta');

    SET p_out_id_conversacion = LAST_INSERT_ID();
    SET p_out_mensaje = 'Conversación creada exitosamente';
    COMMIT;
END$$


-- ============================================================================
-- SP: CONVERSACION - Actualizar Estado
-- ============================================================================
DROP PROCEDURE IF EXISTS sp_actualizar_estado_conversacion$$

CREATE PROCEDURE sp_actualizar_estado_conversacion(
    IN p_id_conversacion INT,
    IN p_estado ENUM('abierta', 'cerrada', 'archivada'),
    OUT p_out_mensaje VARCHAR(255)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET p_out_mensaje = 'Error al actualizar estado de conversación';
        ROLLBACK;
    END;

    START TRANSACTION;

    -- Verificar que la conversación exista
    IF NOT EXISTS (SELECT 1 FROM conversacion WHERE id_conversacion = p_id_conversacion) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'La conversación no existe';
    END IF;

    -- Actualizar estado
    UPDATE conversacion
    SET estado = p_estado
    WHERE id_conversacion = p_id_conversacion;

    SET p_out_mensaje = 'Estado de conversación actualizado exitosamente';
    COMMIT;
END$$


-- ============================================================================
-- SP: CONVERSACION - Marcar Mensajes como Leídos
-- ============================================================================
DROP PROCEDURE IF EXISTS sp_marcar_mensajes_leidos$$

CREATE PROCEDURE sp_marcar_mensajes_leidos(
    IN p_id_conversacion INT,
    IN p_id_remitente INT,
    OUT p_out_mensaje VARCHAR(255)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET p_out_mensaje = 'Error al marcar mensajes como leídos';
        ROLLBACK;
    END;

    START TRANSACTION;

    -- Marcar mensajes como leídos
    UPDATE mensaje
    SET leido = 1,
        fecha_lectura = NOW()
    WHERE id_conversacion = p_id_conversacion
      AND id_remitente != p_id_remitente
      AND leido = 0;

    SET p_out_mensaje = CONCAT(ROW_COUNT(), ' mensajes marcados como leídos');
    COMMIT;
END$$


-- ============================================================================
-- SP: SERVICIO - Crear Servicio
-- ============================================================================
DROP PROCEDURE IF EXISTS sp_crear_servicio$$

CREATE PROCEDURE sp_crear_servicio(
    IN p_id_empresa INT,
    IN p_id_categoria INT,
    IN p_nombre VARCHAR(255),
    IN p_descripcion TEXT,
    IN p_precio_base DECIMAL(10,2),
    IN p_duracion_estimada INT,
    IN p_imagen_url VARCHAR(500),
    IN p_estado ENUM('activo', 'inactivo'),
    OUT p_out_id_servicio INT,
    OUT p_out_mensaje VARCHAR(255)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET p_out_id_servicio = NULL;
        SET p_out_mensaje = 'Error al crear servicio';
        ROLLBACK;
    END;

    START TRANSACTION;

    -- Verificar que la empresa exista
    IF NOT EXISTS (SELECT 1 FROM empresa WHERE id_empresa = p_id_empresa) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'La empresa no existe';
    END IF;

    -- Verificar que la categoría exista
    IF NOT EXISTS (SELECT 1 FROM categoria_servicio WHERE id_categoria = p_id_categoria) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'La categoría no existe';
    END IF;

    -- Crear servicio
    INSERT INTO servicio (
        id_empresa, id_categoria, nombre, descripcion, precio_base,
        duracion_estimada, imagen_url, estado
    )
    VALUES (
        p_id_empresa, p_id_categoria, p_nombre, p_descripcion, p_precio_base,
        p_duracion_estimada, p_imagen_url, IFNULL(p_estado, 'activo')
    );

    SET p_out_id_servicio = LAST_INSERT_ID();
    SET p_out_mensaje = 'Servicio creado exitosamente';
    COMMIT;
END$$


-- ============================================================================
-- SP: SERVICIO - Actualizar Servicio
-- ============================================================================
DROP PROCEDURE IF EXISTS sp_actualizar_servicio$$

CREATE PROCEDURE sp_actualizar_servicio(
    IN p_id_servicio INT,
    IN p_nombre VARCHAR(255),
    IN p_descripcion TEXT,
    IN p_precio_base DECIMAL(10,2),
    IN p_duracion_estimada INT,
    IN p_imagen_url VARCHAR(500),
    IN p_estado ENUM('activo', 'inactivo'),
    IN p_id_categoria INT,
    OUT p_out_mensaje VARCHAR(255)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET p_out_mensaje = 'Error al actualizar servicio';
        ROLLBACK;
    END;

    START TRANSACTION;

    -- Verificar que el servicio exista
    IF NOT EXISTS (SELECT 1 FROM servicio WHERE id_servicio = p_id_servicio) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'El servicio no existe';
    END IF;

    -- Verificar que la categoría exista si se proporciona
    IF p_id_categoria IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM categoria_servicio WHERE id_categoria = p_id_categoria) THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'La categoría no existe';
        END IF;
    END IF;

    -- Actualizar servicio
    UPDATE servicio
    SET nombre = IFNULL(p_nombre, nombre),
        descripcion = IFNULL(p_descripcion, descripcion),
        precio_base = IFNULL(p_precio_base, precio_base),
        duracion_estimada = IFNULL(p_duracion_estimada, duracion_estimada),
        imagen_url = IFNULL(p_imagen_url, imagen_url),
        estado = IFNULL(p_estado, estado),
        id_categoria = IFNULL(p_id_categoria, id_categoria)
    WHERE id_servicio = p_id_servicio;

    SET p_out_mensaje = 'Servicio actualizado exitosamente';
    COMMIT;
END$$


-- ============================================================================
-- SP: SERVICIO - Eliminar Servicio
-- ============================================================================
DROP PROCEDURE IF EXISTS sp_eliminar_servicio$$

CREATE PROCEDURE sp_eliminar_servicio(
    IN p_id_servicio INT,
    OUT p_out_mensaje VARCHAR(255)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET p_out_mensaje = 'Error al eliminar servicio';
        ROLLBACK;
    END;

    START TRANSACTION;

    -- Verificar que el servicio exista
    IF NOT EXISTS (SELECT 1 FROM servicio WHERE id_servicio = p_id_servicio) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'El servicio no existe';
    END IF;

    -- Eliminar asociaciones con sucursales
    DELETE FROM servicio_sucursal WHERE id_servicio = p_id_servicio;

    -- Eliminar servicio
    DELETE FROM servicio WHERE id_servicio = p_id_servicio;

    SET p_out_mensaje = 'Servicio eliminado exitosamente';
    COMMIT;
END$$


-- ============================================================================
-- SP: SERVICIO - Actualizar Disponibilidad en Sucursal
-- ============================================================================
DROP PROCEDURE IF EXISTS sp_actualizar_disponibilidad_servicio$$

CREATE PROCEDURE sp_actualizar_disponibilidad_servicio(
    IN p_id_servicio INT,
    IN p_id_sucursal INT,
    IN p_disponible TINYINT,
    OUT p_out_mensaje VARCHAR(255)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET p_out_mensaje = 'Error al actualizar disponibilidad';
        ROLLBACK;
    END;

    START TRANSACTION;

    -- Verificar que la relación exista
    IF NOT EXISTS (
        SELECT 1 FROM servicio_sucursal
        WHERE id_servicio = p_id_servicio AND id_sucursal = p_id_sucursal
    ) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'La relación servicio-sucursal no existe';
    END IF;

    -- Actualizar disponibilidad
    UPDATE servicio_sucursal
    SET disponible = p_disponible
    WHERE id_servicio = p_id_servicio AND id_sucursal = p_id_sucursal;

    SET p_out_mensaje = 'Disponibilidad actualizada exitosamente';
    COMMIT;
END$$


-- ============================================================================
-- SP: SERVICIO - Eliminar de Sucursal
-- ============================================================================
DROP PROCEDURE IF EXISTS sp_eliminar_servicio_sucursal$$

CREATE PROCEDURE sp_eliminar_servicio_sucursal(
    IN p_id_servicio INT,
    IN p_id_sucursal INT,
    OUT p_out_mensaje VARCHAR(255)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET p_out_mensaje = 'Error al eliminar servicio de sucursal';
        ROLLBACK;
    END;

    START TRANSACTION;

    -- Eliminar relación
    DELETE FROM servicio_sucursal
    WHERE id_servicio = p_id_servicio AND id_sucursal = p_id_sucursal;

    IF ROW_COUNT() = 0 THEN
        SET p_out_mensaje = 'La relación no existe';
    ELSE
        SET p_out_mensaje = 'Servicio eliminado de sucursal exitosamente';
    END IF;

    COMMIT;
END$$


-- ============================================================================
-- SP: SUCURSAL - Actualizar Sucursal con Dirección
-- ============================================================================
DROP PROCEDURE IF EXISTS sp_actualizar_sucursal$$

CREATE PROCEDURE sp_actualizar_sucursal(
    IN p_id_sucursal INT,
    -- Datos de la sucursal
    IN p_nombre_sucursal VARCHAR(255),
    IN p_telefono VARCHAR(20),
    IN p_horario_apertura TIME,
    IN p_horario_cierre TIME,
    IN p_dias_laborales VARCHAR(7),
    IN p_estado ENUM('activa', 'inactiva'),
    -- Datos de la dirección
    IN p_calle_principal VARCHAR(255),
    IN p_calle_secundaria VARCHAR(255),
    IN p_numero VARCHAR(20),
    IN p_ciudad VARCHAR(100),
    IN p_provincia_estado VARCHAR(100),
    IN p_codigo_postal VARCHAR(20),
    IN p_pais VARCHAR(100),
    IN p_latitud DECIMAL(10,8),
    IN p_longitud DECIMAL(11,8),
    IN p_referencia TEXT,
    OUT p_out_mensaje VARCHAR(255)
)
BEGIN
    DECLARE v_id_direccion INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET p_out_mensaje = 'Error al actualizar sucursal';
        ROLLBACK;
    END;

    START TRANSACTION;

    -- Verificar que la sucursal exista y obtener su dirección
    SELECT id_direccion INTO v_id_direccion
    FROM sucursal
    WHERE id_sucursal = p_id_sucursal;

    IF v_id_direccion IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'La sucursal no existe';
    END IF;

    -- Actualizar sucursal
    UPDATE sucursal
    SET nombre_sucursal = IFNULL(p_nombre_sucursal, nombre_sucursal),
        telefono = IFNULL(p_telefono, telefono),
        horario_apertura = IFNULL(p_horario_apertura, horario_apertura),
        horario_cierre = IFNULL(p_horario_cierre, horario_cierre),
        dias_laborales = IFNULL(p_dias_laborales, dias_laborales),
        estado = IFNULL(p_estado, estado)
    WHERE id_sucursal = p_id_sucursal;

    -- Actualizar dirección
    UPDATE direccion
    SET calle_principal = IFNULL(p_calle_principal, calle_principal),
        calle_secundaria = IFNULL(p_calle_secundaria, calle_secundaria),
        numero = IFNULL(p_numero, numero),
        ciudad = IFNULL(p_ciudad, ciudad),
        provincia_estado = IFNULL(p_provincia_estado, provincia_estado),
        codigo_postal = IFNULL(p_codigo_postal, codigo_postal),
        pais = IFNULL(p_pais, pais),
        latitud = IFNULL(p_latitud, latitud),
        longitud = IFNULL(p_longitud, longitud),
        referencia = IFNULL(p_referencia, referencia)
    WHERE id_direccion = v_id_direccion;

    SET p_out_mensaje = 'Sucursal actualizada exitosamente';
    COMMIT;
END$$


-- ============================================================================
-- SP: SUCURSAL - Cambiar Estado
-- ============================================================================
DROP PROCEDURE IF EXISTS sp_cambiar_estado_sucursal$$

CREATE PROCEDURE sp_cambiar_estado_sucursal(
    IN p_id_sucursal INT,
    IN p_estado ENUM('activa', 'inactiva'),
    OUT p_out_mensaje VARCHAR(255)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET p_out_mensaje = 'Error al cambiar estado de sucursal';
        ROLLBACK;
    END;

    START TRANSACTION;

    -- Verificar que la sucursal exista
    IF NOT EXISTS (SELECT 1 FROM sucursal WHERE id_sucursal = p_id_sucursal) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'La sucursal no existe';
    END IF;

    -- Cambiar estado
    UPDATE sucursal
    SET estado = p_estado
    WHERE id_sucursal = p_id_sucursal;

    SET p_out_mensaje = CONCAT('Sucursal ', IF(p_estado = 'activa', 'activada', 'desactivada'), ' exitosamente');
    COMMIT;
END$$


-- ============================================================================
-- SP: NOTIFICACION - Crear Notificación
-- ============================================================================
DROP PROCEDURE IF EXISTS sp_crear_notificacion$$

CREATE PROCEDURE sp_crear_notificacion(
    IN p_id_usuario INT,
    IN p_titulo VARCHAR(255),
    IN p_contenido TEXT,
    IN p_tipo ENUM('nuevo_mensaje', 'cambio_estado', 'nuevo_cupon', 'calificacion', 'pago', 'sistema'),
    IN p_referencia_id INT,
    IN p_referencia_tipo VARCHAR(50),
    OUT p_out_id_notificacion INT,
    OUT p_out_mensaje VARCHAR(255)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET p_out_id_notificacion = NULL;
        SET p_out_mensaje = 'Error al crear notificación';
        ROLLBACK;
    END;

    START TRANSACTION;

    -- Verificar que el usuario exista
    IF NOT EXISTS (SELECT 1 FROM usuario WHERE id_usuario = p_id_usuario) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'El usuario no existe';
    END IF;

    -- Crear notificación
    INSERT INTO notificacion (
        id_usuario, titulo, contenido, tipo, referencia_id, referencia_tipo
    )
    VALUES (
        p_id_usuario, p_titulo, p_contenido, p_tipo, p_referencia_id, p_referencia_tipo
    );

    SET p_out_id_notificacion = LAST_INSERT_ID();
    SET p_out_mensaje = 'Notificación creada exitosamente';
    COMMIT;
END$$


-- ============================================================================
-- SP: NOTIFICACION - Marcar como Leída
-- ============================================================================
DROP PROCEDURE IF EXISTS sp_marcar_notificacion_leida$$

CREATE PROCEDURE sp_marcar_notificacion_leida(
    IN p_id_notificacion INT,
    OUT p_out_mensaje VARCHAR(255)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET p_out_mensaje = 'Error al marcar notificación como leída';
        ROLLBACK;
    END;

    START TRANSACTION;

    -- Verificar que la notificación exista
    IF NOT EXISTS (SELECT 1 FROM notificacion WHERE id_notificacion = p_id_notificacion) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'La notificación no existe';
    END IF;

    -- Marcar como leída
    UPDATE notificacion
    SET leida = 1,
        fecha_lectura = NOW()
    WHERE id_notificacion = p_id_notificacion;

    SET p_out_mensaje = 'Notificación marcada como leída';
    COMMIT;
END$$


-- ============================================================================
-- SP: NOTIFICACION - Marcar Todas como Leídas
-- ============================================================================
DROP PROCEDURE IF EXISTS sp_marcar_todas_notificaciones_leidas$$

CREATE PROCEDURE sp_marcar_todas_notificaciones_leidas(
    IN p_id_usuario INT,
    OUT p_out_mensaje VARCHAR(255)
)
BEGIN
    DECLARE v_count INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET p_out_mensaje = 'Error al marcar notificaciones como leídas';
        ROLLBACK;
    END;

    START TRANSACTION;

    -- Marcar todas las notificaciones no leídas del usuario como leídas
    UPDATE notificacion
    SET leida = 1,
        fecha_lectura = NOW()
    WHERE id_usuario = p_id_usuario AND leida = 0;

    SET v_count = ROW_COUNT();
    SET p_out_mensaje = CONCAT(v_count, ' notificaciones marcadas como leídas');
    COMMIT;
END$$


-- ============================================================================
-- SP: NOTIFICACION - Eliminar Notificación
-- ============================================================================
DROP PROCEDURE IF EXISTS sp_eliminar_notificacion$$

CREATE PROCEDURE sp_eliminar_notificacion(
    IN p_id_notificacion INT,
    OUT p_out_mensaje VARCHAR(255)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET p_out_mensaje = 'Error al eliminar notificación';
        ROLLBACK;
    END;

    START TRANSACTION;

    -- Eliminar notificación
    DELETE FROM notificacion WHERE id_notificacion = p_id_notificacion;

    IF ROW_COUNT() = 0 THEN
        SET p_out_mensaje = 'La notificación no existe';
    ELSE
        SET p_out_mensaje = 'Notificación eliminada exitosamente';
    END IF;

    COMMIT;
END$$


-- ============================================================================
-- SP: CLIENTE - Crear Cliente
-- ============================================================================
DROP PROCEDURE IF EXISTS sp_crear_cliente$$

CREATE PROCEDURE sp_crear_cliente(
    IN p_id_usuario INT,
    OUT p_out_id_cliente INT,
    OUT p_out_mensaje VARCHAR(255)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET p_out_id_cliente = NULL;
        SET p_out_mensaje = 'Error al crear cliente';
        ROLLBACK;
    END;

    START TRANSACTION;

    -- Verificar que el usuario exista
    IF NOT EXISTS (SELECT 1 FROM usuario WHERE id_usuario = p_id_usuario) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'El usuario no existe';
    END IF;

    -- Crear cliente
    INSERT INTO cliente (id_usuario)
    VALUES (p_id_usuario);

    SET p_out_id_cliente = LAST_INSERT_ID();
    SET p_out_mensaje = 'Cliente creado exitosamente';
    COMMIT;
END$$


-- ============================================================================
-- SP: CLIENTE - Agregar Dirección
-- ============================================================================
DROP PROCEDURE IF EXISTS sp_agregar_direccion_cliente$$

CREATE PROCEDURE sp_agregar_direccion_cliente(
    IN p_id_cliente INT,
    IN p_calle_principal VARCHAR(255),
    IN p_calle_secundaria VARCHAR(255),
    IN p_numero VARCHAR(20),
    IN p_ciudad VARCHAR(100),
    IN p_provincia_estado VARCHAR(100),
    IN p_codigo_postal VARCHAR(20),
    IN p_pais VARCHAR(100),
    IN p_latitud DECIMAL(10,8),
    IN p_longitud DECIMAL(11,8),
    IN p_referencia TEXT,
    IN p_alias VARCHAR(45),
    IN p_es_principal TINYINT,
    OUT p_out_id_direccion INT,
    OUT p_out_mensaje VARCHAR(255)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET p_out_id_direccion = NULL;
        SET p_out_mensaje = 'Error al agregar dirección';
        ROLLBACK;
    END;

    START TRANSACTION;

    -- Verificar que el cliente exista
    IF NOT EXISTS (SELECT 1 FROM cliente WHERE id_cliente = p_id_cliente) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'El cliente no existe';
    END IF;

    -- Si es principal, desmarcar las otras direcciones principales
    IF p_es_principal = 1 THEN
        UPDATE direcciones_del_cliente
        SET es_principal = 0
        WHERE id_cliente = p_id_cliente;
    END IF;

    -- Crear dirección
    INSERT INTO direccion (
        calle_principal, calle_secundaria, numero, ciudad, provincia_estado,
        codigo_postal, pais, latitud, longitud, referencia
    )
    VALUES (
        p_calle_principal, p_calle_secundaria, p_numero, p_ciudad, p_provincia_estado,
        p_codigo_postal, IFNULL(p_pais, 'Ecuador'), p_latitud, p_longitud, p_referencia
    );

    SET p_out_id_direccion = LAST_INSERT_ID();

    -- Asociar dirección con cliente
    INSERT INTO direcciones_del_cliente (id_cliente, id_direccion, alias, es_principal)
    VALUES (p_id_cliente, p_out_id_direccion, p_alias, IFNULL(p_es_principal, 0));

    SET p_out_mensaje = 'Dirección agregada exitosamente';
    COMMIT;
END$$


-- ============================================================================
-- SP: CLIENTE - Actualizar Alias de Dirección
-- ============================================================================
DROP PROCEDURE IF EXISTS sp_actualizar_alias_direccion$$

CREATE PROCEDURE sp_actualizar_alias_direccion(
    IN p_id_cliente INT,
    IN p_id_direccion INT,
    IN p_alias VARCHAR(45),
    OUT p_out_mensaje VARCHAR(255)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET p_out_mensaje = 'Error al actualizar alias de dirección';
        ROLLBACK;
    END;

    START TRANSACTION;

    -- Verificar que la relación exista
    IF NOT EXISTS (
        SELECT 1 FROM direcciones_del_cliente
        WHERE id_cliente = p_id_cliente AND id_direccion = p_id_direccion
    ) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'La dirección no pertenece al cliente';
    END IF;

    -- Actualizar alias
    UPDATE direcciones_del_cliente
    SET alias = p_alias
    WHERE id_cliente = p_id_cliente AND id_direccion = p_id_direccion;

    SET p_out_mensaje = 'Alias actualizado exitosamente';
    COMMIT;
END$$


-- ============================================================================
-- SP: CLIENTE - Eliminar Dirección
-- ============================================================================
DROP PROCEDURE IF EXISTS sp_eliminar_direccion_cliente$$

CREATE PROCEDURE sp_eliminar_direccion_cliente(
    IN p_id_cliente INT,
    IN p_id_direccion INT,
    OUT p_out_mensaje VARCHAR(255)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET p_out_mensaje = 'Error al eliminar dirección';
        ROLLBACK;
    END;

    START TRANSACTION;

    -- Eliminar relación
    DELETE FROM direcciones_del_cliente
    WHERE id_cliente = p_id_cliente AND id_direccion = p_id_direccion;

    IF ROW_COUNT() = 0 THEN
        SET p_out_mensaje = 'La relación no existe';
    ELSE
        SET p_out_mensaje = 'Dirección eliminada exitosamente';
    END IF;

    COMMIT;
END$$


-- ============================================================================
-- SP: DIRECCION - Actualizar Dirección
-- ============================================================================
DROP PROCEDURE IF EXISTS sp_actualizar_direccion$$

CREATE PROCEDURE sp_actualizar_direccion(
    IN p_id_direccion INT,
    IN p_calle_principal VARCHAR(255),
    IN p_calle_secundaria VARCHAR(255),
    IN p_numero VARCHAR(20),
    IN p_ciudad VARCHAR(100),
    IN p_provincia_estado VARCHAR(100),
    IN p_codigo_postal VARCHAR(20),
    IN p_pais VARCHAR(100),
    IN p_latitud DECIMAL(10,8),
    IN p_longitud DECIMAL(11,8),
    IN p_referencia TEXT,
    OUT p_out_mensaje VARCHAR(255)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET p_out_mensaje = 'Error al actualizar dirección';
        ROLLBACK;
    END;

    START TRANSACTION;

    -- Verificar que la dirección exista
    IF NOT EXISTS (SELECT 1 FROM direccion WHERE id_direccion = p_id_direccion) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'La dirección no existe';
    END IF;

    -- Actualizar dirección
    UPDATE direccion
    SET calle_principal = IFNULL(p_calle_principal, calle_principal),
        calle_secundaria = IFNULL(p_calle_secundaria, calle_secundaria),
        numero = IFNULL(p_numero, numero),
        ciudad = IFNULL(p_ciudad, ciudad),
        provincia_estado = IFNULL(p_provincia_estado, provincia_estado),
        codigo_postal = IFNULL(p_codigo_postal, codigo_postal),
        pais = IFNULL(p_pais, pais),
        latitud = IFNULL(p_latitud, latitud),
        longitud = IFNULL(p_longitud, longitud),
        referencia = IFNULL(p_referencia, referencia)
    WHERE id_direccion = p_id_direccion;

    SET p_out_mensaje = 'Dirección actualizada exitosamente';
    COMMIT;
END$$


-- ============================================================================
-- SP: DIRECCION - Eliminar Dirección
-- ============================================================================
DROP PROCEDURE IF EXISTS sp_eliminar_direccion$$

CREATE PROCEDURE sp_eliminar_direccion(
    IN p_id_direccion INT,
    OUT p_out_mensaje VARCHAR(255)
)
BEGIN
    DECLARE v_count INT DEFAULT 0;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET p_out_mensaje = 'Error al eliminar dirección';
        ROLLBACK;
    END;

    START TRANSACTION;

    -- Verificar que la dirección no esté en uso
    SELECT COUNT(*) INTO v_count
    FROM direcciones_del_cliente
    WHERE id_direccion = p_id_direccion;

    IF v_count > 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'La dirección está en uso por uno o más clientes';
    END IF;

    SELECT COUNT(*) INTO v_count
    FROM sucursal
    WHERE id_direccion = p_id_direccion;

    IF v_count > 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'La dirección está en uso por una o más sucursales';
    END IF;

    SELECT COUNT(*) INTO v_count
    FROM contratacion
    WHERE id_direccion_entrega = p_id_direccion;

    IF v_count > 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'La dirección está en uso por una o más contrataciones';
    END IF;

    -- Eliminar dirección
    DELETE FROM direccion WHERE id_direccion = p_id_direccion;

    SET p_out_mensaje = 'Dirección eliminada exitosamente';
    COMMIT;
END$$


-- ============================================================================
-- SP: CONTRATACION - Actualizar Comisiones
-- ============================================================================
DROP PROCEDURE IF EXISTS sp_actualizar_comisiones$$

CREATE PROCEDURE sp_actualizar_comisiones(
    IN p_id_contratacion INT,
    IN p_comision_plataforma DECIMAL(10,2),
    IN p_ganancia_empresa DECIMAL(10,2),
    OUT p_out_mensaje VARCHAR(255)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET p_out_mensaje = 'Error al actualizar comisiones';
        ROLLBACK;
    END;

    START TRANSACTION;

    -- Verificar que la contratación exista
    IF NOT EXISTS (SELECT 1 FROM contratacion WHERE id_contratacion = p_id_contratacion) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'La contratación no existe';
    END IF;

    -- Actualizar comisiones
    UPDATE contratacion
    SET comision_plataforma = p_comision_plataforma,
        ganancia_empresa = p_ganancia_empresa
    WHERE id_contratacion = p_id_contratacion;

    SET p_out_mensaje = 'Comisiones actualizadas exitosamente';
    COMMIT;
END$$


-- ============================================================================
-- SP: PAGO - Crear Pago
-- ============================================================================
DROP PROCEDURE IF EXISTS sp_crear_pago$$

CREATE PROCEDURE sp_crear_pago(
    IN p_id_contratacion INT,
    IN p_monto DECIMAL(10,2),
    IN p_metodo_pago ENUM('tarjeta_credito', 'tarjeta_debito', 'efectivo', 'transferencia', 'paypal', 'otro'),
    OUT p_out_id_pago INT,
    OUT p_out_mensaje VARCHAR(255)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET p_out_id_pago = NULL;
        SET p_out_mensaje = 'Error al crear pago';
        ROLLBACK;
    END;

    START TRANSACTION;

    -- Verificar que la contratación exista
    IF NOT EXISTS (SELECT 1 FROM contratacion WHERE id_contratacion = p_id_contratacion) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'La contratación no existe';
    END IF;

    -- Crear pago
    INSERT INTO pago (id_contratacion, monto, metodo_pago, estado_pago)
    VALUES (p_id_contratacion, p_monto, p_metodo_pago, 'pendiente');

    SET p_out_id_pago = LAST_INSERT_ID();
    SET p_out_mensaje = 'Pago creado exitosamente';
    COMMIT;
END$$


-- ============================================================================
-- SP: PAGO - Actualizar Estado de Pago
-- ============================================================================
DROP PROCEDURE IF EXISTS sp_actualizar_estado_pago$$

CREATE PROCEDURE sp_actualizar_estado_pago(
    IN p_id_contratacion INT,
    IN p_estado_pago ENUM('pendiente', 'completado', 'fallido', 'reembolsado'),
    OUT p_out_mensaje VARCHAR(255)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET p_out_mensaje = 'Error al actualizar estado de pago';
        ROLLBACK;
    END;

    START TRANSACTION;

    -- Actualizar estado de pago
    UPDATE pago
    SET estado_pago = p_estado_pago
    WHERE id_contratacion = p_id_contratacion;

    IF ROW_COUNT() = 0 THEN
        SET p_out_mensaje = 'El pago no existe';
    ELSE
        SET p_out_mensaje = 'Estado de pago actualizado exitosamente';
    END IF;

    COMMIT;
END$$


DELIMITER ;

-- ============================================================================
-- FIN DE STORED PROCEDURES
-- ============================================================================
--
-- Total: 40 stored procedures nuevos creados
--
-- Para aplicar:
-- mysql -u root -p app_servicios < backend/database/nuevos SP.sql
--
-- Para verificar:
-- SHOW PROCEDURE STATUS WHERE Db = 'app_servicios';
--
-- ============================================================================
