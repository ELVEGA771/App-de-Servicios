const fs = require('fs');
const path = require('path');
const { executeQuery, pool } = require('./src/config/database');

const updateDb = async () => {
  try {
    // Read the SQL file from the root directory
    const sqlPath = path.join(__dirname, '..', 'update_vista_contrataciones_detalle.sql');
    const sql = fs.readFileSync(sqlPath, 'utf8');
    
    console.log('Executing SQL from:', sqlPath);
    
    // Split by semicolon to handle multiple statements if any
    const statements = sql.split(';').filter(stmt => stmt.trim().length > 0);

    for (const statement of statements) {
      console.log('Executing statement...');
      await executeQuery(statement);
    }

    console.log('✅ View vista_contrataciones_detalle updated successfully');
  } catch (error) {
    console.error('❌ Error updating database:', error);
  } finally {
    await pool.end();
  }
};

updateDb();
