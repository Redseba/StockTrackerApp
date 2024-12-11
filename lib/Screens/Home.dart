import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final _auth = FirebaseAuth.instance;

  Future<void> _signOut() async {
    await _auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Welcome to the Home Screen!'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _signOut,
              child: Text('Sign Out'),
            ),
          ],
        ),
      ),
    );
  }
}
