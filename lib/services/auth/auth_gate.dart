import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tiger_app_chat/page/HomePage.dart'; // Adjust the import path
import 'package:tiger_app_chat/page/login_page.dart'; // Adjust the import path

class AuthGate extends StatelessWidget {
  const AuthGate({Key? key})
      : super(key: key); // Correctly initialize super constructor

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const HomePage();
          } else {
            return const LoginPage();
          }
        },
      ),
    );
  }
}
