import 'package:adoptme/components/my_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/my_appbar.dart';
import '../../themes/theme.dart';
import '../../themes/themeProvider.dart';

class PreferenceScreen extends StatefulWidget {
  const PreferenceScreen({super.key});

  @override
  State<PreferenceScreen> createState() => _PreferenceScreenState();
}

class _PreferenceScreenState extends State<PreferenceScreen> {
  bool valueBool = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: MyAppBar().buildAppBar(context, 'Preference'),
      appBar: const MyAppBar(title: 'Preference'),
      body: SafeArea(
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 25.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Show Contact on Profile',
                            ),
                          ),
                          const Spacer(),
                          Switch(
                            value: valueBool,
                            activeColor: Theme.of(context).colorScheme.primary,
                            onChanged: (bool newValue) {
                              setState(() {
                                valueBool = newValue;
                              });
                            },
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "Theme (Light/Dark)",
                            ),
                          ),
                          const Spacer(),
                          Switch(
                            value:
                                Provider.of<ThemeProvider>(context).themeData ==
                                    darkMode,
                            activeColor: Theme.of(context).colorScheme.primary,
                            onChanged: (bool value) {
                              final themeProvider = Provider.of<ThemeProvider>(
                                  context,
                                  listen: false);
                              themeProvider.toggleTheme();
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


}
