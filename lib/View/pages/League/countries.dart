import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:football/Controller/pages/Leagues/countriesController.dart';
import 'package:football/View/keys/json.dart';
import 'package:football/View/keys/keys.dart';
import 'package:football/View/pages/League/countriesLeagues.dart';
import 'package:get/get.dart';

class Countries extends StatelessWidget {
  const Countries({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: CountriesController(),
      builder: (CountriesController controller) {
        return Scaffold(
            body: ListView(
              controller: controller.scrollController,
              children: [
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
                  child: TextField(
                    controller: controller.searchController,
                    onChanged: (value) {
                      controller.search();
                      print(value);
                    },
                    decoration: InputDecoration(
                      labelText: "Search",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          controller.clearData();
                          controller.searchController.clear();
                          controller.search();
                          FocusScope.of(context).unfocus();
                        },
                        child: Icon(Icons.close),
                      ),
                    ),
                  ),
                ),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      child: GestureDetector(
                        onTap: () async {
                          // print(snapshot.value[i]["name"]);
                          controller
                              .updateSelectedLeague(JsonLeagues[index]["id"]);
                          Get.to(() => CountriesLeagues());
                        },
                        child: ListTile(
                          tileColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          title: Text(
                            JsonLeagues[index]["name"],
                          ),
                          leading: Image.asset(
                            "assets/country_icons/${JsonLeagues[index]["id"].toString().toLowerCase()}.jpeg",
                            errorBuilder: (context, error, stackTrace) => Icon(
                              Icons.error,
                              size: 30,
                            ),
                            width: 35.w,
                            height: 35.h,
                          ),
                        ),
                      ),
                    );
                    // return controller.search("i", index)
                    //     ? Text(controller.data[index]["name"].toString())
                    //     : SizedBox();
                  },
                  // children: [],
                  itemCount: JsonLeagues.length,
                ),
              ],
            ),
            floatingActionButton: controller.scrollPlace
                ? FloatingActionButton(
                    onPressed: () {
                      controller.scrollController.animateTo(
                        0,
                        duration: Duration(milliseconds: 500),
                        curve: Curves.easeIn,
                      );
                    },
                    child: Icon(Icons.arrow_upward),
                  )
                : null);
      },
    );
  }
}
