import 'package:flutter/material.dart';
import 'package:splitwise_clone/home_page.dart';
import 'sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool _showPassword = false;
  GlobalKey<FormState> _signInKey = GlobalKey<FormState>();
  String _email;
  String _password;
  Map<String, dynamic> _userCred;

  CollectionReference _userCredDb = Firestore.instance.collection('/userCred');
  CollectionReference _userInfo = Firestore.instance.collection('/userInfo');
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Form(
        key: _signInKey,
        child: Container(
          height: MediaQuery.of(context).size.height,
          color: Colors.green[300],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                height: 200.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    usernameAndPassword(
                        'Enter email', 'Email', false, 'Enter valid email'),
                    usernameAndPassword('Enter password', 'Password',
                        !_showPassword, 'Enter valid password'),
                    RaisedButton(
                      animationDuration: Duration(milliseconds: 300),
                      highlightColor: Colors.white,
                      splashColor: Colors.white,
                      onPressed: () {
                        if (_signInKey.currentState.validate()) {
                          FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                                  email: _email, password: _password)
                              .then((FirebaseUser signUpUser) {
                            _userCred = {
                              'email': signUpUser.email,
                              'uid': signUpUser.uid,
                            };

                            try {
                              DocumentReference infoDoc =
                                  _userInfo.document(_userCred['uid']);
                              infoDoc.setData({
                                'friends': [],
                              }).then((_) {
                                _userCred['userInfo'] = infoDoc;
                                _userCredDb
                                    .document(_userCred['uid'])
                                    .setData(_userCred)
                                    .then((_) {
                                  // Navigator.of(context).pushReplacement(
                                  //     MaterialPageRoute(
                                  //         builder: (BuildContext context) =>
                                  //             HomePage(
                                  //               uId: signUpUser.uid,
                                  //             )));
                                  print('done here');
                                  
                                });
                              });
                            } catch (e) {}

                            //Navigator.of(context).pop();
                          }).catchError((e) => print(e));
                        }
                      },
                      elevation: 2.0,
                      color: Colors.black87,
                      child: Text(
                        'Signup',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
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
