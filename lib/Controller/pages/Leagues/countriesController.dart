import 'dart:collection';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:football/View/pages/League/countriesLeagues.dart';
import 'package:get/get.dart';

class CountriesController extends GetxController {
  // final _countries = [].obs;
  // List<Country> get countries => _countries.value;
  // set countries(List<Country> value) => _countries.value = value;

  List<Widget> data = <Widget>[];
  DataSnapshot snapshot;
  final scrollController = ScrollController();
  bool scrollPlace = false;
  String selectedLeague = "";
  TextEditingController searchController = TextEditingController();

  @override
  void onInit() {
    // readData();
    selectedLeague = "";
    super.onInit();
    scrollController.addListener(() {
      if (scrollController.position.pixels > 500.0) {
        updateScrollPlace(true);
        // print(scrollController.position.pixels);
      } else {
        updateScrollPlace(false);
      }
    });
    FirebaseDatabase.instance
        .reference()
        .child('test1/')
        .orderByChild('name')
        .once()
        .then((DataSnapshot snapshot) {
      // print(data[0]["name"].toString().contains('ujjkjkjkjk'));
      this.snapshot = snapshot;
      update();
    }).then((value) => search());
    // l("e");
  }

  void readData() {}
  updateScrollPlace(bool value) {
    if (scrollPlace != value) {
      scrollPlace = value;
      update();
      print(value);
    }
  }

  void clearData() {
    data.clear();
    update();
  }

  updateSelectedLeague(String value) {
    selectedLeague = value;
    update();
    print(value);
  }

  void search() {
    // print(snapshot.value);
    if (searchController.text != "") {
      data.clear();
    }
    for (var i = 0; i < snapshot.value.length; i++) {
      if (snapshot.value[i]["name"]
          .toString()
          .toLowerCase()
          .contains(searchController.text.toLowerCase())) {
        if (snapshot.value[i]["name"] != "Israel") {
          data.add(
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 0.h),
              child: Card(
                child: GestureDetector(
                  onTap: () async {
                    print(snapshot.value[i]["name"]);
                    updateSelectedLeague(snapshot.value[i]["id"]);
                    Get.to(() => CountriesLeagues());
                  },
                  child: ListTile(
                    tileColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    title: Text(
                      snapshot.value[i]["name"],
                    ),
                    leading: Image.asset(
                      "assets/country_icons/${snapshot.value[i]["id"].toString().toLowerCase()}.jpeg",
                      errorBuilder: (context, error, stackTrace) => Icon(
                        Icons.error,
                        size: 30,
                      ),
                      width: 35.w,
                      height: 35.h,
                    ),
                  ),
                ),
              ),
            ),
          );
        }
      }
    }
    update();
  }
}
