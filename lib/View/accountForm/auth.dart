import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:football/main.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthenticationService with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //register
  Future createNewUser(
      String email, String password, BuildContext context) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      User user = result.user;
      return user;
    } catch (e) {
      print(e.toString());
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              // title: Text("Error"),
              content: Text(e.toString().substring(37)),
            );
          });
    }
  }
  //login

  Future loginUser(String email, String password, BuildContext context) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return result.user;
    } catch (e) {
      print(e.toString());
      return showDialog(
          // barrierColor: Colors.green,
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: Colors.white,
              elevation: 10,
              title: Text(
                "Error",
                style: TextStyle(color: Colors.black),
              ),
              content: Text(
                e.toString().substring(31),
                style: TextStyle(color: Colors.black),
              ),
              // backgroundColor: Colors.green,
            );
          });
    }
  }

//reset password
  Future resetPassword(String email, BuildContext context) async {
    try {
      if (FirebaseAuth.instance.sendPasswordResetEmail(email: email) == true) {
        print("object");
      } else {
        print("object1");
      }
    } catch (e) {
      print(e.toString());
      return showDialog(
          // barrierColor: Colors.green,
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: Colors.white,
              elevation: 10,
              title: Text(
                "Error",
                style: TextStyle(color: Colors.black),
              ),
              content: Text(
                e.toString().substring(31),
                style: TextStyle(color: Colors.black),
              ),
              // backgroundColor: Colors.green,
            );
          });
    }
  }

  // GoogleSignInAccount _user;
  // GoogleSignInAccount get user => _user;

  // Future signInWithGoogle() async {
  //   final googleUser = await GoogleSignIn().signIn();
  //   if (googleUser == null) return;
  //   // googlesignina
  //   _user = googleUser;
  //   final googleAuth = await googleUser.authentication;
  //   final credential = GoogleAuthProvider.credential(
  //     accessToken: googleAuth.accessToken,
  //     idToken: googleAuth.idToken,
  //   );
  //   await _auth.signInWithCredential(credential).catchError((e) {
  //     print(e);
  //   });
  // }

  // var _googleSignIn = GoogleSignIn();

  ///sign out
  Future signOut() async {
    try {
      return _auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }
}
