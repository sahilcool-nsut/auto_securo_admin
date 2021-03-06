import 'package:auto_securo_admin/screens/navbar_screens/QRScanner.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:auto_securo_admin/globals.dart' as globals;

import '../../NavBar.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  bool passwordVisible = false;
  TextEditingController _userIdController;
  TextEditingController _passwordController;
  bool showError = false;
  String error = "Wrong credentials!";
  bool loading = false;

  @override
  void initState() {
    _userIdController = new TextEditingController();
    _passwordController = new TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _userIdController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submitLoginDetails(String userId, String password) async {
    try {
      await auth.signInWithEmailAndPassword(
        email: _userIdController.text,
        password: _passwordController.text,
      );
      globals.user = auth.currentUser;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
    Navigator.push(
        context,
        PageTransition(
            child: NavBar(
              currentPage: 2,
            ),
            type: PageTransitionType.fade));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Text(
                  'Hello,',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                ),
              ),
              SizedBox(
                height: 12,
              ),
              Container(
                child: Text(
                  "Please enter your account details to access the Admin Portal",
                  style: TextStyle(fontSize: 16),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  border: OutlineInputBorder(),
                  labelText: 'User Email-ID',
                ),
                controller: _userIdController,
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                obscureText: !passwordVisible,
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                  suffixIcon: InkWell(
                    onTap: () {
                      setState(() {
                        passwordVisible = !passwordVisible;
                      });
                    },
                    child: passwordVisible
                        ? Icon(
                            Icons.remove_red_eye_outlined,
                            color: Colors.white70,
                          )
                        : Icon(
                            Icons.remove_red_eye,
                            color: Colors.white70,
                          ),
                  ),
                ),
                controller: _passwordController,
              ),
              SizedBox(height: 10),
              Visibility(
                visible: showError,
                child: Text(
                  error,
                  style: TextStyle(color: Colors.red),
                ),
              ),
              Flexible(
                child: Container(
                  child: Center(
                    child: Image(
                      image: AssetImage("images/loginPNG.png"),
                      height: MediaQuery.of(context).size.height * 0.5,
                      width: double.infinity,
                    ),
                  ),
                ),
              ),
              Spacer(),
              GestureDetector(
                onTap: () {
                  _submitLoginDetails(
                      _userIdController.text, _passwordController.text);
                  setState(() {
                    loading = true;
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(16),
                  child: loading
                      ? Center(
                          child: Transform.scale(
                            scale: 0.6,
                            child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 0,
                            ),
                            Text('Verify',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 19)),
                            Icon(
                              Icons.arrow_right_alt,
                              color: Colors.white,
                            ),
                          ],
                        ),
                  decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(7)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
