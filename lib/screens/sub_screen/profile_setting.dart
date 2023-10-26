import 'package:adoptme/components/my_appbar.dart';
import 'package:flutter/material.dart';

import '../../components/custom_row.dart';

class ProfileSetting extends StatefulWidget {
  const ProfileSetting({super.key});

  @override
  State<ProfileSetting> createState() => _ProfileSettingState();
}

class _ProfileSettingState extends State<ProfileSetting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(title: 'Profile Setting'),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      // Align children to the start (top)
      children: [
        const SizedBox(height: 25),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    CustomRow(
                      icon: Icons.bookmark,
                      text: 'Bookmarks',
                      color: Colors.amber,
                      onPressed: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) {
                              return const ProfileSetting();
                            }));
                      },
                    ),
                    CustomRow(
                      icon: Icons.favorite,
                      text: 'Likes',
                      color: Colors.red,
                      onPressed: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) {
                              return const ProfileSetting();
                            }));
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
