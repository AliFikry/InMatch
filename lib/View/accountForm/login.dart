// ignore_for_file: missing_return
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_svg/svg.dart';
import 'package:football/Controller/account%20form/loginController.dart';
import 'package:football/View/accountForm/forgotPassword.dart';
import 'package:football/View/accountForm/register.dart';
// import 'package:football/settings/newUser.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../keys/keys.dart';
// class WelcomePage extends StatelessWidget {
//   // const WelcomePage({ Key? key }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
// final AuthenticationService _auth = AuthenticationService();

// Size size = MediaQuery.of(context).size;
//     return
//   }

// }

class LoginPage extends StatelessWidget {
  LoginPage({Key key}) : super(key: key);
  // LoginController loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        // backgroundColor: Color(0XFF1E1E1E),
        body: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(33.w, 100.h, 32.w, 66.h),
              child: Text("Welcome back to InMatch",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                        color: Colors.white),
                  )),
            ),
            GetBuilder<LoginController>(
                init: LoginController(),
                builder: (loginController) {
                  return Form(
                    key: loginController.formKey,
                    child: ListView(
                      padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * .13,
                          vertical: 10),
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        TextFormField(
                          controller: loginController.email,
                          validator: MultiValidator([
                            EmailValidator(
                                errorText: 'enter a valid email address'),
                            RequiredValidator(
                                errorText: 'this field is required'),
                          ]),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                new RegExp(r'[a-zA-Z0-9@_.-]'))
                          ],
                          autofocus: false,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.white, width: 2.0),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            prefixIcon: SvgPicture.asset(
                              "assets/images/profile.svg",
                              height: 10,
                              width: 10,
                              fit: BoxFit.scaleDown,
                            ),
                            hintText: "Email",
                            fillColor: Colors.white,
                            hintStyle: TextStyle(
                              color: Color(0xFF828282),
                              fontSize: 16,
                              letterSpacing: 0.5,
                              fontWeight: FontWeight.w400,
                            ),
                            filled: true,
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.white, width: 2.0),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                          ),
                        ),
                        SizedBox(height: 20.h),
                        TextFormField(
                          controller: loginController.password,
                          inputFormatters: [
                            FilteringTextInputFormatter.deny(
                                new RegExp(r'[$%*&"!=]'))
                          ],
                          validator: MultiValidator([
                            RequiredValidator(
                                errorText: 'password is required'),
                            RequiredValidator(
                                errorText: 'this field is required'),
                            MinLengthValidator(6,
                                errorText:
                                    'password must be at least 8 digits long'),
                          ]),
                          obscureText: loginController.togglePasswordVisibility,
                          autofocus: false,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.white, width: 2.0),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            prefixIcon: SvgPicture.asset(
                              "assets/images/key-square.svg",
                              height: 10,
                              width: 10,
                              fit: BoxFit.scaleDown,
                            ),
                            suffixIcon: GestureDetector(
                              onTap: () {
                                loginController.toggleVisibility();
                              },
                              child: Icon(
                                !loginController.togglePasswordVisibility
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Color(0xFF828282),
                              ),
                            ),
                            hintText: "Password",
                            fillColor: Colors.white,
                            hintStyle: TextStyle(
                              color: Color(0xFF828282),
                              fontSize: 16,
                              letterSpacing: 0.5,
                              fontWeight: FontWeight.w400,
                            ),
                            filled: true,
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.white, width: 2.0),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => forgotPassword(),
                              ),
                            );
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5.h),
                            child: Row(
                              children: [
                                Spacer(),
                                Text(
                                  "forget password?",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 11,
                                  )),
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 50.h),
                        GestureDetector(
                          onTap: () {
                            loginController.signIn();
                          },
                          child: Padding(
                            padding: EdgeInsets.only(left: 75.w, right: 75.w),
                            child: Container(
                                padding: EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Color(0xFF34A853),
                                          Color(0xFF126026),
                                        ])),
                                child: loginController.loading
                                    ? Center(
                                        child: SizedBox(
                                        height: 25.h,
                                        width: 25.w,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      ))
                                    : Text(
                                        "Login",
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.poppins(
                                            textStyle: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w600,
                                        )),
                                      )),
                          ),
                        ),
                        SizedBox(height: 7.h),
                        loginController.errorMessage != null
                            ? Text(
                                "The password is invalid or the user does not have a password.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.red, fontSize: 12.sp),
                              )
                            : SizedBox(),
                        SizedBox(height: 7.h),
                        Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Don't have an account yet?",
                                style: GoogleFonts.quicksand(
                                  textStyle: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  // print("object");
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => Register(),
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: EdgeInsets.all(7.0),
                                  child: Text(
                                    "Register",
                                    style: GoogleFonts.quicksand(
                                      textStyle: TextStyle(
                                        color: Color(0xFF81C2FF),
                                        fontWeight: FontWeight.w500,
                                        fontSize: 13,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 20),
              child: Row(
                children: [
                  Expanded(
                      flex: 1,
                      child: Divider(
                        color: Color(0xFF828282),
                        height: 2,
                      )),
                  Expanded(
                      flex: 0,
                      child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 15.0),
                          child: Text(
                            "OR CONNECT WITH",
                            style: TextStyle(
                              fontSize: 12.0,
                              color: Color(0xFF828282),
                              // fontWeight: FontWeight.w200,
                            ),
                          ))),
                  Expanded(
                      flex: 1,
                      child: Divider(
                        color: Color(0xFF828282),
                        height: 2,
                      ))
                ],
              ),
            ),
            SizedBox(height: 3),
            GetBuilder<LoginController>(builder: (loginController) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 90.w),
                child: InkWell(
                  onTap: () async {
                    await loginController.signInWithGoogle();
                    // FirebaseAuth.instance.signOut();
                  },
                  child: Container(
                    // width: 100,
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15)),
                    child: FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Row(
                        children: [
                          Image.network(
                              'http://pngimg.com/uploads/google/google_PNG19635.png',
                              height: 25,
                              fit: BoxFit.cover),
                          SizedBox(width: 5),
                          Text(
                            "Sign in with Google",
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                              // color: Color(0XFFBDBDBD),
                              color: primaryColor,
                              letterSpacing: 0.5,
                              fontSize: 15,
                            )),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
            SizedBox(
              height: 20.h,
            )
          ],
        ),
      ),
    );
  }
}


// Size size = MediaQuery.of(context).size;
//     print(MediaQuery.of(context).size.height);
//     return