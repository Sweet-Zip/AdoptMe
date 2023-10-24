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

  int? _authenticatedId;

  int? get authenticatedId => _authenticatedId;

  String? _authenticatedUsername;

  String? get authenticatedUsername => _authenticatedUsername;

  String? _password;

  String? get password => _password;

  String? _email;

  String? get email => _email;

  void setAuthenticated(bool value) {
    _isAuthenticated = value;
    notifyListeners(); // Notify listeners to trigger updates
  }

  set authenticatedId(int? id) {
    _authenticatedId = id;
    notifyListeners(); // Notify listeners to trigger updates
  }

  set authenticatedUsername(String? username) {
    _authenticatedUsername = username;
    notifyListeners(); // Notify listeners to trigger updates
  }

  set email(String? email) {
    _email = email;
    notifyListeners(); // Notify listeners to trigger updates
  }

  set password(String? password) {
    _password = password;
    notifyListeners(); // Notify listeners to trigger updates
  }

  Future<void> loginUser({
    required BuildContext context, // Add a BuildContext parameter
    required String email,
    required String password,
  }) async {
    await UserService.readUser(
      email: email,
      password: password,
      onResult: (List<UserModel>? users) async {
        if (users != null && users.isNotEmpty) {
          // Authentication successful, update user list
          print('First user: ${users[0].username}');

          _userList = users;
          // _authenticatedId = users[0].id;
          _authenticatedUsername = users[0].username;
          _password = users[0].password;
          _email = users[0].email;
          print('Authenticated name: $_authenticatedUsername');
          userId(id: _authenticatedId ?? 0);
          notifyListeners();

          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool('authenticated', true);
          saveUserData();

          // Navigate to the new screen upon successful authentication
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) =>
                  ItemMainScreen(/*authenticatedId: _authenticatedId*/),
            ),
          );
        } else {
          // Authentication failed, handle the error
          print('Authentication failed');
        }
      },
      onReject: (String? error) {
        // Handle network or server errors
        if (error != null) {
          print('Network error: $error');
        }
      },
    );
  }

  Future<void> loginUserWithNewId({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    await UserService.readUser(
      email: email,
      password: password,
      onResult: (List<UserModel>? users) async {
        if (users != null && users.isNotEmpty) {
          // Authentication successful, update user list
          _userList = users;
          // _authenticatedId = users[0].id; // Use the new user ID
          _authenticatedUsername = users[0].username;
          _password = users[0].password;
          _email = users[0].email;
          notifyListeners();

          final prefs = await SharedPreferences.getInstance();
          prefs.setBool('authenticated', true);
          saveUserData();
          userId(id: _authenticatedId ?? 0);
          print('Authentication username: $_authenticatedUsername');
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) =>
                  ItemMainScreen(/*authenticatedId: _authenticatedId*/),
            ),
          );
        } else {
          // Authentication failed, handle the error
          print('Authentication failed');
        }
      },
      onReject: (String? error) {
        // Handle network or server errors
        if (error != null) {
          print('Network error: $error');
        }
      },
    );
  }

  Future<void> saveUserData() async {
    final prefs = await SharedPreferences.getInstance();
    if (_authenticatedUsername != null) {
      prefs.setString('username', _authenticatedUsername!);
    }
    if (_authenticatedId != null) {
      prefs.setInt('userId', _authenticatedId!);
    }
    if (_password != null) {
      prefs.setString('password', _password!);
    }
    if (_email != null) {
      prefs.setString('email', _email!);
    }
  }

  Future<void> loadUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _authenticatedUsername = prefs.getString('username');
      _authenticatedId = prefs.getInt('userId') ?? 0;
      _password = prefs.getString('password');
      _email = prefs.getString('email');
      print('Loaded username: $_authenticatedUsername');
      print('Loaded user ID: $_authenticatedId');
      print('Loaded password: $_password');
      print('Loaded email: $_email');
    } catch (e) {
      print('Error loading data from SharedPreferences: $e');
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('username');
    prefs.remove('userId');
    prefs.remove('password');
    prefs.remove('email');
    // You can also remove any other user-related data here
  }

  Future<void> userId({
    required int id,
  }) async {
    await UserService.readUserID(
      id: id,
      onResult: (List<UserModel>? users) async {
        if (users != null && users.isNotEmpty && id > 0 && id <= users.length) {
          // Update the authenticatedUsername if a user with the specified ID is found
          final prefs = await SharedPreferences.getInstance();
          final user = users[id - 1];
          _authenticatedUsername = user.username;
          _password = user.password;
          _email = user.email;
          print('Authenticated id: $_authenticatedUsername');
          print('Authenticated pass: $_password');
          print('Authenticated email: $_email');
        }
      },
      onReject: (String? error) {
        // Handle network or server errors
        if (error != null) {
          print('Network error: $error');
        }
      },
    );
  }

  Future<void> registerUser(
      {required BuildContext context,
        required username,
        required email,
        required password}) async {
    try {
      await UserService().registerUser(username, email, password);

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

// Future<void> userId({
//   required int id,
// }) async {
//   if (userList != null && id != null && id > 0 && userList!.length >= id) {
//     final user = userList[id - 1];
//     authenticatedUsername = user.username;
//     password = user.password;
//     email = user.email;
//     print('Authenticated id: $id');
//   }
// }
}
