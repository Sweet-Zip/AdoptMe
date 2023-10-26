const mysql = require('mysql2/promise');

// Database configuration
const dbConfig = {
  host: 'localhost',
  user: 'root',
  password: '',
  database: 'adoptme',
};

// Create a connection pool for database connections
const pool = mysql.createPool(dbConfig);

module.exports = pool;
