import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:football/Controller/pages/Home/homeController.dart';
import 'package:football/View/pages/Home/home.dart';
import 'package:football/View/pages/League/countries.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

class MainScreenController extends GetxController {
  int selectedIndex = 0;
  bool is24HourFormat = true;
  @override
  Future<void> onInit() async {
    // TODO: implement onInit
    super.onInit();

    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    is24HourFormat =
        await File(appDocPath + "/timeFormat.txt").readAsString().toString() ==
                "true"
            ? true
            : false;
    var exists = await File(appDocPath + "/timeFormat.txt").exists();
    if (exists) {
      is24HourFormat =
          await File(appDocPath + "/timeFormat.txt").readAsString() == "true"
              ? true
              : false;
      update();
    } else {
      is24HourFormat = true;
      update();
    }
  }

  List pages = [
    HomeScreen(),
    Countries(),
    Container(),
  ];

  Future<void> toggleTimeFormat() async {
    is24HourFormat = !is24HourFormat;
    Get.put(HomeController()).retriveFavorite();

    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    var file = File(appDocPath + "/timeFormat.txt")
        .writeAsStringSync(is24HourFormat.toString());
    update();

    update();
  }

  onTap(int index) {
    selectedIndex = index;

    update();
    print(selectedIndex);
  }

  //https://apiv3.apifootball.com/?action=get_events&from=2023-01-25&to=2023-01-25&APIkey=

}
