const pool = require('./db/db'); // Import the database connection

async function createTable() {
  try {
    // Create a database connection from the pool
    const connection = await pool.getConnection();

    // SQL query to create the "users" table
    const createTableQuery = `
      CREATE TABLE IF NOT EXISTS users (
        user_id INT AUTO_INCREMENT PRIMARY KEY,
        username VARCHAR(255) NOT NULL,
        email VARCHAR(255) NOT NULL,
        user_image VARCHAR(255)
      )
    `;

    // SQL query to create the "post" table
    // SQL query to create the "post" table with a default value for 'likes'
    const createPostTableQuery = `
      CREATE TABLE IF NOT EXISTS post (
        post_id INT AUTO_INCREMENT PRIMARY KEY,
        caption TEXT,
        user_id INT,
        likes INT DEFAULT 0, -- Set default value to 0
        contact VARCHAR(255),
        image VARCHAR(255)
      )
    `;


    // Execute the query to create the "users" table
    await connection.query(createTableQuery);

    // Execute the query to create the "post" table
    await connection.query(createPostTableQuery);

    // Release the database connection
    connection.release();

    console.log('Tables "users" and "post" created (if they didn\'t exist).');
  } catch (error) {
    console.error('Error creating tables: ' + error.message);
  }
}

module.exports = createTable;
