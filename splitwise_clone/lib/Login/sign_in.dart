import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:splitwise_clone/Login/signup.dart';

class SignInForm extends StatefulWidget {
  @override
  SignInFormState createState() {
    return SignInFormState();
  }
}

// Create a corresponding State class. This class will hold the data related to
// the form.
class SignInFormState extends State<SignInForm> {
  bool _showPassword = false;
  String _email;
  String _password;
  bool invalidCred = false;
  bool signIn = true;
  GlobalKey<FormState> _signInKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return this.signIn ? signInForm(context) : SignUp();
  }

  Form signInForm(BuildContext context) {
    return Form(
      key: _signInKey,
      child: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              height: 200.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  usernameAndPassword(
                      'Enter email', 'Email Id', false, 'Enter valid Email'),
                  usernameAndPassword('Enter password', 'Password',
                      !_showPassword, 'Enter valid password'),
                  SizedBox(
                    height: this.invalidCred ? 30 : 0,
                    child: Text(
                      'Invalid email or password',
                      style: TextStyle(
                        color: Colors.redAccent,
                      ),
                    ),
                  ),
                  RaisedButton(
                    animationDuration: Duration(milliseconds: 300),
                    highlightColor: Colors.white,
                    splashColor: Colors.white,
                    onPressed: () {
                      if (_signInKey.currentState.validate()) {
                        FirebaseAuth.instance
                            .signInWithEmailAndPassword(
                          email: _email,
                          password: _password,
                        )
                            .then((FirebaseUser value) {
                          print(value);
                          // Navigator.of(context).pushReplacement(
                          //     MaterialPageRoute(
                          //         builder: (BuildContext context) =>
                          //             HomePage(uId: value.uid)));
                        }).catchError((e) {
                          this.setState(() {
                            this.invalidCred = true;
                          });
                          return null;
                        });
                      }
                    },
                    elevation: 2.0,
                    color: Colors.black87,
                    child: Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20.0),
              child: Column(
                children: <Widget>[
                  Text(
                    "Don't have an account?",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  RaisedButton(
                    animationDuration: Duration(milliseconds: 300),
                    highlightColor: Colors.white,
                    splashColor: Colors.white,
                    elevation: 2.0,
                    color: Colors.black87,
                    child: Text(
                      'Signup',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      //Navigator.pushReplacementNamed(context, '/signUp');
                      //Navigator.of(context).pushNamed('/signUp');
                      this.setState(() => {
                        this.signIn = false
                      });
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget usernameAndPassword(String _hintText, String _labelText,
      bool _isPassword, String _errorText) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: TextFormField(
        obscureText: _isPassword,
        decoration: InputDecoration(
          suffixIcon: _labelText == 'Password'
              ? IconButton(
                  icon: Icon(Icons.remove_red_eye),
                  color: _showPassword ? Colors.white : Colors.black,
                  onPressed: () {
                    setState(() {
                      _showPassword = !_showPassword;
                    });
                  },
                )
              : null,
          isDense: true,
          hintText: _hintText,
          hintStyle: TextStyle(
            fontStyle: FontStyle.italic,
            color: Colors.white,
          ),
          labelText: _labelText,
          labelStyle: TextStyle(
            fontSize: 18.0,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white,
            ),
          ),
          enabledBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        validator: (String value) {
          if (value.isEmpty) {
            return _errorText;
          } else {
            setState(() {
              if (_labelText == 'Password') {
                _password = value;
              } else {
                _email = value;
              }
            });
          }
          // else{
          //   setState(() {

          //   });
          // }
        },
      ),
    );
  }
}
