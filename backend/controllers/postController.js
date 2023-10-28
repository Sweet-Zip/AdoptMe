const pool = require('../db/db');

// Function to create a new post
async function createPost(caption, user_id, likes, contact, image, animal_type) {
    const connection = await pool.getConnection();
    const insertPostQuery = `
        INSERT INTO post (caption, user_id, likes, contact, image, animal_type)
        VALUES (?, ?, ?, ?, ?, ?)
    `;
    await connection.query(insertPostQuery, [caption, user_id, likes, contact, image, animal_type]);
    connection.release();
}


// Function to fetch all posts
async function getAllPosts() {
    const connection = await pool.getConnection();
    const getPostsQuery = 'SELECT * FROM post';
    const [rows] = await connection.query(getPostsQuery);
    connection.release();
    return rows;
}

async function getPostsByUserId(user_id) {
    const connection = await pool.getConnection();
    const getPostsQuery = 'SELECT * FROM post WHERE user_id = ?';
    const [rows] = await connection.query(getPostsQuery, [user_id]);
    connection.release();
    return rows;
}


// Function to update a post
async function updatePost(post_id, caption, user_id, likes, contact) {
    const connection = await pool.getConnection();
    const updatePostQuery = `
    UPDATE post
    SET caption = ?, user_id = ?, contact = ?, animal_type = ?
    WHERE post_id = ?
  `;
    await connection.query(updatePostQuery, [caption, user_id, likes, contact, post_id]);
    connection.release();
}

// Function to delete a post
async function deletePost(post_id) {
    const connection = await pool.getConnection();
    const deletePostQuery = 'DELETE FROM post WHERE post_id = ?';
    await connection.query(deletePostQuery, [post_id]);
    connection.release();
}

module.exports = {
    createPost,
    getAllPosts,
    getPostsByUserId,
    updatePost,
    deletePost,
};
