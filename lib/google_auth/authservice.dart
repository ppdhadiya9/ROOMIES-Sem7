import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Authservice {
  Authservice() {
    Firebase.initializeApp();
  }
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googlesignin = GoogleSignIn();

  Future signinwithgoogle() async {
    try {
      final GoogleSignInAccount googleuser = await GoogleSignIn().signIn();
      print(googleuser);
      if (googleuser != null) {
        final GoogleSignInAuthentication googleauth =
            await googleuser.authentication;
        print(googleauth);
        final GoogleAuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleauth.idToken,
          accessToken: googleauth.accessToken,
        );
        print(credential);
        UserCredential usercreds =
            (await _auth.signInWithCredential(credential));

        if (usercreds != null) {}
      }
    } catch (e) {
      print(e);
    }
  }

  void signOutGoogle() async {}
}
