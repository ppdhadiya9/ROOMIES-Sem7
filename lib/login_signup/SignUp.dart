import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/Constants.dart';
import 'package:flutter_app/Screens/ProfileBuild.dart';
import 'package:flutter_app/login_signup/verifyEmail.dart';
import 'package:flutter_icons/flutter_icons.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User user;
  String _userEnteredEmail,
      _userEnteredPassword,
      // ignore: unused_field
      _userEnteredUname,
      // ignore: unused_field
      _userEnteredRepassword;
  GlobalKey<FormState> signupformkey = GlobalKey<FormState>();
  bool isPasswordVisible;

  bool visible;
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
  void initState() {
    visible = false;
    isPasswordVisible = false;
    user = _auth.currentUser;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          "Sign up with",
          style: TextStyle(
            fontSize: 16,
            color: Colors.blueAccent,
            height: 2,
          ),
        ),
        Text(
          "ROOMIES",
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: Colors.blueAccent,
            letterSpacing: 2,
            height: 1,
          ),
        ),
        SizedBox(
          height: 16,
        ),
        Form(
            key: signupformkey,
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Enter Email / Username',
                    hintStyle: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
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
                    fillColor: Colors.blueAccent,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  inputFormatters: [
                    FilteringTextInputFormatter.singleLineFormatter
                  ],
                  validator: emailValidation,
                  onChanged: (value) {
                    setState(() {
                      _userEnteredEmail = value.trim();
                    });
                  },
                ),
                SizedBox(
                  height: 16,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Password',
                    hintStyle: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
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
                    fillColor: Colors.blueAccent,
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
                  obscureText: isPasswordVisible ? false : true,
                  keyboardType: TextInputType.text,
                  inputFormatters: [
                    FilteringTextInputFormatter.singleLineFormatter
                  ],
                  validator: passwordValidation,
                  onChanged: (value) {
                    setState(() {
                      _userEnteredPassword = value.trim();
                    });
                  },
                ),
                SizedBox(
                  height: 24,
                ),
                GestureDetector(
                  onTap: () async {
                    loadProgress();

                    if (signupformkey.currentState.validate()) {
                      Future registerWithEmailAndPassword() async {
                        UserCredential result = await FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                          email: _userEnteredEmail,
                          password: _userEnteredPassword,
                        );
                        User user = result.user;
                        //user.updateProfile(displayName: _name);
                        //added this line
                      }

                      //SharedPreferences prefs;
                      registerWithEmailAndPassword().then((_) async => {
                            //prefs = await SharedPreferences
                            // .getInstance(),
                            // prefs.setString(
                            // 'email', _emailsignup),
                            setState(() {
                              loadProgress();
                              Navigator.of(context).pop(true);
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text(
                                      'Please Wait...\nDo not press back button')));
                            }),
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Verifyscreen()))
                          });

                      if (visible) {
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
                      } else {
                        print("not validate");
                      }
                    }
                  },
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.all(
                        Radius.circular(25),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blueAccent.withOpacity(0.2),
                          spreadRadius: 3,
                          blurRadius: 4,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        "SIGN UP",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )),
        SizedBox(
          height: 24,
        ),
        Text(
          "Or Signup with",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: Colors.blueAccent,
            height: 1,
          ),
        ),
        SizedBox(
          height: 16,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Entypo.facebook_with_circle,
              size: 32,
              color: Colors.blueAccent,
            ),
            SizedBox(
              width: 24,
            ),
            Icon(
              Entypo.google__with_circle,
              size: 32,
              color: Colors.blueAccent,
            ),
          ],
        )
      ],
    );
  }
}
