const pool = require('./db/db'); // Import the database connection

async function createTable() {
  try {
    // Create a database connection from the pool
    const connection = await pool.getConnection();

    // SQL query to create the "users" table
    const createTableQuery = `
      CREATE TABLE IF NOT EXISTS users (
        user_id VARCHAR(255) PRIMARY KEY NOT NULL,
        username VARCHAR(255) NOT NULL,
        email VARCHAR(255) NOT NULL,
        profile_image VARCHAR(255)
      )
    `;

    const createPostTableQuery = `
      CREATE TABLE IF NOT EXISTS post (
        post_id INT AUTO_INCREMENT PRIMARY KEY,
        caption TEXT,
        user_id VARCHAR(255),
        likes INT DEFAULT 0,
        contact VARCHAR(255),
        image VARCHAR(255),
        animal_type VARCHAR(50) -- Adjust the data type and length as needed
      )
    `;

    const createAnimalTypeTableQuery = `
      CREATE TABLE IF NOT EXISTS animal_type (
        type_id INT AUTO_INCREMENT PRIMARY KEY,
        type_name VARCHAR(255) NOT NULL,
        UNIQUE (type_name),
        image VARCHAR(255)
      )
    `;




    // Execute the query to create the "users" table
    await connection.query(createTableQuery);

    // Execute the query to create the "post" table
    await connection.query(createPostTableQuery);

    // Execute the query to create the "post" table
    await connection.query(createAnimalTypeTableQuery);

    // Release the database connection
    connection.release();

    console.log('Tables "users" and "post" created (if they didn\'t exist).');
  } catch (error) {
    console.error('Error creating tables: ' + error.message);
  }
}

module.exports = createTable;
