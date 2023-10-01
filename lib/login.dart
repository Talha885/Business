// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:business/registration.dart';
import 'package:business/my_button.dart';
import 'package:business/register_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'my_textfield.dart'; // Import the MyTextField widget

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool keepSignedIn = false;
  bool isLoading = false;

  void signUserIn() async {
    setState(() {
      isLoading = true;
    });

    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    // try sign in
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      setState(() {
        isLoading = true; // Stop loading
      });
      // pop the loading circle
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      // pop the loading circle
      Navigator.pop(context);
      showErrorMessage(e.code);
    }
  }

  // error message
  void showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.deepPurple,
          title: Center(
            child: Text(
              message,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  void _handleLogin(BuildContext context, String email, String password) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool("isLogin", true);
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const RegistrationPage()),
      );
    } catch (e) {
      print('Error during sign in: $e');
      // Handle sign-in errors
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        // Wrap your Column with SingleChildScrollView
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 150),
              const Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Welcome back to the App',
                style: TextStyle(
                  fontSize: 23,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 50),
              const Text(
                'Email Address',
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              MyTextField(
                controller: emailController,
                hintText: 'hello@example.com',
                obscureText: false,
                label: '',
                inputType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
              const Text(
                'Password',
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              MyTextField(
                controller: passwordController,
                hintText: 'Password',
                obscureText: true,
                label: '',
                inputType: TextInputType.text,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    // Add your "Forgot Password" button functionality here
                  },
                  child: const Text(
                    'Forgot Password',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        keepSignedIn = !keepSignedIn;
                      });
                    },
                    child: Row(
                      children: [
                        Checkbox(
                          value: keepSignedIn,
                          onChanged: (newValue) {
                            setState(() {
                              keepSignedIn = newValue ?? false;
                            });
                          },
                        ),
                        const Text(
                          'Keep me signed in',
                          style: TextStyle(
                            fontSize: 17,
                            color: Color.fromARGB(255, 163, 162, 162),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              MyButton(
                text: "Login",
                onTap: () => _handleLogin(
                  context,
                  emailController.text,
                  passwordController.text,
                ),
              ),
              if (isLoading) const CircularProgressIndicator(),
              const SizedBox(
                height: 24,
              ),
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const RegisterPage(), // Navigate to register_page.dart
                      ),
                    );
                  },
                  child: const Text(
                    'Create an Account',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
