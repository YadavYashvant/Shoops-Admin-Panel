import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app_admin/pages/add_item.dart';
import 'package:grocery_app_admin/pages/greeting_page.dart';
import 'package:grocery_app_admin/pages/login_page.dart';
import 'package:grocery_app_admin/pages/signup_page.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Grocery App Admin Panel',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: GreetingPage(),
      routes: {
        '/greeting': (context) => const GreetingPage(),
        '/add-item': (context) => AddItem(),
        '/signup': (context) => SignupPage(),
        '/login': (context) => LoginPage()
      },
    );
  }
}