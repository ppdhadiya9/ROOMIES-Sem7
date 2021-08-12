import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_app/Screens/ProfileBuild.dart';

class Verifyscreen extends StatefulWidget {
  @override
  _VerifyscreenState createState() => _VerifyscreenState();
}

class _VerifyscreenState extends State<Verifyscreen> {
  final _auth = FirebaseAuth.instance;
  User user;
  Timer timer;

  @override
  void initState() {
    user = _auth.currentUser;
    user.sendEmailVerification();

    timer = Timer.periodic(Duration(seconds: 3), (timer) {
      checkemail();
    });

    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: CircularProgressIndicator(),

              ///
            ),
            // Center(
            //   child: LinearProgressIndicator(),
            // ),
            SizedBox(
              height: 10.0,
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                  "Welcome !!! \nPlease Verify Your Email First .......\nEmail sent on ${user.email}"),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> checkemail() async {
    user = _auth.currentUser;
    await user.reload();

    if (user.emailVerified) {
      timer.cancel();
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => ProfilePage()));
    }
  }
}
