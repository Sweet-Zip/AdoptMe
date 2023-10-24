import 'package:adoptme/helpers/auth_helper.dart';
import 'package:adoptme/helpers/user_repository.dart';
import 'package:adoptme/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../components/custom_textFormField.dart';
import '../components/my_button.dart';
import '../logic/user_logic.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Make the AppBar transparent
        iconTheme: IconThemeData(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white
              : Colors.grey.shade700,
        ),
        elevation: 0, // Remove the shadow
      ),
      body: SafeArea(
        child: _buildBody(),
      ),
    );
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPassController = TextEditingController();
  UserLogic userLogic = UserLogic();
  UserRepository userRepository = UserRepository();

  Widget _buildBody() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          const SizedBox(height: 10),
          Image.network(
            "https://www.creativefabrica.com/wp-content/uploads/2020/09/01/Dog-paw-vector-icon-logo-design-heart-Graphics-5223218-1.jpg",
            height: 100,
          ),
          const SizedBox(
            height: 25,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Register",
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          CustomTextField(
            hintText: 'Username',
            controller: _usernameController,
            obscureText: false,
            validValue: 'Please input valid username',
            inputType: TextInputType.text,
          ),
          const SizedBox(
            height: 15,
          ),
          CustomTextField(
            hintText: 'Email',
            controller: _emailController,
            obscureText: false,
            validValue: 'Please input valid email',
            inputType: TextInputType.emailAddress,
          ),
          const SizedBox(
            height: 15,
          ),
          CustomTextField(
            hintText: 'Password',
            controller: _passwordController,
            obscureText: true,
            validValue: 'Please input valid password',
            inputType: TextInputType.visiblePassword,
          ),
          const SizedBox(
            height: 15,
          ),
          CustomTextField(
            hintText: 'Confirm password',
            controller: _confirmPassController,
            obscureText: true,
            validValue: 'Password not match',
            inputType: TextInputType.visiblePassword,
          ),
          const SizedBox(
            height: 25,
          ),
          GestureDetector(
            onTap: () async {
              if (_formKey.currentState!.validate()) {
                // Validation successful, proceed with your action
                String user = _usernameController.text;
                String email = _emailController.text;
                String password = _passwordController.text;
                String confirmPass = _confirmPassController.text;
                dynamic result =
                    await AuthHelper.registerEmailAndPassword(email, password);
                if (result is User) {
                  print('Register successful ${user} email: ${email}');
                  userRepository.addUserInfo(UserModel(
                    username: user,
                    email: email,
                    password: password,
                  ));
                } else if (result is FirebaseAuthException) {
                  print('Register Fail');
                  // Registration failed, handle the error
                  if (result.code == 'email-already-in-use') {
                    print('Email already in use');
                    // The email is already in use by another account.
                  } else {
                    // Handle other error codes as needed.
                  }
                } else {
                  // Handle unexpected errors or other cases.
                }
              }
            },
            child: const MyButton(
              textString: 'Sign Up',
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Already have an account? '),
              GestureDetector(
                onTap: () {
                  Navigator.of(context)
                      .pop(); // Navigate back to the previous screen
                },
                child: const Text(
                  'Login',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xff008CCF),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
