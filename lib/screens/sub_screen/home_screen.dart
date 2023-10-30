import 'dart:convert';

import 'package:adoptme/logic/user_logic.dart';
import 'package:adoptme/models/post_model.dart';
import 'package:adoptme/screens/sub_screen/view_profile.dart';
import 'package:adoptme/services/post_service.dart';
import 'package:adoptme/services/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isFavorite = false;
  bool isLike = false;
  final String? _phoneNumber = null;
  PostService postService = PostService();
  UserService userService = UserService();
  UserLogic userLogic = UserLogic();
  String? username;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
      ),
      child: _buildPageViewBuilder(),
    );
  }

  Widget _buildPageViewBuilder() {
    return FutureBuilder<List<PostModel>>(
      future: postService.getAllPosts(), // Fetch posts asynchronously
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // While waiting for data, you can display a loading indicator.
          return const CircularProgressIndicator(); // or any other loading widget
        } else if (snapshot.hasError) {
          // Handle errors if the data fetch fails.
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          // Handle the case where no data is available.
          return Center(
              child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/app_logo.png',
                  width: 200,
                  color: Colors.red,
                  fit: BoxFit.fitWidth,
                ),
                const SizedBox(height: 10),
                const Text(
                  '404 Error Not Found! Please Comeback later',
                  style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 25),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ));
        } else {
          final List<PostModel>? postDataList = snapshot.data;
          return PageView.builder(
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              if (index < postDataList.length) {
                return FutureBuilder<String>(
                  future: userService.fetchUserData(postDataList[index].userId),
                  builder: (context, userSnapshot) {
                    if (userSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      // While waiting for user data, you can display a loading indicator.
                      return const CircularProgressIndicator();
                    } else if (userSnapshot.hasError) {
                      // Handle errors if the user data fetch fails.
                      return Text('User Error: ${userSnapshot.error}');
                    } else {
                      final String? username = userSnapshot.data;
                      return _buildPageItem(
                        postDataList[index].userId,
                        postDataList[index].image,
                        postDataList[index].caption,
                        username ?? '',
                        postDataList[index].contact,
                      );
                    }
                  },
                );
              } else {
                return Container();
              }
            },
            scrollDirection: Axis.vertical,
            itemCount: postDataList!.length,
          );
        }
      },
    );
  }

  Widget _buildPageItem(String uid, String imageUrl, String caption,
      String username, String phoneNumber) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.network(
            imageUrl,
            fit: BoxFit.fitWidth,
            loadingBuilder: (BuildContext context, Widget child,
                ImageChunkEvent? loadingProgress) {
              if (loadingProgress == null) {
                return child; // If the image is fully loaded, display it
              } else {
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                );
              }
            },
          ),
        ),
        Positioned(
          right: 25,
          bottom: 25,
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  print(uid);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ViewProfile(uid: uid),
                    ),
                  );
                },
                child: ClipOval(
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Center(
                        child: ClipOval(
                          child: Image.network(
                            'https://dl.memuplay.com/new_market/img/com.vicman.newprofilepic.icon.2022-06-07-21-33-07.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 25),
              InkWell(
                onTap: () {
                  setState(() {
                    isLike = !isLike;
                  });
                },
                child: Icon(
                  isLike
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                  color: isLike ? Colors.red : Colors.white,
                ),
              ),
              const Text(
                '1',
                style: TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 25),
              InkWell(
                onTap: () {
                  setState(() {
                    isFavorite = !isFavorite;
                  });
                },
                child: Icon(
                  isFavorite ? Icons.bookmark : Icons.bookmark_add_outlined,
                  color: isFavorite ? Colors.amber : Colors.white,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: 25,
          bottom: 25,
          child: SizedBox(
            width: 300,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  username,
                  style: TextStyle(fontSize: 20, color: Colors.grey.shade300),
                ),
                const SizedBox(height: 10),
                Text(
                  caption,
                  style: TextStyle(color: Colors.grey.shade400),
                ),
                const SizedBox(height: 10),
                InkWell(
                  onTap: () {
                    _launchPhoneDialer(phoneNumber);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 7),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: const Text(
                      "Contact Now",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _launchPhoneDialer(String phoneNumber) async {
    Uri url = Uri(scheme: "tel", path: phoneNumber);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      print("Can't open dial pad.");
    }
  }
}
