import 'dart:async';

import 'package:adoptme/logic/post_logic.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import 'item_main_screen.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    Future.delayed(
      const Duration(seconds: 3),
      () async {
        FirebaseAuth.instance.authStateChanges().listen((user) {
          if (user == null) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => ItemMainScreen(),
              ),
            );
          } else {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const ItemMainScreen(),
              ),
            );
          }
        });

        await context.read<PostLogic>().readAllPost();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          FlutterLogo(size: MediaQuery.of(context).size.height),
          SpinKitChasingDots(
            itemBuilder: (BuildContext context, int index) {
              return DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: index.isEven
                      ? const Color(0xffff1b7d)
                      : const Color(0xff54e8f3),
                ),
              );
            },
          ),
          SpinKitSpinningLines(
            // color: Colors.white,
            size: 50.0,
            color: Theme.of(context).colorScheme.primary,
          ),
          SpinKitSpinningLines(
            color: Colors.white,
            size: 50.0,
            controller: AnimationController(
                vsync: this, duration: const Duration(milliseconds: 1200)),
          ),
        ],
      ),
    );
  }
}
