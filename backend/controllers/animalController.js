const pool = require('../db/db');

// Function to add a new animal type
async function addAnimalType(type_name, image) {
    const connection = await pool.getConnection();

    const checkQuery = 'SELECT type_id FROM animal_type WHERE type_name = ?';
    const [existingTypes] = await connection.query(checkQuery, [type_name]);

    if (existingTypes.length > 0) {
        connection.release();
        return { message: 'Animal type already exists' };
    }

    const insertQuery = 'INSERT INTO animal_type (type_name, image) VALUES (?, ?)';
    const [result] = await connection.query(insertQuery, [type_name, image]);
    connection.release();
    return { message: 'Animal type added', type_id: result.insertId };
}


// Function to update an animal type by ID
async function updateAnimalType(type_id, type_name) {
    const connection = await pool.getConnection();
    const updateQuery = 'UPDATE animal_type SET type_name = ? WHERE type_id = ?';
    const [result] = await connection.query(updateQuery, [type_name, type_id]);
    connection.release();
    return result.affectedRows > 0; // Check if a record was updated
}

// Function to delete an animal type by ID
async function deleteAnimalType(type_id) {
    const connection = await pool.getConnection();
    const deleteQuery = 'DELETE FROM animal_type WHERE type_id = ?';
    const [result] = await connection.query(deleteQuery, [type_id]);
    connection.release();
    return result.affectedRows > 0; // Check if a record was deleted
}

// Function to get all animal types
async function getAllAnimalTypes() {
    const connection = await pool.getConnection();
    const selectQuery = 'SELECT * FROM animal_type';
    const [rows] = await connection.query(selectQuery);
    connection.release();
    return rows;
}

// Function to get an animal type by ID
async function getAnimalTypeById(type_id) {
    const connection = await pool.getConnection();
    const selectQuery = 'SELECT * FROM animal_type WHERE type_id = ?';
    const [rows] = await connection.query(selectQuery, [type_id]);
    connection.release();
    return rows[0]; // Return the first matching record or null if not found
}

module.exports = {
    addAnimalType,
    updateAnimalType,
    deleteAnimalType,
    getAllAnimalTypes,
    getAnimalTypeById,
};
