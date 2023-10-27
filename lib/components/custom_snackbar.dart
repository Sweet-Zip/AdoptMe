import 'package:flutter/material.dart';

class CustomSnackBar extends SnackBar {
  CustomSnackBar({super.key, required String errorText})
      : super(
    content: Text(
      errorText,
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
    ),
    backgroundColor: Colors.redAccent,
  );
}
