import 'package:flutter/material.dart';

class MyTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final Icon? prefixIcon;

  const MyTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    this.prefixIcon,
    required String label,
    required TextInputType inputType,
  }) : super(key: key);

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  bool _isObscured = true;

  void _toggleObscureText() {
    setState(() {
      _isObscured = !_isObscured;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: TextField(
        controller: widget.controller,
        obscureText: widget.obscureText && _isObscured,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.transparent,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 12.0, horizontal: 18.0),
          enabledBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Colors.black), // Set border color to black
            borderRadius: BorderRadius.circular(16.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Colors.black), // Set border color to black
            borderRadius: BorderRadius.circular(16.0),
          ),
          hintText: widget.hintText,
          hintStyle: const TextStyle(color: Color.fromARGB(255, 160, 160, 160)),
          prefixIcon: widget.prefixIcon,
          suffixIcon: widget.obscureText
              ? IconButton(
                  onPressed: _toggleObscureText,
                  icon: Icon(
                    _isObscured ? Icons.visibility : Icons.visibility_off,
                    color: const Color.fromARGB(255, 160, 160, 160),
                  ),
                )
              : null,
        ),
      ),
    );
  }
}
