import 'package:adoptme/components/custom_row.dart';
import 'package:adoptme/screens/sub_screen/profile_setting.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../components/my_button.dart';
import '../login_screen.dart';
import 'about_screen.dart';
import 'change_password_screen.dart';
import 'preference_screen.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 70.0),
        child: Column(
          children: [
            Container(
              height: 120,
              width: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Theme.of(context).colorScheme.primary, width: 0.5),
              ),
              child: ClipOval(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Image.asset(
                    'assets/images/app_logo.png',
                    width: 100,
                    height: 100,
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text("Version V1.0.0"),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Card(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          CustomRow(
                            icon: Icons.person_rounded,
                            text: 'Profile Setting',
                            color: Colors.grey.shade700,
                            onPressed: () {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) {
                                return const ProfileSetting();
                              }));
                            },
                          ),
                          CustomRow(
                            icon: Icons.settings_applications,
                            text: 'Preference',
                            color: Colors.grey.shade700,
                            onPressed: () {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) {
                                return const PreferenceScreen();
                              }));
                            },
                          ),
                          CustomRow(
                            icon: Icons.lock_open_rounded,
                            text: 'Change Password',
                            color: Colors.grey.shade700,
                            onPressed: () {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) {
                                return const ChangePasswordScreen();
                              }));
                            },
                          ),
                          CustomRow(
                            icon: Icons.warning_amber_rounded,
                            text: 'About',
                            color: Colors.grey.shade700,
                            onPressed: () {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) {
                                return const AboutScreen();
                              }));
                            },
                          ),
                        ],
                      )),
                ),
              ),
            ),
            const Spacer(),
            Container(
              margin: const EdgeInsets.only(bottom: 25.0),
              // Adjust the margin as needed
              child: _buildSignOutBtn(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSignOutBtn() {
    return GestureDetector(
      onTap: () async {
        await FirebaseAuth.instance.signOut();
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => LoginScreen(),
          ),
        );
      },
      child: const MyButton(
        textString: 'Sign Out',
      ),
    );
  }
}
