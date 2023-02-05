import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginController extends GetxController {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final formKey2 = GlobalKey<FormState>();
  bool isHidden = true;
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool togglePasswordVisibility = false;
  String errorMessage;
  bool loading = false;
  Future signIn() async {
    errorMessage = null;
    loading = true;
    update();
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email.text.trim(), password: password.text);
    } on FirebaseAuthException catch (e) {
      print(e.message);
      errorMessage = e.message;
    }
    loading = false;
    update();
  }

  void toggleVisibility() {
    togglePasswordVisibility = !togglePasswordVisibility;
    update();
  }

  Future<void> signInWithGoogle() async {
    GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;
    AuthCredential authCredential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);
    UserCredential authResult =
        await _auth.signInWithCredential(authCredential);
    User user = await _auth.currentUser;
    print('user email = ${user.email}');
  }
}
