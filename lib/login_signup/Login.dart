import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/Constants.dart';
import 'package:flutter_app/app_theme.dart';
import 'package:flutter_app/main2.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  //Authservice authser = Authservice();
  final RegExp emailValidatorRegExp = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  final FirebaseAuth _auth = FirebaseAuth.instance;
  User user;
  // ignore: non_constant_identifier_names
  String _UserEnteredEmail, _UserEnteredPassword;
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  bool isPasswordVisible;
  bool check;
  bool visible;

  @override
  void initState() {
    isPasswordVisible = false;
    check = false;
    visible = false;
    user = _auth.currentUser;
    super.initState();
  }

  loadProgress() {
    if (visible == true) {
      setState(() {
        visible = false;
      });
    } else {
      setState(() {
        visible = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          "Welcome to",
          style: TextStyle(
            fontSize: 16,
            color: AppTheme.white,
            height: 2,
          ),
        ),
        Text(
          "ROOMIES",
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: AppTheme.white,
            letterSpacing: 2,
            height: 1,
          ),
        ),
        Text(
          "Please login to continue",
          style: TextStyle(
            fontSize: 16,
            color: AppTheme.white,
            height: 1,
          ),
        ),
        SizedBox(
          height: 16,
        ),
        Form(
          key: formkey,
          child: Column(
            children: [
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                inputFormatters: [
                  FilteringTextInputFormatter.singleLineFormatter
                ],
                validator: emailValidation,
                decoration: InputDecoration(
                  hintText: 'Email / Username',
                  hintStyle: TextStyle(
                    fontSize: 16,
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.bold,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                ),
                onChanged: (value) {
                  setState(() {
                    _UserEnteredEmail = value.trim();
                  });
                },
              ),
              SizedBox(
                height: 16,
              ),
              TextFormField(
                keyboardType: TextInputType.text,
                inputFormatters: [
                  FilteringTextInputFormatter.singleLineFormatter
                ],
                validator: passwordValidation,
                obscureText: isPasswordVisible ? false : true,
                decoration: InputDecoration(
                  hintText: 'Password',
                  hintStyle: TextStyle(
                    fontSize: 16,
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.bold,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                  suffixIcon: IconButton(
                      icon: Icon(
                        isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Color(0xFFE6E6E6),
                      ),
                      onPressed: () {
                        setState(() {
                          isPasswordVisible = !isPasswordVisible;
                        });
                      }),
                ),
                onChanged: (value) {
                  setState(() {
                    _UserEnteredPassword = value.trim();
                  });
                },
              ),
              SizedBox(
                height: 24,
              ),
              GestureDetector(
                onTap: () async {
                  if (formkey.currentState.validate()) {
                    //SharedPreferences prefs;
                    _auth
                        .signInWithEmailAndPassword(
                            email: _UserEnteredEmail,
                            password: _UserEnteredPassword)
                        .then((_) async => {
                              //prefs = await SharedPreferences
                              // .getInstance(),
                              // prefs.setString('email', _email),
                              setState(() {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text(
                                        'Please Wait...\nDo not press back button')));
                              }),
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ThisApp())),
                            });

                    /*if (visible) {
                      final val = await showDialog<bool>(
                          context: context,
                          builder: (context) {
                            return Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircularProgressIndicator(),
                                ],
                              ),
                            );
                          });
                    }*/
                  }
                },
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(25),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.2),
                        spreadRadius: 3,
                        blurRadius: 4,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      "LOGIN",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              GestureDetector(
                onTap: () {},
                child: Text(
                  "FORGOT PASSWORD?",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
