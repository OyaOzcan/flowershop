import 'package:caseapp/view/component/bottom_navbar.dart';
import 'package:caseapp/view_model/login_view_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:caseapp/view/component/bottom_navbar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  var _email = '';
  var _password = '';
  var _username = '';
  final LoginViewModel _loginViewModel = LoginViewModel();

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      bool success = await _loginViewModel.submitAuthForm(_email, _password, _username, _isLogin);
      if (success) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => BottomNavBar()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Authentication failed.")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String imagePath = "assets/logo.png";
    String imagePath1 = "assets/login.png";
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              imagePath1,
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.55,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24)),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(imagePath, width: 150, height: 75),
                        if (!_isLogin)
                          TextFormField(
                            decoration: const InputDecoration(
                                labelText: "Name"),
                            autocorrect: false,
                            onSaved: (newValue) => _username = newValue!,
                          ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.005),
                        TextFormField(
                          decoration:
                              const InputDecoration(labelText: "E-mail"),
                          autocorrect: false,
                          keyboardType: TextInputType.emailAddress,
                          onSaved: (newValue) => _email = newValue!,
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.005),
                        TextFormField(
                          decoration: const InputDecoration(labelText: "Password"),
                          autocorrect: false,
                          obscureText: true,
                          onSaved: (newValue) => _password = newValue!,
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.015),
                        Container(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _submit,
                            child: Text(
                              _isLogin ? "Login" : "Register",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 110, 19, 13)),
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () => setState(() => _isLogin = !_isLogin),
                          child: Text(
                            _isLogin
                                ? "Don't have an account? Register"
                                : "Do you have an account? Login",
                            style: TextStyle(
                                color: Color.fromARGB(255, 110, 19, 13)),
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.015),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton.icon(
                              onPressed: (){},
                              icon: Icon(FontAwesomeIcons.google, color: Colors.white),
                              label: Text("Sign In with Google"),
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Color(0xffF4C2C2),
                                textStyle: TextStyle(color: Colors.white),
                                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.015),
                        const Divider(),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.009),
                        const Text("Forgot my password"),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
