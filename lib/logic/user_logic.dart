import 'package:adoptme/services/post_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';
import '../screens/item_main_screen.dart';
import '../screens/login_screen.dart';
import '../services/user_service.dart';

class UserLogic with ChangeNotifier {
  bool _isAuthenticated = false; // Initialize it as false by default

  bool get isAuthenticated => _isAuthenticated;

  List<UserModel>? _userList;

  List<UserModel>? get userList => _userList;

  String? _authenticatedId;

  String? get authenticatedId => _authenticatedId;

  String? _username;

  String? get username => _username;

  String? _email;

  String? get email => _email;

  String? _profileImage;

  String? get profileImage => _profileImage;

  void setAuthenticated(bool value) {
    _isAuthenticated = value;
    notifyListeners(); // Notify listeners to trigger updates
  }

  set authenticatedId(String? id) {
    _authenticatedId = id;
    notifyListeners(); // Notify listeners to trigger updates
  }

  set username(String? username) {
    _username = username;
    notifyListeners(); // Notify listeners to trigger updates
  }

  set email(String? email) {
    _email = email;
    notifyListeners(); // Notify listeners to trigger updates
  }

  set profileImage(String? profileImage) {
    _profileImage = profileImage;
    notifyListeners(); // Notify listeners to trigger updates
  }

  UserService userService = UserService();

  Future<void> registerUser(
      {required BuildContext context,
      required userID,
      required username,
      required email,
      required profileImage}) async {
    try {
      await UserService().registerUser(userID, username, email, profileImage);
      // If you want to perform any actions or update the UI after registration, do it here.
      // For example, you can navigate to a different screen or show a success message.
      print('Registration successful');
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ),
      );
    } catch (e) {
      // Handle any errors that might occur when calling the UserService's registerUser function.
      print('Error during registration: $e');
    }
  }

  Future<void> readUserById({
    required String id,
  }) async {
    print('Authenticated id: $id');

    try {
      await userService.readUserID(
        id: id,
        onResult: (List<UserModel>? users) {
          if (users != null && users.isNotEmpty) {
            // Create a new UserModel object with the data from the API
            UserModel newUser = users[0];

            // Update the UserModel with the new data
            authenticatedId = newUser.userId;
            username = newUser.username;
            email = newUser.email;
            profileImage = newUser.profileImage;

            print('Query was successful. Usernames: $username');
          } else {
            print('No users found or an error occurred.');
          }
        },
        onReject: (String? error) {
          if (error != null) {
            print('Error: $error');
          } else {
            print('An unknown error occurred.');
          }
        },
      );
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> loadViewUser({
    required String uid,
    String? profileImage,
    String? username,
    required Function(bool isLoading, String profileUrl, String username, List<dynamic> postsData) updateState,
  }) async {
    readUserById(id: uid);
    profileImage ??= '';
    username ??= '';

    Future<List<dynamic>> postsFuture = PostService().getPostsByUserId(uid);

    // Fetch the user data and posts data simultaneously
    List<dynamic> postsData = await postsFuture;

    // Check if the user data and posts data are available
    if (profileImage == null || username == null || postsData == null) {
      // Data is not available, show loading
      updateState(true, profileImage!, username!, []);
    } else {
      // Data is available, update the UI with the fetched data
      updateState(false, profileImage!, username!, postsData);
    }
  }
}
