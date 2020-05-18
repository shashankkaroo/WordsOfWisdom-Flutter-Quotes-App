import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:wordsofwisdom/main.dart';

class GoogleLogin {
  static GoogleSignIn _googleSignIn = new GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  static FirebaseAuth _auth = FirebaseAuth.instance;

  static logout(context) async {
    try {
      await _auth.signOut().then((value) {
        Navigator.pushReplacement(
            context, CupertinoPageRoute(builder: (context) => MyHomePage()));
      });
      // signed out
    } catch (e) {
      // an error
    }
  }

  static Future<FirebaseUser> getCurrentUser() async {
    return await _auth.currentUser();
  }

  static Future<FirebaseUser> signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount =
        await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final AuthResult authResult = await _auth.signInWithCredential(credential);
    final FirebaseUser user = authResult.user;

    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);

    return user;
  }
}
