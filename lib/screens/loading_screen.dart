import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Loading Screen Example',
      home: LoadingScreen(),
    );
  }
}

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
// Replace 'your_logo.png' with your logo's asset path
            Image.asset('assets/images/girisanimasyon.png',
                height: 100), // Adjust height as needed
            SizedBox(height: 20), // Space between logo and loading indicator
            CircularProgressIndicator(), // Loading indicator
            SizedBox(height: 20), // Space below loading indicator
            Text(
              'Loading...',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
