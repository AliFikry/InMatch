import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:football/View/keys/keys.dart';
import 'package:football/View/pages/choose.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';

class RegisterController extends GetxController {
  final formKey = GlobalKey<FormState>();
  // String password;
  bool value = false;
  bool togglePasswordVisibility = false;
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController name = TextEditingController();
  String errorMessage = "";
  bool loading = false;

  Future createNewUser(TextEditingController email,
      TextEditingController password, BuildContext context) async {
    loading = true;
    update();
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: email.text.trim(),
        password: password.text.trim(),
      )
          .whenComplete(() {
        FirebaseAuth.instance.currentUser
            .updateDisplayName(name.text.toString().trim());
      }).then((value) async {
        // for (var i = 0; i < leagueId.length; i++) {
        //   await FirebaseFirestore.instance
        //       .collection(FirebaseAuth.instance.currentUser.uid
        //           .toString()) //FirebaseAuth.instance.currentUser.uid.toString()
        //       .doc(leagueId[i])
        //       .set({
        //     "name": leagueNameWithCountry[i],
        //     "id": leagueId[i],
        //     "leagueLogo": leagueFlag[i],
        //   });
        // }
        Get.to(() => ChooseLeague());
      });
    } on FirebaseAuthException catch (e) {
      print(e);
      errorMessage = e.message;
    }
    loading = false;
    update();
    // navigatorKey.currentState.popUntil((route) => route.isFirst);
  }

  void toggleVisibility() {
    togglePasswordVisibility = !togglePasswordVisibility;
    update();
  }
}
