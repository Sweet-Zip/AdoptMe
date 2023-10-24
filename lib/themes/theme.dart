import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: const ColorScheme.light(
      background: Colors.white,
      primary: Color(0xfff26a8d),
      secondary: Colors.grey,
      tertiary: Color(0xff232323)),
);

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: const ColorScheme.dark(
    background: Color(0xff232323),
    primary: Color(0xfff26a8d),
    secondary: Colors.grey,
    tertiary: Color(0xff232323),
  ),
);
