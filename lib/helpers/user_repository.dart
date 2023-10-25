import 'package:adoptme/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  Future addUserInfo(UserModel userModel) async {
    await FirebaseFirestore.instance
        .collection('users')
        .add(
          userModel.toJson(),
        )
        .whenComplete(
          () => Get.snackbar(
            'Success',
            'Your account has been created',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: const Color(0xff232323),
            colorText: Colors.white,
          ),
        )
        .catchError((error, stackTrace) {
      Get.snackbar('Failed', 'Your account not create successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      print(error.toString());
    });
  }

  //TODO: make fetch user info

  Future<UserModel> getUserInfo(String email) async {
    final snapshot =
        await _db.collection('users').where('email', isEqualTo: email).get();
    final userData = snapshot.docs.map((e) => UserModel.fromSnapshot(e)).single;
    return userData;
  }

  /*Future<UserModel?> getUserInfo(String email) async {
    final QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .get();

    if (snapshot.docs.isNotEmpty) {
      // Assuming there's only one user with the provided email
      final userData = UserModel.fromSnapshot(snapshot.docs.first);
      return userData;
    } else {
      return null; // User not found with the provided email
    }
  }*/


  Future<List<UserModel>> allUsers(String email) async {
    final snapshot =
        await _db.collection('users').get();
    final userData =
        snapshot.docs.map((e) => UserModel.fromSnapshot(e)).toList();
    return userData;
  }
}
