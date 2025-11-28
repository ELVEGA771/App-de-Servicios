-- Script para actualizar la vista vista_servicios_completos
-- Este script agrega el campo imagen_url a la vista

-- Eliminar la vista existente
DROP VIEW IF EXISTS `vista_servicios_completos`;

-- Recrear la vista con el campo imagen_url incluido
CREATE VIEW `vista_servicios_completos` AS
SELECT
  `s`.`id_servicio` AS `id_servicio`,
  `s`.`nombre` AS `servicio_nombre`,
  `s`.`descripcion` AS `descripcion`,
  `s`.`precio_base` AS `precio_base`,
  `s`.`duracion_estimada` AS `duracion_estimada`,
  `s`.`imagen_url` AS `imagen_url`,
  `s`.`estado` AS `servicio_estado`,
  `c`.`nombre` AS `categoria_nombre`,
  `e`.`razon_social` AS `empresa_nombre`,
  `e`.`calificacion_promedio` AS `empresa_calificacion`,
  `u`.`email` AS `empresa_email`,
  `u`.`telefono` AS `empresa_telefono`
FROM `servicio` `s`
JOIN `categoria_servicio` `c` ON `s`.`id_categoria` = `c`.`id_categoria`
JOIN `empresa` `e` ON `s`.`id_empresa` = `e`.`id_empresa`
JOIN `usuario` `u` ON `e`.`id_usuario` = `u`.`id_usuario`
WHERE `s`.`estado` = 'disponible';

-- Verificar que la vista se creó correctamente
SELECT 'Vista actualizada correctamente' AS mensaje;
SELECT * FROM vista_servicios_completos LIMIT 5;
