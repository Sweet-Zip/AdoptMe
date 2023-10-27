import 'package:adoptme/logic/user_logic.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../components/custom_snackbar.dart';

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
}
