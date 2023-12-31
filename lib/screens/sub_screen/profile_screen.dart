import 'dart:convert';

import 'package:adoptme/logic/user_logic.dart';
import 'package:adoptme/services/post_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import '../../components/my_button.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  String phoneNumber = '1234567890';
  UserLogic userLogic = UserLogic();
  User? user = FirebaseAuth.instance.currentUser;
  PostService postService = PostService();
  String? profileUrl;
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
    String uid = user!.uid;
    userLogic.readUserById(id: uid);
    profileUrl = userLogic.profileImage;
    username = userLogic.username;

    Future<List<dynamic>> postsFuture = postService.getPostsByUserId(uid);

    return FutureBuilder<List<dynamic>>(
      future: postsFuture,
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text('Error: ${snapshot.error}'),
            ),
          );
        }

        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(
              child: Text('No data available'),
            ),
          );
        }

        return CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              automaticallyImplyLeading: ModalRoute.of(context)?.canPop ?? true,
              expandedHeight: 300,
              pinned: false,
              floating: false,
              iconTheme: IconThemeData(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.grey.shade700,
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.background,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.background,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                    ),
                    child: _buildUserInfo(username!, profileUrl!),
                  ),
                ),
              ),
            ),
            _buildGridView(snapshot.data!, uid, username!),
          ],
        );
      },
    );
  }

  Widget _buildUserInfo(String? username, String profileImage) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipOval(
              child: (profileUrl != null && profileUrl != '')
                  ? Image.network(
                      profileUrl!,
                      errorBuilder: (context, error, stackTrace) => Image.asset(
                        'assets/images/image_not_found.jpg',
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
                      'assets/images/image_not_found.jpg',
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              username ?? 'Username',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(
              height: 10,
            ),
            const SizedBox(
              width: 300,
              child: Text(
                'Nature lover, animal enthusiast, and adventure seeker. I’m happiest when I’m surrounded by nature and furry friends.',
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: 200,
              child: InkWell(
                onTap: () {
                  _launchPhoneDialer();
                },
                child: const MyButton(textString: 'Contact Now'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridView(List<dynamic> posts, String uid, String username) {
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: posts.isEmpty ? 1 : 2,
        mainAxisExtent: 256,
      ),
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          if (posts.isEmpty) {
            return Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.no_photography_rounded,size: 48,),
                  const SizedBox(height: 5),
                  SizedBox(
                    width: 200,
                    child: Text(
                      '$username is too lazy and has not posted anything yet.',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            );
          } else {
            final post = posts[index];
            return _customGridItem(
              post['caption'],
              username,
              post['image'],
            );
          }
        },
        childCount: posts.isEmpty ? 1 : posts.length,
      ),
    );
  }

  Widget _customGridItem(String caption, String username, String? imageUrl) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: imageUrl != '' || imageUrl != null
                  ? Image.network(
                      imageUrl!,
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
                      'assets/images/image_not_found.jpg',
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          Positioned(
            left: 15,
            bottom: 15,
            child: SizedBox(
              width: 150, // Set the desired width for the text
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    username,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.grey.shade200,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    caption,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade400,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
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
