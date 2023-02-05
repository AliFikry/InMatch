import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:football/Controller/pages/mainController.dart';
import 'package:football/Controller/themes/themeController.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MainScreenController>(
        init: MainScreenController(),
        builder: (mainScreenController) {
          return Scaffold(
            drawer: DrawerWidget(mainScreenController: mainScreenController),
            appBar: AppBar(
              title: Text(
                mainScreenController.selectedIndex == 0
                    ? "InMatch"
                    : mainScreenController.selectedIndex == 1
                        ? "Countries"
                        : "Leagues",
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(10.r),
                ),
              ),
              actions: [
                // GetBuilder<ThemeController>(builder: (themeController) {
                //   return IconButton(
                //     onPressed: () {
                //       themeController.toggleMode();
                //     },
                //     icon: Icon(Icons.dark_mode),
                //   );
                // }),
                mainScreenController.selectedIndex == 0
                    ? IconButton(
                        onPressed: () async {
                          DateTime pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2022, 6, 1),
                              //DateTime.now() - not to allow to choose before today.
                              lastDate: DateTime(2023, 12, 31));

                          print(pickedDate);
                        },
                        icon: Icon(Icons.calendar_month_rounded),
                      )
                    : SizedBox(),
              ],
            ),
            body:
                mainScreenController.pages[mainScreenController.selectedIndex],
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: mainScreenController.selectedIndex,
              onTap: mainScreenController.onTap,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: "Home",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.emoji_events),
                  label: "Leagues",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.emoji_events),
                  label: "Leagues",
                ),
              ],
            ),
          );
        });
  }
}

class DrawerWidget extends StatelessWidget {
  final MainScreenController mainScreenController;
  const DrawerWidget({
    Key key,
    this.mainScreenController,
  }) : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          DrawerHeader(
            child: Center(
              child: ListTile(
                tileColor: Colors.transparent,
                title: Text(
                  "Hello,",
                  style: TextStyle(fontSize: 25.sp),
                ),
                subtitle: Text(
                  FirebaseAuth.instance.currentUser.displayName,
                  style: TextStyle(
                      // color: Get.theme.primaryColor,
                      fontSize: 23.sp,
                      letterSpacing: 1),
                ),
                trailing: IconButton(
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                    },
                    icon: Icon(Icons.logout)),
              ),
            ),
          ),
          ListTile(
            tileColor: Colors.transparent,
            title: Text(
              "Time Format",
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: Text(
              "12/24 Hours",
              style: TextStyle(
                fontSize: 10.sp,
              ),
            ),
            trailing: Switch(
              value: mainScreenController.is24HourFormat,
              onChanged: (value) {
                mainScreenController.toggleTimeFormat();
              },
            ),
          ),
          GetBuilder<ThemeController>(builder: (themeController) {
            return ListTile(
              tileColor: Colors.transparent,
              title: Text(
                "Dark mode",
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              trailing: Switch(
                value: themeController.isDark,
                onChanged: (value) async {
                  themeController.toggleMode();
                  // Directory appDocDir =
                  //     await getApplicationDocumentsDirectory();
                  // String appDocPath = appDocDir.path;

                  // var file = await File(appDocDir.path + "/theme.txt")
                  //     .writeAsString("contents");
                  // File(appDocDir.path + "/theme.txt").delete();

                  // // var appDocPath = appDocDir.exists().toString()
                  // var read =
                  //     await File(appDocDir.path + "/theme.txt").readAsLines();
                  // var r = await File(appDocPath + "/darkMode.txt").exists();
                  // print(r);
                },
              ),
            );
          }),
          ListTile(
            tileColor: Colors.transparent,
            title: Text(
              "Privacy & Policy",
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          )
        ],
      ),
    );
  }
}
