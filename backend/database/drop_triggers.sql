-- ============================================================================
-- ELIMINAR TRIGGERS - Ya no son necesarios
-- ============================================================================
-- Los stored procedures ahora implementan toda la lógica que antes estaba
-- en triggers. Este script elimina los triggers obsoletos.
-- ============================================================================

USE `app_servicios`;

-- Eliminar trigger de incremento de uso de cupón
DROP TRIGGER IF EXISTS `trg_incrementar_uso_cupon`;

-- Eliminar trigger de actualización de calificación de empresa
DROP TRIGGER IF EXISTS `trg_actualizar_calificacion_empresa`;

-- Eliminar trigger de actualización de último mensaje
DROP TRIGGER IF EXISTS `trg_actualizar_ultimo_mensaje`;

-- ============================================================================
-- Verificar que los triggers se eliminaron
-- ============================================================================
-- Ejecutar después de este script:
-- SHOW TRIGGERS FROM app_servicios;
--
-- Deberías ver una lista vacía o solo triggers que no están en esta lista
-- ============================================================================
