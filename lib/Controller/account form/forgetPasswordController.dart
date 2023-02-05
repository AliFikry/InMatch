import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';

class ForgetPasswordController extends GetxController {
  final formKey = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  bool loading = false;
  DateTime loginClickTime;
  Future resetPassword() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: email.text.trim());
    } on FirebaseAuthException catch (e) {
      //  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Enter somethong here to display on snackbar")));
      // Get.snackbar("title", "message");
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     // backgroundColor: ,
      //     behavior: SnackBarBehavior.floating,
      //     content: Text(e.message),
      //   ),
      // );
    }
  }
}
