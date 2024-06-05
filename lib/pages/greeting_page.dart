import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_firestore_app/components/custom_btn.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app_admin/components/primary_btn.dart';

class GreetingPage extends StatefulWidget {
  const GreetingPage({Key? key}) : super(key: key);

  @override
  State<GreetingPage> createState() => _GreetingPageState();
}

class _GreetingPageState extends State<GreetingPage> {

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        // User is signed in, navigate to HomePage
        Navigator.pushReplacementNamed(context, '/add-item');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amberAccent[100],
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.amberAccent[400],
        title: const Text('Gym App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome to the Gym App!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            PrimaryButton(
              onPressed: () {
                Navigator.pushNamed(context, '/signup');
              },
              text: 'Login or Sign Up',
            ),
          ],
        ),
      ),
    );
  }
}