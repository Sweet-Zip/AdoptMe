import 'package:flutter/material.dart';
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
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
      ),
      child: _buildPageViewBuilder(),
    );
  }

  Widget _buildPageViewBuilder() {
    return PageView.builder(
      physics: BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        return _buildPageItem();
      },
      scrollDirection: Axis.vertical,
      itemCount: 5,
    );
  }

  Widget _buildPageItem() {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.network(
            'https://images.unsplash.com/photo-1596457107504-7f8ba467b685?auto=format&fit=crop&q=80&w=1000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTZ8fGFuaW1hbCUyMHBvcnRyYWl0fGVufDB8fDB8fHww',
            fit: BoxFit.fitHeight,
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
                  "Pet Owner Needed ASAP",
                  style: TextStyle(fontSize: 20, color: Colors.grey.shade300),
                ),
                const SizedBox(height: 10),
                Text(
                  "I’m recently found this dog at the side of the road. Looking for someone to take care of him as soon as possible. The dog is already vaccinated.",
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
