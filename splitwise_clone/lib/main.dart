import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:splitwise_clone/Login/sign_in.dart';
import 'package:splitwise_clone/add_friends.dart';
import 'home_page.dart';
import './Login/signup.dart';

void main() => runApp(MaterialApp(
      home: LoginApp(),
      routes: <String, WidgetBuilder>{
        '/homePage': (BuildContext context) => HomePage(),
        '/signUp': (BuildContext context) => SignUp(),
        '/addFriends': (BuildContext context) => AddFriends(),
      },
    ));

class LoginApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[300],
      body: StreamBuilder<Object>(
          stream: FirebaseAuth.instance.onAuthStateChanged,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else {
              if (snapshot.hasData) {
                return HomePage(
                  uId: '1abcdgesdas',
                );
              } else {
                return SignInForm();
              }
            }
          }),
    );
  }
}
