import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/user_model.dart';

class UserService with ChangeNotifier {
  List<UserModel>? _userList;

  List<UserModel>? get userList => _userList;

  set userList(List<UserModel>? userList) {
    _userList = userList;
    notifyListeners();
  }

  final String _baseUrl = 'http://172.21.3.8:3000/api';

  Future<void> loginUser(String email, String password) async {
    final endpoint =
        '/users?email=$email&password=$password'; // Replace with the actual endpoint for authentication

    try {
      final response = await http.get(Uri.parse(_baseUrl + endpoint));

      if (response.statusCode == 200) {
        // Authentication successful
        // You can navigate to the next screen or perform the desired action.
        print('Authentication successful');
      } else {
        // Authentication failed, display an error message.
        print('Authentication failed');
      }
    } catch (e) {
      // Handle network errors
      print('Network error: $e');
    }
  }

  Future<void> registerUser(
      String userId, String username, String email, String profileImage) async {
    final url =
        Uri.parse('$_baseUrl/add_user'); // Replace with your JSON server URL

    try {
      final response = await http.post(
        url,
        body: json.encode({
          'user_id': userId,
          'username': username,
          'email': email,
          'profile_image': profileImage
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 500) {
        // Authentication successful
        // You can navigate to the next screen or perform the desired action.
        print('Authentication successful');
      } else {
        // Authentication failed, display an error message.
        print('Authentication failed');
      }
    } catch (e) {
      // Handle network errors
      print('Network error: $e');
    }
  }

  Future readUser({
    required String email,
    required String password,
    required void Function(List<UserModel>?) onResult,
    required void Function(String?) onReject,
  }) async {
    try {
      http.Response res = await http
          .get(Uri.parse('$_baseUrl/users?email=$email&password=$password'));
      onResult(await compute(_convertData, res.body));
      onReject(null);
    } catch (e) {
      onReject("Error: ${e.toString()}");
    }
  }

  /*Future readUserID({
    required String id,
    required void Function(List<UserModel>?) onResult,
    required void Function(String?) onReject,
  }) async {
    try {
      final response = await http.get(Uri.parse("$_baseUrl/users/$id"));
      if (response.statusCode == 200) {
        final responseBody = response.body; // Extract the response body
        final jsonData = json.decode(responseBody); // Parse the JSON data
        _userList = _convertData(jsonData); // Overwrite the existing _userList
        onResult(_userList); // Return the updated _userList
      } else {
        onReject("HTTP Error: ${response.statusCode}");
      }
    } catch (e) {
      onReject("Error: ${e.toString()}");
    }
  }*/

  Future<void> readUserID({
    required String id,
    required void Function(List<UserModel>?) onResult,
    required void Function(String?) onReject,
  }) async {
    try {
      final response = await http.get(Uri.parse("$_baseUrl/users/$id"));
      if (response.statusCode == 200) {
        final responseBody = response.body; // Extract the response body
        final jsonData = json.decode(responseBody); // Parse the JSON data
        final userModel =
            UserModel.fromJson(jsonData); // Convert JSON to UserModel
        _userList = [userModel]; // Update the _userList with the new UserModel
        onResult(_userList); // Return the updated _userList
      } else {
        onReject("HTTP Error: ${response.statusCode}");
      }
    } catch (e) {
      onReject("Error: ${e.toString()}");
    }
  }

  Future<String> fetchUserData(String userId) async {
    final url = '$_baseUrl/users/$userId';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final userData = json.decode(response.body);
      final username = userData['username'];
      return username;
    } else if (response.statusCode == 404) {
      // User not found
      print('User not found');
    } else {
      // Handle other error cases
      print('Error: ${response.statusCode}');
    }
    return ''; // Return an empty string if there was an error
  }

  List<UserModel> _convertData(String data) {
    List<UserModel> list = userModelFromJson(data);
    return list;
  }
}
