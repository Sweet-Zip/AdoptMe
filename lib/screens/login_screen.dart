import 'package:adoptme/components/custom_snackbar.dart';
import 'package:adoptme/components/loading.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../components/custom_textFormField.dart';
import '../components/my_button.dart';
import '../helpers/auth_helper.dart';
import '../logic/user_logic.dart';
import '../themes/theme.dart';
import '../themes/themeProvider.dart';
import 'forgot_pass_screen.dart';
import 'item_main_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _buildBody(),
      ),
    );
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _errorMessage = '';

  UserLogic userLogic = UserLogic();

  Widget _buildTextField() {
    return Column(
      children: [
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
          obscureText: true,
          controller: _passwordController,
          validValue: 'Please input valid password',
          inputType: TextInputType.visiblePassword,
        ),
      ],
    );
  }

  Widget _buildBody() {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final isLightMode = themeProvider.themeData == lightMode;
    final icon =
        isLightMode ? Icons.light_mode_rounded : Icons.dark_mode_rounded;
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Stack(
          children: [
            Positioned(
              top: 15,
              right: 15,
              child: IconButton(
                onPressed: () {
                  themeProvider.toggleTheme();
                },
                icon: Icon(icon),
              ),
            ),
            Column(
              children: [
                const SizedBox(height: 85),
                Container(
                  height: 150,
                  width: 150,
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
                const SizedBox(height: 25),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Sign in",
                        style:
                            TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                _buildTextField(),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      _buildForgotPass(),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                if (_errorMessage
                    .isNotEmpty) // Show error message if it's not empty
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      _errorMessage,
                      style: const TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  ),
                _buildLoginBtn(),
                const SizedBox(height: 50),
                _buildRegisterBtn(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginBtn() {
    return GestureDetector(
      onTap: () async {
        if (_formKey.currentState!.validate()) {
          Loading(context: context).showLoading();
          User? user = await AuthHelper.loginEmailAndPassword(
            _emailController.text.trim(),
            _passwordController.text.trim(),
          );
          if (user == null) {
            Loading(context: context).dismissLoading();
            ScaffoldMessenger.of(context).showSnackBar(
              CustomSnackBar(errorText: 'Email or password may be incorrect'),
            );
          } else {

            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const ItemMainScreen(),
              ),
            );
          }
        }
      },
      child: const MyButton(
        textString: 'Sign In',
      ),
    );
  }


  Widget _buildForgotPass() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ForgotPassScreen(),
          ),
        );
      },
      child: const Text(
        "Forgot Password?",
        style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildRegisterBtn() {
    _handleClick() {
      //Navigator.pop(context); //Kill screen

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => RegisterScreen(),
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Don't have any account? ",
          style: TextStyle(color: Colors.grey),
        ),
        GestureDetector(
          onTap: _handleClick,
          child: const Text(
            "Sign Up",
            style: TextStyle(
                color: Color(0xff008CCF), fontWeight: FontWeight.bold),
          ),
        )
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
