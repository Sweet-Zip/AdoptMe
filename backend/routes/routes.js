const express = require('express');
const userController = require('../controllers/userController');
const postController = require('../controllers/postController');
const multer = require('multer');
const router = express.Router();

// Set up the storage for uploaded images
const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    // Set the destination folder where uploaded images will be stored
    cb(null, 'uploads/'); // Create the 'uploads' folder in your project
  },
  filename: (req, file, cb) => {
    // Define the file name and extension
    const fileName = Date.now() + '-' + file.originalname;
    cb(null, fileName);
  },
});

const upload = multer({ storage });

// POST endpoint to create a new user
router.post('/add_user', async (req, res) => {
  const { username, email, user_image } = req.body;
  await userController.createUser(username, email, user_image);
  res.status(201).json({ message: 'User created successfully' });
});

// GET endpoint to fetch all users
router.get('/users', async (req, res) => {
  const users = await userController.getAllUsers();
  res.json(users);
});

// PUT endpoint to update a user's details
router.put('/update_user/:user_id', async (req, res) => {
  const userId = req.params.user_id;
  const { username, email, user_image } = req.body;
  await userController.updateUser(userId, username, email, user_image);
  res.json({ message: 'User details updated successfully' });
});

/////////////////////////////////////////////
// POST endpoint to create a new post
router.post('/add_post', async (req, res) => {
  try {
    const { caption, user_id, likes, contact, image } = req.body; // 'image' should be a URL
    await postController.createPost(caption, user_id, likes, contact, image);
    res.status(201).json({ message: 'Post created successfully' });
  } catch (error) {
    console.error('Error creating post: ' + error.message);
    res.status(500).json({ error: 'An error occurred' });
  }
});

// GET endpoint to fetch all posts
router.get('/posts', async (req, res) => {
  try {
    const posts = await postController.getAllPosts();
    res.json(posts);
  } catch (error) {
    console.error('Error fetching posts: ' + error.message);
    res.status(500).json({ error: 'An error occurred' });
  }
});

// PUT endpoint to update a post
router.put('/update_post/:post_id', async (req, res) => {
  try {
    const post_id = req.params.post_id;
    const { caption, user_id, likes, contact } = req.body;
    await postController.updatePost(post_id, caption, user_id, likes, contact);
    res.json({ message: 'Post updated successfully' });
  } catch (error) {
    console.error('Error updating post: ' + error.message);
    res.status(500).json({ error: 'An error occurred' });
  }
});

// DELETE endpoint to delete a post
router.delete('delete_post/:post_id', async (req, res) => {
  try {
    const post_id = req.params.post_id;
    await postController.deletePost(post_id);
    res.json({ message: 'Post deleted successfully' });
  } catch (error) {
    console.error('Error deleting post: ' + error.message);
    res.status(500).json({ error: 'An error occurred' });
  }
});


module.exports = router;
