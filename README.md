# AdoptMe

Welcome to AdoptMe! This document provides instructions on how to set up and run the app. Please follow the steps below:

## Prerequisites
- Xampp or MaMp should be installed on your machine.
- VSCode or any other code editor should be installed.
- Flutter project should be set up.

## Getting Started

1. Start the server:
   - Open Xampp or MaMp.
   - Start the server.

2. Set up the backend:
   - Open the "backend" folder in VSCode or your preferred code editor.
   - Run the following command in the terminal: `node app.js`

3. Configure the Flutter project:
   - Open the Flutter project in your preferred code editor.
   - Navigate to the `/lib/services/` folder.
   - Open each file in the "service" folder.
   - Look for the IP address configuration.
   - In cmd or terminal, run the command `ipconfig` to obtain your IPv4 address.
   - Copy your IP address.
   - Paste the IP address into each file in the "service" folder.
   
   Example code snippet:
   
   ```dart
   // lib/services/service_file.dart
   
   // Replace 'YOUR_IP_ADDRESS' with your actual IP address
   String apiUrl = 'http://YOUR_IP_ADDRESS:3000/api';
