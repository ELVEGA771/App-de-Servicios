-- ============================================================================
-- STORED PROCEDURES - App de Servicios (SIN TRIGGERS)
-- ============================================================================
-- Versión: 2.0
-- Fecha: 2025
-- Cambios:
--   - Eliminada toda dependencia de triggers
--   - Lógica de triggers implementada en SPs
--   - Soporte para tabla historial_estado_contratacion
--   - Soporte para columnas calculadas de comisiones
--
-- Convenciones:
--   - Nombres: sp_<accion>_<entidad>
--   - Parámetros IN: p_<nombre>
--   - Parámetros OUT: p_out_<nombre>
--   - Códigos de error SQLSTATE: '45000' (errores de negocio)
-- ============================================================================

DELIMITER $$

-- ============================================================================
-- SP 1: Registrar Usuario (Cliente o Empresa)
-- ============================================================================
DROP PROCEDURE IF EXISTS sp_registrar_usuario$$

CREATE PROCEDURE sp_registrar_usuario(
    -- Datos del usuario
    IN p_email VARCHAR(255),
    IN p_password_hash VARCHAR(255),
    IN p_nombre VARCHAR(100),
    IN p_apellido VARCHAR(100),
    IN p_telefono VARCHAR(20),
    IN p_tipo_usuario ENUM('cliente', 'empresa'),
    -- Datos específicos de empresa (opcionales)
    IN p_razon_social VARCHAR(255),
    IN p_ruc_nit VARCHAR(50),
    IN p_pais VARCHAR(100),
    -- Parámetros de salida
    OUT p_out_id_usuario INT,
    OUT p_out_id_entidad INT,
    OUT p_out_mensaje VARCHAR(255)
)
BEGIN
    DECLARE v_email_count INT DEFAULT 0;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SET p_out_id_usuario = NULL;
        SET p_out_id_entidad = NULL;
        SET p_out_mensaje = 'Error al registrar usuario';
    END;

    START TRANSACTION;

    -- Validar que el email no exista
    SELECT COUNT(*) INTO v_email_count FROM usuario WHERE email = p_email;
    IF v_email_count > 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'El email ya está registrado';
    END IF;

    -- Validar tipo de usuario
    IF p_tipo_usuario NOT IN ('cliente', 'empresa') THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Tipo de usuario inválido';
    END IF;

    -- Validar datos de empresa si es tipo empresa
    IF p_tipo_usuario = 'empresa' AND (p_razon_social IS NULL OR p_razon_social = '') THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Razón social es requerida para empresas';
    END IF;

    -- Crear usuario
    INSERT INTO usuario (email, password_hash, nombre, apellido, telefono, tipo_usuario)
    VALUES (p_email, p_password_hash, p_nombre, p_apellido, p_telefono, p_tipo_usuario);

    SET p_out_id_usuario = LAST_INSERT_ID();

    -- Crear entidad según tipo
    IF p_tipo_usuario = 'cliente' THEN
        INSERT INTO cliente (id_usuario) VALUES (p_out_id_usuario);
        SET p_out_id_entidad = LAST_INSERT_ID();
        SET p_out_mensaje = 'Cliente registrado exitosamente';
    ELSE
        INSERT INTO empresa (id_usuario, razon_social, ruc_nit, pais)
        VALUES (p_out_id_usuario, p_razon_social, p_ruc_nit, p_pais);
        SET p_out_id_entidad = LAST_INSERT_ID();
        SET p_out_mensaje = 'Empresa registrada exitosamente';
    END IF;

    COMMIT;
END$$


-- ============================================================================
-- SP 2: Crear Sucursal con Dirección
-- ============================================================================
DROP PROCEDURE IF EXISTS sp_crear_sucursal$$

CREATE PROCEDURE sp_crear_sucursal(
    -- Datos de la sucursal
    IN p_id_empresa INT,
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
    -- Parámetros de salida
    OUT p_out_id_sucursal INT,
    OUT p_out_id_direccion INT,
    OUT p_out_mensaje VARCHAR(255)
)
BEGIN
    DECLARE v_empresa_count INT DEFAULT 0;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SET p_out_id_sucursal = NULL;
        SET p_out_id_direccion = NULL;
        SET p_out_mensaje = 'Error al crear sucursal';
    END;

    START TRANSACTION;

    -- Validar que la empresa exista
    SELECT COUNT(*) INTO v_empresa_count FROM empresa WHERE id_empresa = p_id_empresa;
    IF v_empresa_count = 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'La empresa no existe';
    END IF;

    -- Validar datos obligatorios
    IF p_calle_principal IS NULL OR p_ciudad IS NULL OR p_provincia_estado IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Calle principal, ciudad y provincia son obligatorios';
    END IF;

    IF p_nombre_sucursal IS NULL OR p_nombre_sucursal = '' THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Nombre de sucursal es obligatorio';
    END IF;

    -- Crear dirección
    INSERT INTO direccion (
        calle_principal, calle_secundaria, numero, ciudad, provincia_estado,
        codigo_postal, pais, latitud, longitud, referencia
    ) VALUES (
        p_calle_principal, p_calle_secundaria, p_numero, p_ciudad, p_provincia_estado,
        p_codigo_postal, IFNULL(p_pais, 'Ecuador'), p_latitud, p_longitud, p_referencia
    );

    SET p_out_id_direccion = LAST_INSERT_ID();

    -- Crear sucursal
    INSERT INTO sucursal (
        id_empresa, id_direccion, nombre_sucursal, telefono,
        horario_apertura, horario_cierre, dias_laborales, estado
    ) VALUES (
        p_id_empresa, p_out_id_direccion, p_nombre_sucursal, p_telefono,
        p_horario_apertura, p_horario_cierre, IFNULL(p_dias_laborales, '1111100'),
        IFNULL(p_estado, 'activa')
    );

    SET p_out_id_sucursal = LAST_INSERT_ID();
    SET p_out_mensaje = 'Sucursal creada exitosamente';

    COMMIT;
END$$


-- ============================================================================
-- SP 3: Crear Calificación (SIN TRIGGER - Actualiza promedio manualmente)
-- ============================================================================
DROP PROCEDURE IF EXISTS sp_crear_calificacion$$

CREATE PROCEDURE sp_crear_calificacion(
    IN p_id_contratacion INT,
    IN p_calificacion TINYINT,
    IN p_comentario TEXT,
    IN p_tipo ENUM('cliente_a_empresa', 'empresa_a_cliente'),
    OUT p_out_id_calificacion INT,
    OUT p_out_mensaje VARCHAR(255)
)
BEGIN
    DECLARE v_contratacion_estado VARCHAR(20);
    DECLARE v_calificacion_count INT DEFAULT 0;
    DECLARE v_id_empresa INT;
    DECLARE v_nuevo_promedio DECIMAL(3,2);

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SET p_out_id_calificacion = NULL;
        SET p_out_mensaje = 'Error al crear calificación';
    END;

    START TRANSACTION;

    -- Validar que la contratación exista y esté completada
    SELECT estado INTO v_contratacion_estado
    FROM contratacion
    WHERE id_contratacion = p_id_contratacion;

    IF v_contratacion_estado IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'La contratación no existe';
    END IF;

    IF v_contratacion_estado != 'completado' THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Solo se pueden calificar contrataciones completadas';
    END IF;

    -- Validar que no exista calificación previa del mismo tipo
    SELECT COUNT(*) INTO v_calificacion_count
    FROM calificacion
    WHERE id_contratacion = p_id_contratacion AND tipo = p_tipo;

    IF v_calificacion_count > 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Esta contratación ya fue calificada';
    END IF;

    -- Validar rango de calificación
    IF p_calificacion < 1 OR p_calificacion > 5 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'La calificación debe estar entre 1 y 5';
    END IF;

    -- Crear calificación
    INSERT INTO calificacion (id_contratacion, calificacion, comentario, tipo)
    VALUES (p_id_contratacion, p_calificacion, p_comentario, p_tipo);

    SET p_out_id_calificacion = LAST_INSERT_ID();

    -- *** LÓGICA DEL TRIGGER IMPLEMENTADA AQUÍ ***
    -- Si es calificación de cliente a empresa, actualizar promedio de la empresa
    IF p_tipo = 'cliente_a_empresa' THEN
        -- Obtener el ID de la empresa
        SELECT s.id_empresa INTO v_id_empresa
        FROM contratacion c
        INNER JOIN servicio s ON c.id_servicio = s.id_servicio
        WHERE c.id_contratacion = p_id_contratacion;

        -- Calcular nuevo promedio
        SELECT AVG(cal.calificacion) INTO v_nuevo_promedio
        FROM calificacion cal
        INNER JOIN contratacion c ON cal.id_contratacion = c.id_contratacion
        INNER JOIN servicio s ON c.id_servicio = s.id_servicio
        WHERE s.id_empresa = v_id_empresa
        AND cal.tipo = 'cliente_a_empresa';

        -- Actualizar promedio en tabla empresa
        UPDATE empresa
        SET calificacion_promedio = IFNULL(v_nuevo_promedio, 0)
        WHERE id_empresa = v_id_empresa;
    END IF;

    SET p_out_mensaje = 'Calificación creada exitosamente';

    COMMIT;
END$$


-- ============================================================================
-- SP 4: Establecer Dirección Principal del Cliente
-- ============================================================================
DROP PROCEDURE IF EXISTS sp_establecer_direccion_principal$$

CREATE PROCEDURE sp_establecer_direccion_principal(
    IN p_id_cliente INT,
    IN p_id_direccion INT,
    OUT p_out_mensaje VARCHAR(255)
)
BEGIN
    DECLARE v_direccion_count INT DEFAULT 0;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SET p_out_mensaje = 'Error al establecer dirección principal';
    END;

    START TRANSACTION;

    -- Validar que la relación cliente-dirección exista
    SELECT COUNT(*) INTO v_direccion_count
    FROM direcciones_del_cliente
    WHERE id_cliente = p_id_cliente AND id_direccion = p_id_direccion;

    IF v_direccion_count = 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'La dirección no pertenece al cliente';
    END IF;

    -- Desmarcar todas las direcciones principales del cliente
    UPDATE direcciones_del_cliente
    SET es_principal = 0
    WHERE id_cliente = p_id_cliente;

    -- Marcar la nueva dirección como principal
    UPDATE direcciones_del_cliente
    SET es_principal = 1
    WHERE id_cliente = p_id_cliente AND id_direccion = p_id_direccion;

    SET p_out_mensaje = 'Dirección principal establecida exitosamente';

    COMMIT;
END$$


-- ============================================================================
-- SP 5: Asociar Servicio a Sucursal (Upsert)
-- ============================================================================
DROP PROCEDURE IF EXISTS sp_asociar_servicio_sucursal$$

CREATE PROCEDURE sp_asociar_servicio_sucursal(
    IN p_id_servicio INT,
    IN p_id_sucursal INT,
    IN p_precio_sucursal DECIMAL(10,2),
    OUT p_out_mensaje VARCHAR(255)
)
BEGIN
    DECLARE v_servicio_count INT DEFAULT 0;
    DECLARE v_sucursal_count INT DEFAULT 0;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SET p_out_mensaje = 'Error al asociar servicio a sucursal';
    END;

    START TRANSACTION;

    -- Validar que el servicio exista
    SELECT COUNT(*) INTO v_servicio_count FROM servicio WHERE id_servicio = p_id_servicio;
    IF v_servicio_count = 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'El servicio no existe';
    END IF;

    -- Validar que la sucursal exista
    SELECT COUNT(*) INTO v_sucursal_count FROM sucursal WHERE id_sucursal = p_id_sucursal;
    IF v_sucursal_count = 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'La sucursal no existe';
    END IF;

    -- Insertar o actualizar la relación
    INSERT INTO servicio_sucursal (id_servicio, id_sucursal, disponible, precio_sucursal)
    VALUES (p_id_servicio, p_id_sucursal, 1, p_precio_sucursal)
    ON DUPLICATE KEY UPDATE
        disponible = 1,
        precio_sucursal = p_precio_sucursal;

    SET p_out_mensaje = 'Servicio asociado a sucursal exitosamente';

    COMMIT;
END$$


-- ============================================================================
-- SP 6: Actualizar Estado de Contratación (CON HISTORIAL)
-- ============================================================================
DROP PROCEDURE IF EXISTS sp_actualizar_estado_contratacion$$

CREATE PROCEDURE sp_actualizar_estado_contratacion(
    IN p_id_contratacion INT,
    IN p_nuevo_estado ENUM('pendiente', 'confirmado', 'en_proceso', 'completado', 'cancelado', 'rechazado'),
    IN p_notas TEXT,
    OUT p_out_mensaje VARCHAR(255)
)
BEGIN
    DECLARE v_estado_actual VARCHAR(20);
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SET p_out_mensaje = 'Error al actualizar estado de contratación';
    END;

    START TRANSACTION;

    -- Obtener estado actual
    SELECT estado INTO v_estado_actual
    FROM contratacion
    WHERE id_contratacion = p_id_contratacion;

    IF v_estado_actual IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'La contratación no existe';
    END IF;

    -- Validar transiciones de estado permitidas
    IF v_estado_actual IN ('cancelado', 'completado', 'rechazado') AND v_estado_actual != p_nuevo_estado THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'No se puede modificar una contratación cancelada, completada o rechazada';
    END IF;

    -- *** REGISTRAR EN HISTORIAL (Nueva funcionalidad) ***
    INSERT INTO historial_estado_contratacion (
        id_contratacion, estado_anterior, estado_nuevo, notas
    ) VALUES (
        p_id_contratacion, v_estado_actual, p_nuevo_estado, p_notas
    );

    -- Actualizar estado en tabla contratacion
    IF p_nuevo_estado = 'completado' THEN
        UPDATE contratacion
        SET estado = p_nuevo_estado,
            notas_empresa = IFNULL(p_notas, notas_empresa),
            fecha_completada = NOW()
        WHERE id_contratacion = p_id_contratacion;
    ELSE
        UPDATE contratacion
        SET estado = p_nuevo_estado,
            notas_empresa = IFNULL(p_notas, notas_empresa)
        WHERE id_contratacion = p_id_contratacion;
    END IF;

    SET p_out_mensaje = CONCAT('Estado actualizado a: ', p_nuevo_estado);

    COMMIT;
END$$


-- ============================================================================
-- SP 7: Crear Contratación (SIN TRIGGER - Incrementa cupón manualmente)
-- ============================================================================
DROP PROCEDURE IF EXISTS sp_crear_contratacion$$

CREATE PROCEDURE sp_crear_contratacion(
    IN p_id_cliente INT,
    IN p_id_servicio INT,
    IN p_id_sucursal INT,
    IN p_id_direccion_entrega INT,
    IN p_id_cupon INT,
    IN p_fecha_programada DATETIME,
    IN p_precio_subtotal DECIMAL(10,2),
    IN p_descuento_aplicado DECIMAL(10,2),
    IN p_precio_total DECIMAL(10,2),
    IN p_porcentaje_comision DECIMAL(5,2),
    IN p_notas_cliente TEXT,
    OUT p_out_id_contratacion INT,
    OUT p_out_mensaje VARCHAR(255)
)
BEGIN
    DECLARE v_cupon_valido INT DEFAULT 0;
    DECLARE v_cupon_disponible INT;
    DECLARE v_cupon_usado INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SET p_out_id_contratacion = NULL;
        SET p_out_mensaje = 'Error al crear contratación';
    END;

    START TRANSACTION;

    -- Validar que el cliente exista
    IF NOT EXISTS (SELECT 1 FROM cliente WHERE id_cliente = p_id_cliente) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'El cliente no existe';
    END IF;

    -- Validar que el servicio exista
    IF NOT EXISTS (SELECT 1 FROM servicio WHERE id_servicio = p_id_servicio) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'El servicio no existe';
    END IF;

    -- Validar cupón si se proporciona
    IF p_id_cupon IS NOT NULL THEN
        SELECT
            CASE
                WHEN activo = 1
                AND (fecha_expiracion IS NULL OR fecha_expiracion > NOW())
                AND (cantidad_disponible IS NULL OR cantidad_usada < cantidad_disponible)
                THEN 1
                ELSE 0
            END,
            cantidad_disponible,
            cantidad_usada
        INTO v_cupon_valido, v_cupon_disponible, v_cupon_usado
        FROM cupon
        WHERE id_cupon = p_id_cupon;

        IF v_cupon_valido = 0 THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'El cupón no es válido o está agotado';
        END IF;
    END IF;

    -- Crear contratación
    INSERT INTO contratacion (
        id_cliente, id_servicio, id_sucursal, id_direccion_entrega, id_cupon,
        fecha_programada, precio_subtotal, descuento_aplicado, precio_total,
        porcentaje_comision, estado, notas_cliente
    ) VALUES (
        p_id_cliente, p_id_servicio, p_id_sucursal, p_id_direccion_entrega, p_id_cupon,
        p_fecha_programada, p_precio_subtotal, IFNULL(p_descuento_aplicado, 0),
        p_precio_total, IFNULL(p_porcentaje_comision, 15.00), 'pendiente', p_notas_cliente
    );

    SET p_out_id_contratacion = LAST_INSERT_ID();

    -- *** LÓGICA DEL TRIGGER IMPLEMENTADA AQUÍ ***
    -- Incrementar uso del cupón si se usó uno
    IF p_id_cupon IS NOT NULL THEN
        UPDATE cupon
        SET cantidad_usada = cantidad_usada + 1
        WHERE id_cupon = p_id_cupon;
    END IF;

    -- *** REGISTRAR EN HISTORIAL ***
    INSERT INTO historial_estado_contratacion (
        id_contratacion, estado_anterior, estado_nuevo, notas
    ) VALUES (
        p_out_id_contratacion, NULL, 'pendiente', 'Contratación creada'
    );

    SET p_out_mensaje = 'Contratación creada exitosamente';

    COMMIT;
END$$


-- ============================================================================
-- SP 8: Crear Mensaje (SIN TRIGGER - Actualiza conversación manualmente)
-- ============================================================================
DROP PROCEDURE IF EXISTS sp_crear_mensaje$$

CREATE PROCEDURE sp_crear_mensaje(
    IN p_id_conversacion INT,
    IN p_id_remitente INT,
    IN p_contenido TEXT,
    IN p_tipo_mensaje ENUM('texto', 'imagen', 'archivo'),
    IN p_archivo_url VARCHAR(500),
    OUT p_out_id_mensaje INT,
    OUT p_out_mensaje VARCHAR(255)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SET p_out_id_mensaje = NULL;
        SET p_out_mensaje = 'Error al crear mensaje';
    END;

    START TRANSACTION;

    -- Validar que la conversación exista
    IF NOT EXISTS (SELECT 1 FROM conversacion WHERE id_conversacion = p_id_conversacion) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'La conversación no existe';
    END IF;

    -- Validar que el contenido no esté vacío (solo para mensajes de texto)
    IF (p_tipo_mensaje = 'texto' OR p_tipo_mensaje IS NULL) AND (p_contenido IS NULL OR TRIM(p_contenido) = '') THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'El contenido del mensaje no puede estar vacío';
    END IF;

    -- Crear mensaje
    INSERT INTO mensaje (id_conversacion, id_remitente, contenido, tipo_mensaje, archivo_url)
    VALUES (
        p_id_conversacion,
        p_id_remitente,
        p_contenido,
        IFNULL(p_tipo_mensaje, 'texto'),
        p_archivo_url
    );

    SET p_out_id_mensaje = LAST_INSERT_ID();

    -- *** LÓGICA DEL TRIGGER IMPLEMENTADA AQUÍ ***
    -- Actualizar fecha del último mensaje en la conversación
    UPDATE conversacion
    SET fecha_ultimo_mensaje = NOW()
    WHERE id_conversacion = p_id_conversacion;

    SET p_out_mensaje = 'Mensaje creado exitosamente';

    COMMIT;
END$$

DELIMITER ;

-- ============================================================================
-- FIN DE STORED PROCEDURES
-- ============================================================================
--
-- IMPORTANTE: Estos SPs NO dependen de triggers.
-- Toda la lógica está implementada dentro de los procedures.
--
-- Para instalar:
-- 1. mysql -u root -p app_servicios < backend/database/stored_procedures.sql
-- 2. Verificar: SHOW PROCEDURE STATUS WHERE Db = 'app_servicios';
-- 3. Deberías ver 8 stored procedures
--
-- Triggers a ELIMINAR (ya no son necesarios):
-- - DROP TRIGGER IF EXISTS trg_incrementar_uso_cupon;
-- - DROP TRIGGER IF EXISTS trg_actualizar_calificacion_empresa;
-- - DROP TRIGGER IF EXISTS trg_actualizar_ultimo_mensaje;
-- ============================================================================
