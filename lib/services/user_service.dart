import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/user_model.dart';

class UserService {
  static Future<void> loginUser(String email, String password) async {
    const baseUrl =
        'http://192.168.50.115:3000'; // Replace with your server's base URL
    final endpoint =
        '/users?email=$email&password=$password'; // Replace with the actual endpoint for authentication

    try {
      final response = await http.get(Uri.parse(baseUrl + endpoint));

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
      String username, String email, String password) async {
    final url = Uri.parse(
        'http://192.168.50.115:3000/users'); // Replace with your JSON server URL

    try {
      final response = await http.post(
        url,
        body: json.encode(
            {'username': username, 'email': email, 'password': password}),
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

  static Future readUser({
    required String email,
    required String password,
    required void Function(List<UserModel>?) onResult,
    required void Function(String?) onReject,
  }) async {
    try {
      http.Response res = await http.get(Uri.parse(
          "http://192.168.50.115:3000/users?email=$email&password=$password"));
      onResult(await compute(_convertData, res.body));
      onReject(null);
    } catch (e) {
      onReject("Error: ${e.toString()}");
    }
  }

  static Future readUserID({
    required int id,
    required void Function(List<UserModel>?) onResult,
    required void Function(String?) onReject,
  }) async {
    try {
      http.Response res =
          await http.get(Uri.parse("http://192.168.50.115:3000/users?id=$id"));
      onResult(await compute(_convertData, res.body));
      onReject(null);
    } catch (e) {
      onReject("Error: ${e.toString()}");
    }
  }

  static List<UserModel> _convertData(String data) {
    List<UserModel> list = userModelFromJson(data);
    return list;
  }
}
