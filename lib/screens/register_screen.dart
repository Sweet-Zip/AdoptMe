import 'package:adoptme/components/custom_snackbar.dart';
import 'package:adoptme/components/loading.dart';
import 'package:adoptme/components/my_appbar.dart';
import 'package:adoptme/helpers/auth_helper.dart';
import 'package:adoptme/models/user_model.dart';
import 'package:adoptme/screens/login_screen.dart';
import 'package:email_validator/email_validator.dart';
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
      appBar: const MyAppBar(title: ''),
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
  AuthHelper authHelper = AuthHelper();
  String? password;
  String? confirmPassword;

  String? passwordMatchValidator(String value) {
    if (password == confirmPassword) {
      return null; // No error if passwords match
    } else {
      return 'Passwords do not match';
    }
  }

  Widget _buildBody() {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            Container(
              height: 120,
              width: 120,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: ClipOval(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
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
              height: 15,
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
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
            _buildRegisterBtn(),
            const SizedBox(
              height: 25,
            ),
            _buildLoginBtn(),
          ],
        ),
      ),
    );
  }

  Widget _buildRegisterBtn() {
    return GestureDetector(
      onTap: () async {
        if (_formKey.currentState!.validate()) {
          // Validation successful, proceed with your action
          String username = _usernameController.text;
          String email = _emailController.text;
          String password = _passwordController.text;
          String confirmPass = _confirmPassController.text;
          Loading(context: context).showLoading();
          if (password == confirmPass) {
            dynamic result = await authHelper.registerEmailAndPassword(
              context,
              email,
              password,
              username,
            );
            if (result is User) {
              print('Register successful $username email: $email');
              Loading(context: context).dismissLoading();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => LoginScreen(),
                ),
              );
            } else if (result is FirebaseAuthException) {
              // Handle registration failure
              if (result.code == 'email-already-in-use') {
                Loading(context: context).dismissLoading();
                ScaffoldMessenger.of(context).showSnackBar(
                  CustomSnackBar(errorText: 'Email already in use'),
                );
                // The email is already in use by another account.
              } else {
                // Handle other error codes as needed.
              }
            } else {
              // Handle unexpected errors or other cases.
            }
          } else {
            // Passwords don't match, display an error
            Loading(context: context).dismissLoading();
            ScaffoldMessenger.of(context).showSnackBar(
              CustomSnackBar(errorText: 'Passwords do not match'),
            );
          }
        }
      },
      child: const MyButton(
        textString: 'Sign Up',
      ),
    );
  }

  Widget _buildLoginBtn() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Already have an account? '),
        GestureDetector(
          onTap: () {
            Navigator.of(context).pop(); // Navigate back to the previous screen
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
    );
  }

  OutlineInputBorder outLine(Color color) {
    return OutlineInputBorder(
      borderSide: BorderSide(color: color, width: 1.5),
      borderRadius: BorderRadius.circular(10.0),
    );
  }
}
