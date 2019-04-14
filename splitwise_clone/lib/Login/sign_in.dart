import 'package:flutter/material.dart';

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
  GlobalKey<FormState> _signInKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _signInKey,
      child: Center(
        child: Container(
          alignment: Alignment.center,
          height: 200.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              usernameAndPassword(
                  'Enter username', 'Username', false, 'Enter valid username'),
              usernameAndPassword('Enter password', 'Password', !_showPassword,
                  'Enter valid password'),
              RaisedButton(
                animationDuration: Duration(milliseconds: 300),
                highlightColor: Colors.white,
                splashColor: Colors.white,
                onPressed: () {
                  if (_signInKey.currentState.validate()) {
                    // If the form is valid, we want to show a Snackbar
                    Navigator.pushNamed(context, '/homePage');
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
