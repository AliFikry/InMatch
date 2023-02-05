import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:football/Controller/account%20form/registerController.dart';
import 'package:football/View/accountForm/login.dart';
// import 'package:football/accountForm/verify.dart';
import 'package:football/View/keys/keys.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class Register extends StatefulWidget {
  // const register({ Key? key }) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

class _RegisterState extends State<Register> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      // backgroundColor: Color(0xFF1E1E1E),
      body: ListView(
        children: [
          SizedBox(height: 100.h),
          Container(
            padding: EdgeInsets.only(left: 46.w, right: 47.w, bottom: 47.h),
            child: Text(
              "Sign up now to keep up with lates news",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                      color: Color(0xFFF5F5F5),
                      fontWeight: FontWeight.w600,
                      fontSize: 24,
                      letterSpacing: 0.5)),
            ),
          ),
          GetBuilder<RegisterController>(
              init: RegisterController(),
              builder: (registerController) {
                return Form(
                  key: registerController.formKey,
                  child: ListView(
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * .13,
                        vertical: 10),
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      TextFormField(
                        controller: registerController.name,
                        textCapitalization: TextCapitalization.words,
                        validator: MultiValidator([
                          // EmailValidator(errorText: 'enter a valid email address')
                          RequiredValidator(errorText: 'this field is required')
                        ]),
                        // inputFormatters: [
                        //   FilteringTextInputFormatter.allow(
                        //       new RegExp(r'[a-zA-Z0-9@_.-]'))
                        // ],
                        autofocus: false,
                        style: TextStyle(color: Colors.black),
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
                          hintText: "Full Name",
                          fillColor: Colors.white,
                          // labelStyle: ,
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
                        controller: registerController.email,
                        validator: MultiValidator([
                          EmailValidator(
                              errorText: 'enter a valid email address'),
                          RequiredValidator(errorText: 'this field is required')
                        ]),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              new RegExp(r'[a-zA-Z0-9@_.-]'))
                        ],
                        autofocus: false,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.white, width: 2.0),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          prefixIcon: SvgPicture.asset(
                            "assets/images/sms.svg",
                            height: 10,
                            width: 10,
                            fit: BoxFit.scaleDown,
                          ),
                          hintText: "Email",
                          fillColor: Colors.white,
                          hintStyle: TextStyle(
                            color: Color(0xFF828282),
                            fontSize: 16.sp,
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
                        controller: registerController.password,
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(
                              new RegExp(r'[$%*&"!=]'))
                        ],
                        validator: MultiValidator([
                          RequiredValidator(errorText: 'password is required'),
                          RequiredValidator(
                              errorText: 'this field is required'),
                          MinLengthValidator(6,
                              errorText:
                                  'password must be at least 6 digits long'),
                        ]),
                        obscureText:
                            registerController.togglePasswordVisibility,
                        autofocus: false,
                        style: TextStyle(color: Colors.black),
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
                              registerController.toggleVisibility();
                            },
                            child: Icon(
                              registerController.togglePasswordVisibility
                                  ? Icons.visibility_off
                                  : Icons.visibility,
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
                      SizedBox(height: 74.h),
                      GestureDetector(
                        onTap: () {
                          // print(_name.text.trim().toString());
                          final _isValid = registerController
                              .formKey.currentState
                              .validate();
                          if (_isValid) {
                            print("true");
                            // if (isRedundentClick(DateTime.now())) {
                            //   print("long press");
                            //   return;
                            // }
                            registerController.createNewUser(
                                registerController.email,
                                registerController.password,
                                context);
                          }
                        },
                        child: Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: Get.width * .07),
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
                            child: registerController.loading
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
                                    "Register",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    )),
                                  ),
                          ),
                        ),
                      ),
                      SizedBox(height: 7.h),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "You have account?",
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
                                Get.back();
                              },
                              child: Padding(
                                padding: EdgeInsets.all(7.0),
                                child: Text(
                                  "Login",
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
                      SizedBox(height: 10.h),
                      Text(
                        registerController.errorMessage,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                );
              }),
        ],
      ),
    );
  }

  void showInSnackBar(String value) {
    // _scaffoldKey.currentState
    //     .showSnackBar(new SnackBar(content: new Text(value)));
  }
}
