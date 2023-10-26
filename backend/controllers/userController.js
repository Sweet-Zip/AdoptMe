const pool = require('../db/db'); // Adjust the path as needed


// Function to create a new user
async function createUser(username, email, user_image) {
  const connection = await pool.getConnection();
  // SQL query to insert a new user into the "users" table
  const insertUserQuery = `
    INSERT INTO users (username, email, user_image)
    VALUES (?, ?, ?)
  `;
  await connection.query(insertUserQuery, [username, email, user_image]);
  connection.release();
}

// Function to get all users
async function getAllUsers() {
  const connection = await pool.getConnection();
  const getUsersQuery = 'SELECT * FROM users';
  const [rows] = await connection.query(getUsersQuery);
  connection.release();
  return rows;
}

// Function to update a user
async function updateUser(userId, username, email, user_image) {
  const connection = await pool.getConnection();
  const updateUserQuery = `
    UPDATE users
    SET username = ?, email = ?, user_image = ?
    WHERE user_id = ?
  `;
  await connection.query(updateUserQuery, [username, email, user_image, userId]);
  connection.release();
}

module.exports = {
  createUser,
  getAllUsers,
  updateUser,
};