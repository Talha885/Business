import 'package:business/login.dart';
import 'package:business/my_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'my_textfield.dart'; // Import the MyTextField widget

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final nameController = TextEditingController(); // New controller for name
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool keepSignedIn = false;

  void signUserUp() async {
    // show loading circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    if (passwordController.text == confirmPasswordController.text) {
      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );

        // Ensure the user's email is not null
        String userEmail = userCredential.user?.email ?? '';

        // Save user data to Firestore with the profile picture URL
        await FirebaseFirestore.instance
            .collection("Users")
            .doc(userEmail) // Use userEmail as the document ID
            .set({
          'username': emailController.text.split('@')[0],
          'bio': 'Empty Bio..',
        });

        // pop the loading circle
        Navigator.pop(context);

        // Navigate to the login page after successful registration
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LoginScreen(),
          ),
        );
      } on FirebaseAuthException catch (e) {
        // pop the loading circle
        Navigator.pop(context);
        showErrorMessage(e.code);
      }
    } else {
      showErrorMessage("Passwords Don't Match!");
      // pop the loading circle
      Navigator.pop(context);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                LoginScreen()), // Replace with your login screen widget
      );
    }
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 254, 254, 254),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 100),
                const Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Register',
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple, // Changed color
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Welcome to the App',
                  style: TextStyle(
                    fontSize: 23,
                    color: Colors.grey[600], // Adjusted color
                  ),
                ),
                const SizedBox(height: 20),
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
                const SizedBox(height: 20),
                const Text(
                  'Confirm Password',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                MyTextField(
                  controller: confirmPasswordController,
                  hintText: 'Confirm Password',
                  obscureText: true,
                  label: '',
                  inputType: TextInputType.text,
                ),
                const SizedBox(
                  height: 60,
                ),
                MyButton(
                  text: "Sign up",
                  onTap: signUserUp,
                ),
                const SizedBox(
                  height: 24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
