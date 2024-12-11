import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:proj2/Screens/Login.dart';  // Ensure correct import
import 'package:proj2/Screens/Stock_Detail.dart';
import 'package:proj2/Screens/News_Feed.dart';
import 'package:proj2/Screens/Watchlist.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Firebase App',
      home: AuthWrapper(), // Use AuthWrapper to check login status
    );
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Check if user is logged in using FirebaseAuth
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(), // Stream of authentication state
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show loading indicator while checking auth state
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          // Handle errors
          return Center(child: Text('Something went wrong!'));
        } else if (snapshot.hasData) {
          // User is logged in, navigate to Home screen
          return Home();
        } else {
          // User is not logged in, show Login screen
          return LoginScreen(); // Updated to LoginScreen
        }
      },
    );
  }
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                'Navigation',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              title: Text('Stock Detail'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => StockDetail()),
                );
              },
            ),
            ListTile(
              title: Text('News Feed'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NewsFeed()),
                );
              },
            ),
            ListTile(
              title: Text('Watchlist'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Watchlist()),
                );
              },
            ),
          ],
        ),
      ),
      body: Center(child: Text('Home Screen Content')),
    );
  }
}
