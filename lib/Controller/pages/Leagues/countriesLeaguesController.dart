import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:football/Controller/pages/Leagues/countriesController.dart';
import 'package:football/View/pages/League/selectedLeague.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';

import '../../../View/pages/League/countriesLeagues.dart';

class CountriesLeaguesController extends GetxController {
  List<Widget> data = <Widget>[];
  List selectedData = [];

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    FirebaseDatabase.instance
        .reference()
        .child(
            '/countriesLeagues/${Get.put(CountriesController()).selectedLeague}/')
        // .orderByChild('name')
        .once()
        .then((value) => getData(value));
  }

  void addToSelectedData(String id, String name, String leagueLogo) {
    selectedData.clear();
    selectedData.add(id);
    selectedData.add(name);
    selectedData.add(leagueLogo);
    // print(selectedData);
  }

  void getData(DataSnapshot snapshot) {
    for (var i = 0; i < snapshot.value.length; i++) {
      data.add(
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 0.h),
          child: GestureDetector(
            onTap: () {
              addToSelectedData(
                  snapshot.value[i]["league_id"].toString(),
                  snapshot.value[i]["name"].toString(),
                  snapshot.value[i]["league_logo"].toString());
              Get.to(() => SelectedLeague(), arguments: [
                snapshot.value[i]["league_id"].toString(),
                snapshot.value[i]["name"].toString(),
                snapshot.value[i]["league_logo"].toString(),
              ]);

              // updateSelectedLeague(snapshot.value[i]["id"]);
            },
            child: Card(
              child: ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
                title: Text(
                  snapshot.value[i]["name"],
                ),
                leading: Image.asset(
                  "assets/leagues_icons/${snapshot.value[i]["league_id"]}.jpeg",
                  // "assets/leagues_icons/302.jpeg"
                  width: 35.w,
                  height: 35.h,
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Icons.error,
                    size: 30,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      update();
    }
    // .then((DataSnapshot snapshot
  }
}
