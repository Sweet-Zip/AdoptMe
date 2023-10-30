import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    required this.hintText,
    required this.controller,
    required this.obscureText,
    required this.validValue,
    required this.inputType,
  });

  final String hintText;
  final TextEditingController controller;
  final bool obscureText;
  final String? validValue;
  final TextInputType inputType;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  String? _validateInput(String? value) {
    if (value == null || value.isEmpty || value == widget.hintText) {
      return widget.validValue;
    }
    return null;
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  OutlineInputBorder outLine(Color color) {
    return OutlineInputBorder(
      borderSide: BorderSide(color: color, width: 1.5),
      borderRadius: BorderRadius.circular(10.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: TextFormField(
        controller: widget.controller,
        obscureText: _obscureText,
        validator: _validateInput,
        keyboardType: widget.inputType,
        decoration: InputDecoration(
          hintText: widget.hintText,
          enabledBorder: outLine(Theme.of(context).colorScheme.primary),
          focusedBorder: outLine(Theme.of(context).colorScheme.primary),
          errorBorder: outLine(Colors.red),
          focusedErrorBorder: outLine(Theme.of(context).colorScheme.primary),
          // Conditionally show/hide the toggle icon based on obscureText
          suffixIcon: widget.obscureText
              ? IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                  onPressed: _togglePasswordVisibility,
                )
              : null, // If obscureText is false, don't show the icon
        ),
      ),
    );
  }
}
