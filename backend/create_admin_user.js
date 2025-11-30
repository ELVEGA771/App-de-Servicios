const { executeQuery } = require('./src/config/database');
const bcrypt = require('bcrypt');
const dotenv = require('dotenv');

dotenv.config();

async function createAdminUser() {
  try {
    const email = 'admin@app.com';
    const password = 'Admin1234';
    const hash = '$2b$10$rZX5bxG/9xWxSLbJdJUxJeF93so1jcTxpVqHcCtTyY9HWqbMD11Em'; // Pre-generated hash

    console.log('Checking if admin user exists...');
    const checkQuery = 'SELECT * FROM usuario WHERE email = ?';
    const existingUser = await executeQuery(checkQuery, [email]);

    if (existingUser.length > 0) {
      console.log('Admin user already exists.');
      process.exit(0);
    }

    console.log('Creating admin user...');
    const insertQuery = `
      INSERT INTO usuario (email, password_hash, nombre, apellido, tipo_usuario, estado, fecha_registro)
      VALUES (?, ?, ?, ?, ?, ?, NOW())
    `;
    
    await executeQuery(insertQuery, [email, hash, 'Admin', 'System', 'admin', 'activo']);
    
    console.log('Admin user created successfully.');
    process.exit(0);
  } catch (error) {
    console.error('Error creating admin user:', error);
    process.exit(1);
  }
}

createAdminUser();
