const express = require('express');
const userRoutes = require('./routes/routes'); // Import user routes
const createTable = require('./createTable'); // Import table creation function

const app = express();
app.use(express.json());

// Use the user routes
app.use('/api', userRoutes);

// Create the "users" table (ensure it exists before starting the server)
createTable();

// Start the server
const port = process.env.PORT || 3000;
app.listen(port, () => {
  console.log(`Server is running on port ${port}`);
});
