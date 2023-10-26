import 'package:adoptme/logic/post_logic.dart';
import 'package:adoptme/models/postModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isFavorite = false;
  bool isLike = false;
  String phoneNumber = '1234567890';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    String? error = context.watch<PostLogic>().error;
    if (error != null) {
      return Center(child: Text("Error Fetching Data"));
    } else {
      List<Post>? list = context.watch<PostLogic>().postList;

      return Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade900,
        ),
        child: _buildPageViewBuilder(list),
      );
    }
  }

  Widget _buildPageViewBuilder(List<Post>? list) {
    if (list == null) {
      return Center(
        child: Text("Empty"),
      );
    }
    return PageView.builder(
      physics: BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        return _buildPageItem(list[index]);
      },
      scrollDirection: Axis.vertical,
      itemCount: list.length,
    );
  }

  Widget _buildPageItem(Post post) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.network(
            post.imageLink,
            fit: BoxFit.fitHeight,
          ),
        ),
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black87])),
          ),
        ),
        Positioned(
          right: 25,
          bottom: 25,
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const ProfileScreen(),
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
              Text(
                post.like.toString(),
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
                  post.title,
                  style: TextStyle(fontSize: 20, color: Colors.grey.shade300),
                ),
                const SizedBox(height: 10),
                Text(
                  post.caption,
                  style: TextStyle(color: Colors.grey.shade400),
                ),
                const SizedBox(height: 10),
                InkWell(
                  onTap: () {
                    _launchPhoneDialer();
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

  void _launchPhoneDialer() async {
    Uri url = Uri(scheme: "tel", path: phoneNumber);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      print("Can't open dial pad.");
    }
  }
}
