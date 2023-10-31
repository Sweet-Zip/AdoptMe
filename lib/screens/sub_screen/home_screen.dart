import 'package:adoptme/logic/post_logic.dart';
import 'package:adoptme/logic/user_logic.dart';
import 'package:adoptme/models/post_model.dart';
import 'package:adoptme/screens/sub_screen/view_profile.dart';
import 'package:adoptme/services/post_service.dart';
import 'package:adoptme/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

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
  PostLogic postLogic = PostLogic();

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
      debugPrint(error);
      return const Center(child: Text("Something went wrong"));
    } else {
      List<PostModel>? postList = context.watch<PostLogic>().postList;
      return Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade900,
        ),
        child: _buildPageView(postList),
      );
    }
  }

  Widget _buildPageView(List<PostModel>? items) {
    if (items == null) {
      return const Center(
        child: Text("Something still went Wrong"),
      );
    }
    return Container(
      color: Theme.of(context).colorScheme.tertiary,
      child: PageView.builder(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemCount: items.length,
        itemBuilder: (context, index) {
          return _buildPageItem(items[index]);
        },
      ),
    );
  }

  Widget _buildPageItem(PostModel item) {
    userLogic.readUserById(id: item.userId);
    userLogic.getUserById(item.userId);

    return Stack(
      children: [
        Positioned.fill(
          child: Image.network(
            item.image,
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
                  print(item.userId);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ViewProfile(uid: item.userId),
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
                  userLogic.username ?? 'Loading...',
                  style: TextStyle(fontSize: 20, color: Colors.grey.shade300),
                ),
                const SizedBox(height: 10),
                Text(
                  item.caption,
                  style: TextStyle(color: Colors.grey.shade400),
                ),
                const SizedBox(height: 10),
                InkWell(
                  onTap: () {
                    _launchPhoneDialer(item.contact);
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
