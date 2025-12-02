CREATE OR REPLACE VIEW `vista_contrataciones_detalle` AS 
SELECT 
    con.id_contratacion,
    con.fecha_solicitud,
    con.fecha_programada,
    con.estado AS estado_contratacion,
    con.precio_total,
    con.precio_subtotal,
    concat(uc.nombre,' ',uc.apellido) AS cliente_nombre,
    uc.email AS cliente_email,
    s.nombre AS servicio_nombre,
    s.imagen_url AS servicio_imagen,
    e.razon_social AS empresa_nombre,
    suc.nombre_sucursal AS nombre_sucursal,
    concat(d.calle_principal,', ',d.ciudad) AS direccion_entrega,
    cup.codigo AS cupon_codigo,
    con.descuento_aplicado
FROM contratacion con
JOIN cliente cli ON con.id_cliente = cli.id_cliente
JOIN usuario uc ON cli.id_usuario = uc.id_usuario
JOIN servicio s ON con.id_servicio = s.id_servicio
JOIN empresa e ON s.id_empresa = e.id_empresa
JOIN usuario ue ON e.id_usuario = ue.id_usuario
JOIN sucursal suc ON con.id_sucursal = suc.id_sucursal
JOIN direccion d ON con.id_direccion_entrega = d.id_direccion
LEFT JOIN cupon cup ON con.id_cupon = cup.id_cupon;
