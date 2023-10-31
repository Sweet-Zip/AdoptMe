import 'package:adoptme/components/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../components/custom_textFormField.dart';
import '../../components/my_appbar.dart';
import '../../components/my_button.dart';
import '../../helpers/auth_helper.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _newPassController = TextEditingController();
  final TextEditingController _conPassController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final String _errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(
        title: 'Change Password',
      ),
      body: SafeArea(child: _buildBody()),
    );
  }

  Widget _buildBody() {
    return Form(
      key: _formKey,
      child: Center(
        child: Column(
          children: [
            const SizedBox(height: 25),
            CustomTextField(
              hintText: 'Enter current password',
              controller: _passController,
              obscureText: true,
              validValue: 'Please enter valid password',
              inputType: TextInputType.visiblePassword,
            ),
            const SizedBox(height: 15),
            CustomTextField(
              hintText: 'Enter new password',
              controller: _newPassController,
              obscureText: true,
              validValue: 'Please enter valid password',
              inputType: TextInputType.visiblePassword,
            ),
            const SizedBox(height: 15),
            CustomTextField(
              hintText: 'Enter confirm password',
              controller: _conPassController,
              obscureText: true,
              validValue: 'Please enter valid password',
              inputType: TextInputType.visiblePassword,
            ),
            const SizedBox(height: 15),
            // _buildSubmitButton(),
            InkWell(
              onTap: () async {
                if (_formKey.currentState!.validate()) {
                  try {
                    String pass = _passController.text;
                    String newPass = _newPassController.text;
                    String conPass = _conPassController.text;
                    await AuthHelper.changePassword(pass, newPass, context);
                  } catch (e) {}
                } else {
                  // Form validation failed
                }
              },
              child: const MyButton(textString: 'Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
