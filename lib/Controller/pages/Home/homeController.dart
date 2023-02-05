import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:football/Controller/pages/mainController.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'package:football/View/keys/keys.dart';
import 'package:get/state_manager.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';

class HomeController extends GetxController {
  MainScreenController mainScreenController = Get.put(MainScreenController());
  List favLeaguesId = [];
  List favLeaguesName = [];
  List elements = [];
  List<Widget> matches = <Widget>[];
  bool isLoading = true;
  List isExpanded = [];

  Future<void> retriveFavorite() async {
    // favourites
    await FirebaseFirestore.instance
        .collection(FirebaseAuth.instance.currentUser.uid)
        .doc("favourites")
        .get()
        .then((value) async {
      favLeaguesId = await value.data()['leaguesId'];
      favLeaguesName = await value.data()['leaguesName'];
      // isExpanded = List<bool>.filled(favLeaguesId.length, true);
      update();
    });
  }

  @override
  void onInit() {
    super.onInit();
    retriveFavorite();
    // getData();
  }

  void updateExpanded(int index) {
    isExpanded[index] = !isExpanded[index];
    update();
  }

  String parseTimeToLocalTime(String time) {
    // ignore: unnecessary_statements
    var t = (int.parse(DateFormat("hh:mm").parse(time).hour.toString()) +
                DateTime.now().timeZoneOffset.inHours)
            .toString() +
        ":" +
        DateFormat("hh:mm").parse(time).minute.toString();
    if (mainScreenController.is24HourFormat) {
      return t;
    } else {
      return DateFormat("h:mm a").format(DateFormat("hh:mm").parse(t));
    }
    // return DateFormat("h:mm a").format(DateFormat("hh:mm").parse(t));
  }
}
