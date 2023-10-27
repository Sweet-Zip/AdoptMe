import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PostService with ChangeNotifier {
  final String _baseUrl = 'http://192.168.56.1:3000/api';

  // Method to create a new post
  Future<void> addPost({
    required String userId,
    required String caption,
    required String contact,
    required String image,
  }) async {
    try {
      final url = Uri.parse('$_baseUrl/add_post'); // Replace with your API endpoint
      final response = await http.post(
        url,
        body: json.encode({
          'user_id': userId,
          'caption': caption,
          'contact': contact,
          'image': image,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 201) {
        // Post added successfully
        // You can navigate to a different screen or perform other actions if needed.
        print('Post added successfully');
      } else {
        // Handle other status codes as needed
        print('Post addition failed: Unexpected Status Code ${response.statusCode}');
      }
    } catch (e) {
      // Handle network errors
      print('Network error: $e');
    }
  }

// Add more methods for fetching, updating, or deleting posts here.
}
