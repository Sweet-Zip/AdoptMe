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
      Get.snackbar('Failed', 'Your account no create successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      print(error.toString());
    });
  }
}
