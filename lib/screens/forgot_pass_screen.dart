import 'package:adoptme/components/my_button.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

import '../components/custom_textFormField.dart';
import '../components/my_appbar.dart';
import '../helpers/auth_helper.dart';

class ForgotPassScreen extends StatefulWidget {
  const ForgotPassScreen({super.key});

  @override
  State<ForgotPassScreen> createState() => _ForgotPassScreenState();
}

class _ForgotPassScreenState extends State<ForgotPassScreen> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(
        title: '',
      ),
      body: SafeArea(
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          const SizedBox(height: 150),
          Icon(
            Icons.lock,
            size: 120,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 20),
          const Text(
            'Forgot Your Password?',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: TextFormField(
              controller: _emailController,
              obscureText: false,
              validator: (value) => EmailValidator.validate(value!)
                  ? null
                  : 'Please input valid email',
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: 'Email',
                enabledBorder: outLine(Theme.of(context).colorScheme.primary),
                focusedBorder: outLine(Theme.of(context).colorScheme.primary),
                errorBorder: outLine(Colors.red),
                focusedErrorBorder:
                outLine(Theme.of(context).colorScheme.primary),
              ),
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(bottom: 25.0),
            child: GestureDetector(
              onTap: () async {
                if (_formKey.currentState!.validate()) {
                  try {
                    await AuthHelper.resetPassword(
                      _emailController.text,
                      context,
                    );
                  } catch (e) {
                    // Handle any error
                  }
                }
              },
              child: const MyButton(textString: 'Submit'),
            ),
          )
        ],
      ),
    );
  }

  OutlineInputBorder outLine(Color color) {
    return OutlineInputBorder(
      borderSide: BorderSide(color: color, width: 1.5),
      borderRadius: BorderRadius.circular(10.0),
    );
  }
}
