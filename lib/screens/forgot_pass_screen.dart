import 'package:flutter/material.dart';

import '../components/custom_textFormField.dart';
import '../components/my_appbar.dart';

class ForgotPassScreen extends StatefulWidget {
  ForgotPassScreen({super.key});

  final emailController = TextEditingController();

  @override
  State<ForgotPassScreen> createState() => _ForgotPassScreenState();
}

class _ForgotPassScreenState extends State<ForgotPassScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(title: '',),
      body: SafeArea(
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        const SizedBox(height: 80),
        const Icon(
          Icons.lock,
          size: 200,
          color: Color(0xff00AEEF),
        ),
        const SizedBox(height: 20),
        const Text(
          'Forgot Your Password?',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        const SizedBox(height: 30),
        CustomTextField(
          hintText: 'Email',
          controller: widget.emailController,
          obscureText: false,
          validValue: 'Please Enter valid email',
          inputType: TextInputType.emailAddress,
        ),
      ],
    );
  }
}
