import 'package:flutter/material.dart';
import 'package:splitwise_clone/Login/sign_in.dart';
import 'home_page.dart';

void main() => runApp(MaterialApp(
      home: LoginApp(),
      routes: <String, WidgetBuilder>{
        '/homePage': (BuildContext context) => HomePage(),
      },
    ));

class LoginApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SignInForm(),
      backgroundColor: Colors.green[300],
    );
  }
}
