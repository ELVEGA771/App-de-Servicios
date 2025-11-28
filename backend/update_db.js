const fs = require('fs');
const path = require('path');
const { executeQuery, pool } = require('./src/config/database');

const updateDb = async () => {
  try {
    const sqlPath = path.join(__dirname, 'database', 'update_view_stats.sql');
    const sql = fs.readFileSync(sqlPath, 'utf8');
    
    // Split by semicolon to handle multiple statements if any (though here it's just DROP and CREATE)
    const statements = sql.split(';').filter(stmt => stmt.trim().length > 0);

    for (const statement of statements) {
      console.log('Executing:', statement.substring(0, 50) + '...');
      await executeQuery(statement);
    }

    console.log('✅ Database updated successfully');
  } catch (error) {
    console.error('❌ Error updating database:', error);
  } finally {
    await pool.end();
  }
};

updateDb();
