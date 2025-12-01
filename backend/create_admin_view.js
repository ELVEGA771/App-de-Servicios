const { executeQuery } = require('./src/config/database');

const createViewQuery = `
CREATE OR REPLACE VIEW vista_top_clientes AS
SELECT 
    c.id_cliente,
    CONCAT(u.nombre, ' ', u.apellido) as nombre_completo,
    u.email,
    COUNT(con.id_contratacion) as total_contrataciones,
    COALESCE(SUM(con.precio_total), 0) as total_gastado,
    MAX(con.fecha_solicitud) as ultima_contratacion
FROM cliente c
JOIN usuario u ON c.id_usuario = u.id_usuario
LEFT JOIN contratacion con ON c.id_cliente = con.id_cliente
GROUP BY c.id_cliente, u.nombre, u.apellido, u.email
ORDER BY total_gastado DESC;
`;

const run = async () => {
    try {
        console.log('Creating view vista_top_clientes...');
        await executeQuery(createViewQuery);
        console.log('View created successfully.');
        process.exit(0);
    } catch (error) {
        console.error('Error creating view:', error);
        process.exit(1);
    }
};

run();
