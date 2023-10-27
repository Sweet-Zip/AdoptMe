import 'package:adoptme/services/post_service.dart';
import 'package:flutter/material.dart';

class PostLogic with ChangeNotifier {
  PostService postService = PostService();
  bool _isPosting = false; // Initialize as false

  bool get isPosting => _isPosting;

  Future<void> addPost({
    required String userId,
    required String caption,
    required String contact,
    required String image,
  }) async {
    try {
      // Start the loading indicator
      _isPosting = true;
      notifyListeners();

      await postService.addPost(
        userId: userId,
        caption: caption,
        contact: contact,
        image: image,
      );

      // If the posting is successful, you can navigate to a different screen or perform other actions here.

      // Stop the loading indicator
      _isPosting = false;
      notifyListeners();
    } catch (e) {
      // Handle the error
      print('Error adding post: $e');

      // Stop the loading indicator even on error
      _isPosting = false;
      notifyListeners();

      // Rethrow the exception to propagate it
      rethrow;
    }
  }
}
