import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:football/Controller/account%20form/forgetPasswordController.dart';
// import 'package:football/keys/keys.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

final _scaffoldKey = new GlobalKey<ScaffoldState>();

class forgotPassword extends StatefulWidget {
  // const forgotPassword({ Key? key }) : super(key: key);

  @override
  _forgotPasswordState createState() => _forgotPasswordState();
}

class _forgotPasswordState extends State<forgotPassword> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return MaterialApp(
      home: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        backgroundColor: Color(0xFF1E1E1E),
        body: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: NeverScrollableScrollPhysics(),
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(33.w, 123.h, 32.w, 29.h),
              child: Text(
                "Ohh No..!",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                        color: Color(0xFFF5F5F5),
                        fontWeight: FontWeight.w600,
                        fontSize: 24,
                        letterSpacing: 0.5)),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(37.w, 0, 28.h, 55.h),
              child: Text(
                "Please enter your email to reset password",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                      color: Color(0xFFF5F5F5),
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      letterSpacing: 0.5),
                ),
              ),
            ),
            GetBuilder<ForgetPasswordController>(
                init: ForgetPasswordController(),
                builder: (forgetPasswordController) {
                  return Form(
                    key: forgetPasswordController.formKey,
                    child: ListView(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 33.w),
                          child: TextFormField(
                            controller: forgetPasswordController.email,
                            validator: MultiValidator([
                              RequiredValidator(
                                  errorText: 'this field is required'),
                              EmailValidator(errorText: "enter valid email")
                            ]),
                            autofocus: true,
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
                        ),
                        GestureDetector(
                          onTap: () {
                            final _isValid = forgetPasswordController
                                .formKey.currentState
                                .validate();
                            // if (_isValid) {
                            //   // isRedundentClick.call(true)

                            //   if (isRedundentClick(DateTime.now())) {
                            //     print('hold on, processing');
                            //   }
                            //   resetPassword();
                            // }
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 91.w, vertical: 53.h),
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
                              child: Text(
                                "Reset",
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
                      ],
                    ),
                  );
                })
          ],
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}




  // bool isRedundentClick(DateTime currentTime) {
  //   if (loginClickTime == null) {
  //     loginClickTime = currentTime;
  //     print("first click");
  //     return false;
  //   }
  //   print('diff is ${currentTime.difference(loginClickTime).inSeconds}');
  //   if (currentTime.difference(loginClickTime).inSeconds < 1) {
  //     //set this difference time in seconds
  //     return true;
  //   }

  //   loginClickTime = currentTime;
  //   return false;
  // }