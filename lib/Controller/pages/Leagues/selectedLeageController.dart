import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:football/Controller/pages/mainController.dart';
import 'package:football/View/keys/keys.dart';
import 'package:collection/collection.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class SelectedLeageController extends GetxController {
  ScrollController scrollController = ScrollController();
  int pastCount = 0;
  List data = [];
  int selected = 0;
  int sub = 5;
  List elements = [
    "Team",
    "PTS",
    "PL",
    "GD",
  ];
  List flex = [
    7,
    2,
    2,
    2,
  ];
  List apiElement = [
    "team_name",
    "overall_league_PTS",
    "overall_league_payed",
    "overall_league_GF",
  ];

  var InfoInHashMap = [
    {
      0: {
        "Position": "overall_league_position",
        "Matches Played": "overall_league_payed",
        "Won": "overall_league_W",
        "Draw": "overall_league_D",
        "lost": "overall_league_L",
        "Goals For": "overall_league_GF",
        "Goals Against": "overall_league_GA",
        "Total points": "overall_league_PTS",
      },
      1: {
        "position": "home_league_position",
        "Matches Played": "home_league_payed",
        "Won": "home_league_W",
        "Draw": "home_league_D",
        "Lost": "home_league_L",
        "Goals For": "home_league_GF",
        "Goals Against": "home_league_GA",
        "Total points": "home_league_PTS",
      },
      2: {
        "position": "away_league_position",
        "Matches Played": "away_league_payed",
        "Won": "away_league_W",
        "Draw": "away_league_D",
        "Lost": "away_league_L",
        "Goals For": "away_league_GF",
        "Goals Against": "away_league_GA",
        "Total points": "away_league_PTS",
      }
    }
  ];
  int sumOfFlex;
  bool isShort = false;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    scrollController.dispose();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    scrollController.dispose();

    data.clear();
    print("dispose");
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    // data.clear();
    pastCount = 0;
    sumOfFlex = flex.reduce((value, element) => value + element);
    getPastMatches();
    // apiElement = home;
  }

  Future<void> getData() async {
    var res = await http.get(
      Uri.parse(
          'https://apiv3.apifootball.com/?action=get_standings&league_id=${Get.arguments[0]}&APIkey=$apiKey'),
    );
    // print(res.body);
    return jsonDecode(res.body);
  }

  Future<void> getPastMatches() async {
    var res = await http.get(
      Uri.parse(
          'https://apiv3.apifootball.com/?action=get_events&from=${DateFormat("yyyy-MM-dd").format(DateTime.now().subtract(
        Duration(days: 10),
      ))}&to=${DateFormat("yyyy-MM-dd").format(DateTime.now())}&timezone=GMT&league_id=${Get.arguments[0]}&APIkey=$apiKey'),
    );
    var json = await jsonDecode(res.body);

    // print();
    pastCount = jsonDecode(res.body).length;
    update();

    return json;
  }

  Future<void> getFutureMatches() async {
    var res = await http.get(
      Uri.parse(
          'https://apiv3.apifootball.com/?action=get_events&from=${DateFormat("yyyy-MM-dd").format(DateTime.now().add(
        Duration(days: 1),
      ))}&to=${DateFormat("yyyy-MM-dd").format(DateTime.now().add(Duration(days: 10)))}&timezone=GMT&league_id=${Get.arguments[0]}&APIkey=$apiKey'),
    );
    var json = await jsonDecode(res.body);

    // print(res.body);
    return json;
  }

  String dateFormater(String date) {
    var dateParse = DateFormat("dd MMM").format(
      DateTime.parse(
        date,
      ),
    );
    return dateParse.toString();
  }

  String parseTimeToLocalTime(String time) {
    // ignore: unnecessary_statements
    var t = (int.parse(DateFormat("hh:mm").parse(time).hour.toString()) +
                DateTime.now().timeZoneOffset.inHours)
            .toString() +
        ":" +
        DateFormat("hh:mm").parse(time).minute.toString();
    if (Get.put(MainScreenController()).is24HourFormat) {
      print(Get.put(MainScreenController()).is24HourFormat);
      return t;
    } else {
      return DateFormat("h:mm a").format(DateFormat("hh:mm").parse(t));
    }
    // return DateFormat("h:mm a").format(DateFormat("hh:mm").parse(t));
  }

  calculateGD(String GF, String GA) {
    return int.parse(GF) - int.parse(GA);
  }

  Future<void> modal(BuildContext context) => showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container();
        },
      );
}
