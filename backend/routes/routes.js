const express = require('express');
const userController = require('../controllers/userController');
const postController = require('../controllers/postController');
const animalTypeController = require('../controllers/animalController');
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
  const { user_id, username, email, profile_image } = req.body;
  await userController.createUser(user_id, username, email, profile_image);
  res.status(201).json({ message: 'User created successfully' });
});

// GET endpoint to fetch all users
router.get('/users', async (req, res) => {
  const users = await userController.getAllUsers();
  res.json(users);
});

router.get('/users/:user_id', async (req, res) => {
  const userId = req.params.user_id;
  if (!userId) {
    return res.status(400).json({ error: 'User ID is required' });
  }
  const user = await userController.getUserById(userId);
  if (user) {
    res.status(200).json(user); // User found, return user data
  } else {
    res.status(404).json({ error: 'User not found' });
  }
});

// PUT endpoint to update a user's details
router.put('/update_user/:user_id', async (req, res) => {
  const userId = req.params.user_id;
  const { user_id, username, email, profile_image } = req.body;
  await userController.updateUser(userId, username, email, profile_image);
  res.json({ message: 'User details updated successfully' });
});

/////////////////////////////////////////////
// POST endpoint to create a new post
router.post('/add_post', async (req, res) => {
  try {
    const { caption, user_id, likes, contact, image, animal_type } = req.body;
    await postController.createPost(caption, user_id, likes, contact, image, animal_type);
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

// Define a route to get posts by user_id
router.get('/posts/user/:user_id', async (req, res) => {
  try {
    const user_id = req.params.user_id; // Get the user_id from the URL parameters
    const posts = await postController.getPostsByUserId(user_id);

    res.status(200).json(posts); // Respond with the retrieved posts
  } catch (error) {
    console.error('Error fetching posts by user_id: ' + error.message);
    res.status(500).json({ error: 'An error occurred' });
  }
});


// PUT endpoint to update a post
router.put('/update_post/:post_id', async (req, res) => {
  try {
    const post_id = req.params.post_id;
    const { caption, user_id, likes, contact, animal_type } = req.body;
    await postController.updatePost(post_id, caption, user_id, likes, contact, animal_type);
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



////////////////////////////////////////////////////////////
// Route to add a new animal type
router.post('/add_animal_type', async (req, res) => {
  const { type_name, image } = req.body;
  const result = await animalTypeController.addAnimalType(type_name, image);

  if (result.message === 'Animal type already exists') {
    res.status(400).json(result);
  } else {
    res.status(201).json(result);
  }
});

// Route to get all animal types
router.get('/animal_types', async (req, res) => {
  const animalTypes = await animalTypeController.getAllAnimalTypes();
  res.json(animalTypes);
});

// Route to get an animal type by ID
router.get('/animal_types/:type_id', async (req, res) => {
  const { type_id } = req.params;
  const animalType = await animalTypeController.getAnimalTypeById(type_id);
  if (animalType) {
    res.json(animalType);
  } else {
    res.status(404).json({ error: 'Animal type not found' });
  }
});

// Route to delete an animal type by ID
router.delete('/animal_types/:type_id', async (req, res) => {
  const { type_id } = req.params;
  const success = await animalTypeController.deleteAnimalType(type_id);
  if (success) {
    res.json({ message: 'Animal type deleted' });
  } else {
    res.status(404).json({ error: 'Animal type not found' });
  }
});

// Route to update an animal type by ID
router.put('/animal_types/:type_id', async (req, res) => {
  const { type_id } = req.params;
  const { type_name, image } = req.body;
  const success = await animalTypeController.updateAnimalType(type_id, type_name, image);
  if (success) {
    res.json({ message: 'Animal type updated' });
  } else {
    res.status(404).json({ error: 'Animal type not found' });
  }
});


module.exports = router;

