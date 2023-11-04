import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/post_model.dart';

class PostService with ChangeNotifier {
  final String _baseUrl = 'http://172.21.3.8:3000/api';

  /*Future<List<PostModel>> getAllPosts() async {
    try {
      final url = Uri.parse('$_baseUrl/posts'); // Replace with your API endpoint
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final List<PostModel> posts = data.map((item) => PostModel.fromJson(item)).toList();
        return posts;
      } else {
        // Handle other status codes as needed
        print('Failed to fetch posts: Unexpected Status Code ${response.statusCode}');
        return [];
      }
    } catch (e) {
      // Handle network errors
      print('Network error: $e');
      return [];
    }
  }*/

  static Future getAllPosts({
    required void Function(List<PostModel>?) onResult,
    required void Function(String?) onReject,
  }) async {
    try {
      http.Response res = await http.get(
        Uri.parse('http://172.21.3.8:3000/api/posts/'),
      );
      onResult(await compute(_convertData, res.body));
      onReject(null);
    } catch (e) {
      onReject("Error: ${e.toString()}");
    }
  }

  static List<PostModel> _convertData(String data) {
    List<PostModel> list = postModelFromJson(data);
    return list;
  }

  // Method to create a new post
  Future<void> addPost({
    required String userId,
    required String caption,
    required String contact,
    required String like,
    required String image,
    required String animalType,
  }) async {
    try {
      final url = Uri.parse('$_baseUrl/add_post'); // Replace with your API endpoint
      final response = await http.post(
        url,
        body: json.encode({
          'user_id': userId,
          'caption': caption,
          'contact': contact,
          'likes': like,
          'image': image,
          'animal_type': animalType
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

  static Future<List<dynamic>> getPostsByUserId(String userId) async {
    final url = 'http://172.21.3.8:3000/api/posts/user/$userId';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data;
    } else {
      throw Exception('Failed to fetch posts');
    }
  }

// Add more methods for fetching, updating, or deleting posts here.
}
