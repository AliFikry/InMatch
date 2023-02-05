// ignore_for_file: deprecated_member_use, invalid_use_of_visible_for_testing_member

import 'package:device_preview/device_preview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:football/Controller/themes/themeController.dart';
import 'package:football/View/accountForm/login.dart';
import 'package:football/View/pages/main.dart';
import 'package:get/get.dart';
// import 'package:football/theme.dart';
// import 'firebase_options.dart';
// import 'package:splashscreen/splashscreen.dart';
// import 'Home.dart';

// String DarkMode = "false";
List leagueNameStorage, leagueIdStorage;
var prefs;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    // MyApp(),
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => MyApp(), // Wrap your app
    ),
  );
}

bool isLogin = false;
final navigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

class splashScreen extends StatelessWidget {
  // const splashScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // title: "",
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: ScreenUtilInit(
            designSize: const Size(375, 812),
            builder: (BuildContext context, Widget child) {
              return MyApp();
            }),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (BuildContext context, Widget child) => GetBuilder<
              ThemeController>(
          init: ThemeController(),
          builder: (themeController) {
            return GetMaterialApp(
              theme: ThemeData(
                brightness: Brightness.light,
                fontFamily: 'poppins',
                appBarTheme: AppBarTheme(backgroundColor: Color(0xFF9394a5)),
                tabBarTheme: TabBarTheme(
                  labelColor: Colors.black,
                  // indicatorSize: TabBarIndicatorSize.label,
                  indicator:
                      BoxDecoration(color: Colors.grey[300].withOpacity(0.25)),
                  labelStyle:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 15.sp),
                ),
                expansionTileTheme: ExpansionTileThemeData(
                    textColor: Colors.black,
                    iconColor: Colors.black,
                    collapsedIconColor: Colors.black),
              ),
              darkTheme: ThemeData(
                //dark
                brightness: Brightness.dark,
                // appBarTheme: AppBarTheme,
                scaffoldBackgroundColor: Color(0xFF222222),
                bottomNavigationBarTheme: BottomNavigationBarThemeData(
                    backgroundColor: Color(0xFF222222)),
                listTileTheme: ListTileThemeData(tileColor: Color(0xFF3F3F3F)),
                cardTheme: CardTheme(color: Color(0xFF3F3F3F)),
                tabBarTheme: TabBarTheme(
                  labelColor: Colors.black,
                  indicator:
                      BoxDecoration(color: Colors.white38.withOpacity(0.15)),
                  labelStyle:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 15.sp),
                ),
                expansionTileTheme: ExpansionTileThemeData(
                    textColor: Colors.white,
                    iconColor: Colors.white,
                    collapsedIconColor: Colors.white),
              ),
              themeMode:
                  themeController.isDark ? ThemeMode.dark : ThemeMode.light,
              home: Scaffold(
                key: _scaffoldKey,
                resizeToAvoidBottomInset: false,
                body: StreamBuilder(
                  stream: FirebaseAuth.instance.authStateChanges(),
                  builder: (context, snapshot) {
                    // print(snapshot);
                    // print(FirebaseAuth.instance.currentUser);
                    if (snapshot.hasData) {
                      return MainScreen();
                    } else {
                      return LoginPage();
                    }
                  },
                ),
              ),
              debugShowCheckedModeBanner: false,
            );
          }),
    );
  }
}
