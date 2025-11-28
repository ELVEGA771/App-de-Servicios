DROP VIEW IF EXISTS `vista_estadisticas_empresa`;

CREATE VIEW `vista_estadisticas_empresa` AS 
SELECT 
    `e`.`id_empresa` AS `id_empresa`,
    `e`.`razon_social` AS `razon_social`,
    `e`.`logo_url` AS `logo_url`,
    `e`.`calificacion_promedio` AS `calificacion_promedio`,
    count(distinct `s`.`id_servicio`) AS `total_servicios`,
    count(distinct `suc`.`id_sucursal`) AS `total_sucursales`,
    count(distinct `con`.`id_contratacion`) AS `total_contrataciones`,
    sum((case when (`con`.`estado` = 'completado') then `con`.`precio_total` else 0 end)) AS `ingresos_totales`,
    count(distinct `cup`.`id_cupon`) AS `cupones_activos` 
FROM `empresa` `e` 
LEFT JOIN `servicio` `s` ON `e`.`id_empresa` = `s`.`id_empresa`
LEFT JOIN `sucursal` `suc` ON `e`.`id_empresa` = `suc`.`id_empresa`
LEFT JOIN `contratacion` `con` ON `s`.`id_servicio` = `con`.`id_servicio`
LEFT JOIN `cupon` `cup` ON `e`.`id_empresa` = `cup`.`id_empresa` AND `cup`.`activo` = true
GROUP BY `e`.`id_empresa`, `e`.`razon_social`, `e`.`logo_url`, `e`.`calificacion_promedio`;
