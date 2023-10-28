import 'dart:convert';
import 'dart:io';

import 'package:adoptme/services/post_service.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class PostLogic with ChangeNotifier {
  PostService postService = PostService();
  bool _isPosting = false; // Initialize as false

  bool get isPosting => _isPosting;
  String? _imageUrl;

  Future<void> addPost({
    required String userId,
    required String caption,
    required String contact,
    required String image,
    required String animalType,
  }) async {
    try {
      // Start the loading indicator
      _isPosting = true;
      notifyListeners();

      await postService.addPost(
          userId: userId,
          caption: caption,
          contact: contact,
          like: '0',
          image: image,
          animalType: animalType);

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

  static Future<String?> uploadImageToImgBB({
    required File? image,
    required void Function(String) onResult,
    required void Function(String) onReject,
  }) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('https://api.imgbb.com/1/upload'),
    );

    request.fields['key'] = '7c22aa68a489e655f2742fd476d0d56f';

    final fileStream = http.ByteStream(image!.openRead());
    final length = await image.length();

    final multipartFile = http.MultipartFile(
      'image',
      fileStream,
      length,
      filename: 'image.jpg',
    );

    request.files.add(multipartFile);

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final displayUrl = data['data']['display_url'];
        onResult(displayUrl);
      } else {
        onReject(response.body);
      }
    } catch (error) {
      onReject(error.toString());
    }
    return null;
  }

  Future<void> handlePostTap({
    required String userId,
    required String caption,
    required String contact,
    required File? image,
    required String animalType,
    required Function(String?) onResult,
    required Function(dynamic) onReject,
  }) async {
    try {
      await uploadImageToImgBB(
        image: image,
        onResult: (displayUrl) async {
          print('Image uploaded successfully. Display URL: $displayUrl');
          _imageUrl = displayUrl;
          if (_imageUrl != null) {
            try {
              // Call the addPost method
              await addPost(
                userId: userId,
                caption: caption,
                contact: contact,
                image: _imageUrl!,
                animalType: animalType,
              );
              print(
                  'Post addition successful $userId $caption, $contact, $animalType');
              onResult(_imageUrl); // Invoke the onResult callback with the imageUrl
            } catch (e) {
              print('Error adding post: $e');
              onReject(e); // Invoke the onReject callback with the error
            }
          } else {
            // Handle the case when imageUrl is null (show an error message or take appropriate action)
            print('Error: imageUrl is null');
            onReject('Error: imageUrl is null'); // Invoke the onReject callback with an error message
          }
        },
        onReject: (error) {
          // Handle the error, e.g., display an error message
          print('Image upload failed. Error: $error');
          onReject(error); // Invoke the onReject callback with the error
        },
      );
    } catch (e) {
      onReject(e); // Invoke the onReject callback with the error
    }
  }
}
