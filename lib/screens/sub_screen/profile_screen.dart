import 'package:adoptme/logic/user_logic.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
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
                child: _buildUserInfo(),
              ),
            ),
          ),
        ),
        _buildGridView(),
      ],
    );
  }

  Widget _buildUserInfo() {
    String uid = user!.uid;
    userLogic.readUserById(id: uid);
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipOval(
              child: Image.network(
                userLogic.profileImage!,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    'assets/images/image_not_found.jpg',
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  );
                },
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              userLogic.username ?? 'Username',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
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

  Widget _buildGridView() {
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisExtent: 256,
      ),
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return DefaultTabController(
            length: 2,
            child: _customGridItem(),
          );
        },
        childCount: 10,
      ),
    );
  }

  Widget _customGridItem() {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                'https://images.unsplash.com/photo-1596457107504-7f8ba467b685?auto=format&fit=crop&q=80&w=1000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTZ8fGFuaW1hbCUyMHBvcnRyYWl0fGVufDB8fDB8fHww',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            left: 15,
            bottom: 15,
            child: Container(
              width: 150, // Set the desired width for the text
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pet Owner Needed ASAP',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.grey.shade200,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    'I’m recently found this dog at the side of the road. Looking for someone to take care of him as soon as possible. The dog is already vaccinated.',
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
