import 'package:adoptme/components/loading.dart';
import 'package:adoptme/logic/user_logic.dart';
import 'package:adoptme/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../components/custom_snackbar.dart';
import '../screens/sub_screen/profile_screen.dart';

class AuthHelper {
  UserLogic userLogic = UserLogic();

  static Future<User?> loginEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential credential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = FirebaseAuth.instance.currentUser;
      String uid = user!.uid;
      print('Login successful. User UID: $uid');
      return credential.user;
    } catch (e) {
      print("AuthHelper login error: ${e.toString()}");
      return null;
    }
  }

  Future<User?> registerEmailAndPassword(
      BuildContext context, String email, String password, username) async {
    try {
      UserCredential credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = FirebaseAuth.instance.currentUser;
      String uid = user!.uid;
      await userLogic.registerUser(
        context: context,
        userID: uid,
        username: username,
        email: email,
        profileImage: 'Null',
      );

      print('Registration successful. User UID: $uid');
      return credential.user;
    } catch (e) {
      print("AuthHelper login error: ${e.toString()}");
      if (e is FirebaseAuthException && e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(
          CustomSnackBar(errorText: 'Email Already in use'),
        );
      }
      return null;
    }
  }

  static Future<void> changePassword(
      String currentPassword, String newPassword, BuildContext context) async {
    try {
      Loading(context: context).showLoading();
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        AuthCredential credential = EmailAuthProvider.credential(
          email: user.email!,
          password: currentPassword,
        );
        await user.reauthenticateWithCredential(credential);

        // Change the password
        await user.updatePassword(newPassword);
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Success'),
              content: const Text('Password changed successfully.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Loading(context: context).dismissLoading();
                    Navigator.of(context).pop();
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const ProfileScreen(),
                      ),
                    );
                    ;
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        print('User not found');
      }
    } catch (e) {
      print('Error changing password: $e');
      String errorMessage = 'An error occurred while changing the password.';
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text(errorMessage),
            actions: [
              TextButton(
                onPressed: () {
                  Loading(context: context).dismissLoading();
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  static Future<void> resetPassword(String email, BuildContext context) async {
    try {
      Loading(context: context).showLoading();
      final user = await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
      if (user.isEmpty) {
        // Email not found in Firebase
        throw FirebaseAuthException(code: 'user-not-found');
      }
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      Navigator.of(context).pop(); // Close the loading indicator

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Success'),
            content: const Text('Password reset email sent successfully.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(),
                    ),
                  );
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      String errorMessage =
          'An error occurred while sending the password reset email.';
      if (e is FirebaseAuthException && e.code == 'user-not-found') {
        errorMessage =
        'Email not found. Please check the email address and try again.';
      }
      Navigator.of(context).pop(); // Close the loading indicator

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text(errorMessage),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
}
