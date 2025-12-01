CREATE OR REPLACE VIEW `vista_estadisticas_empresa` AS 
SELECT 
    e.id_empresa,
    e.razon_social,
    e.logo_url,
    e.calificacion_promedio,
    (SELECT COUNT(*) FROM servicio s WHERE s.id_empresa = e.id_empresa) AS total_servicios,
    (SELECT COUNT(*) FROM sucursal suc WHERE suc.id_empresa = e.id_empresa) AS total_sucursales,
    (SELECT COUNT(*) 
     FROM contratacion c 
     JOIN servicio s ON c.id_servicio = s.id_servicio 
     WHERE s.id_empresa = e.id_empresa) AS total_contrataciones,
    (SELECT COALESCE(SUM(c.precio_total), 0)
     FROM contratacion c 
     JOIN servicio s ON c.id_servicio = s.id_servicio 
     WHERE s.id_empresa = e.id_empresa AND c.estado = 'completado') AS ingresos_totales,
    (SELECT COUNT(*) FROM cupon cup WHERE cup.id_empresa = e.id_empresa AND cup.activo = 1) AS cupones_activos
FROM empresa e;
