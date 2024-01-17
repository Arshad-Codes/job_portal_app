import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        actions: [
          // Logout button
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: _logout,
          ),
        ],
      ),
      body: Container(),
    );
  }


  Future<void> _logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      
    } catch (err) {
      print("Error during logout: $err");
      // Display an error message if logout fails
      Get.snackbar(
        'Error',
        'An error occurred during logout',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}