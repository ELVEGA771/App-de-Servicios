const fs = require('fs');
const path = require('path');
const mysql = require('mysql2/promise');
require('dotenv').config();

async function run() {
  const connection = await mysql.createConnection({
    host: process.env.DB_HOST,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME
  });

  try {
    const sql = fs.readFileSync(path.join(__dirname, 'update_view_stats_v2.sql'), 'utf8');
    console.log('Executing SQL...');
    await connection.query(sql);
    console.log('✅ View updated successfully');
  } catch (error) {
    console.error('Error:', error);
  } finally {
    await connection.end();
  }
}

run();
