const pool = require('../db/db'); // Adjust the path as needed


// Function to create a new user
async function createUser(user_id, username, email, profile_image) {
  const connection = await pool.getConnection();
  // SQL query to insert a new user into the "users" table with the provided user_id
  const insertUserQuery = `
    INSERT INTO users (user_id, username, email, profile_image)
    VALUES (?, ?, ?, ?)
  `;
  await connection.query(insertUserQuery, [user_id, username, email, profile_image]);
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

// Function to get a user by user_id
async function getUserById(userId) {
  const connection = await pool.getConnection();
  const getUserQuery = 'SELECT * FROM users WHERE user_id = ?';
  const [rows] = await connection.query(getUserQuery, [userId]);
  connection.release();

  if (rows.length === 1) {
    return rows[0]; // Return the user data
  } else {
    return null; // User not found
  }
}


// Function to update a user
async function updateUser(userId, username, email, profile_image) {
  const connection = await pool.getConnection();
  const updateUserQuery = `
    UPDATE users
    SET username = ?, email = ?, profile_image = ?
    WHERE user_id = ?
  `;
  await connection.query(updateUserQuery, [username, email, profile_image, userId]);
  connection.release();
}

module.exports = {
  createUser,
  getAllUsers,
  getUserById,
  updateUser,
};