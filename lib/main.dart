import 'package:adoptme/logic/animal_type_logic.dart';
import 'package:adoptme/logic/post_logic.dart';
import 'package:adoptme/services/user_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'logic/user_logic.dart';
import 'screens/splash_screen.dart';
import 'themes/themeProvider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
/*  Get.put<UserRepository>();*/
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => UserLogic()),
        ChangeNotifierProvider(create: (context) => PostLogic()),
        ChangeNotifierProvider(create: (context) => AnimalTypeLogic()),
        ChangeNotifierProvider(create: (context) => UserService()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: Provider.of<ThemeProvider>(context).themeData,
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
