import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:football/Controller/pages/Home/homeController.dart';
import 'package:football/Controller/themes/themeController.dart';
import 'package:football/View/pages/League/selectedLeague.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:intl/intl.dart';
import '../../keys/keys.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          SizedBox(height: 5.h),
          Card(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Trending Leagues",
                  style:
                      TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
                ),
              ),
              Divider(),
              SizedBox(
                height: 70,
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: leagueId.length,
                  itemBuilder: (context, index) => Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: GestureDetector(
                      onTap: () {
                        Get.to(() => SelectedLeague(), arguments: [
                          leagueId[index].toString(),
                          leagueName[index].toString(),
                          leagueFlag[index].toString(),
                        ]);
                      },
                      child: ClipRRect(
                        // backgroundColor: Colors.transparent,
                        // radius: 30.r,
                        borderRadius: BorderRadius.circular(360.r),
                        child: Image.network(
                          leagueFlag[index],
                          cacheHeight: 200,
                          cacheWidth: 200,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10.h),
            ],
          )),
          GetBuilder<HomeController>(
            init: HomeController(),
            builder: (HomeController controller) {
              controller.retriveFavorite();
              return FirebaseAnimatedList(
                shrinkWrap: true,
                query: FirebaseDatabase.instance
                    .reference()
                    .child('match/2023-01-25/'),
                defaultChild: Center(
                  child: CircularProgressIndicator(),
                ),
                itemBuilder: (context, snapshot, animation, index) {
                  controller.isExpanded.add(true);
                  return controller.favLeaguesName
                          .contains(snapshot.key.toString().substring(
                                0,
                                snapshot.key.toString().lastIndexOf('-'),
                              ))
                      ? Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.h),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.r),
                            ),

                            // borderRadius: BorderRadius.circular(10.r),
                            child: ExpansionPanelList(
                              expansionCallback: (panelIndex, isExpanded) =>
                                  {controller.updateExpanded(index)},
                              children: [
                                ExpansionPanel(
                                  isExpanded: controller.isExpanded[index],
                                  headerBuilder: (context, isExpanded) =>
                                      ListTile(
                                    tileColor: Colors.transparent,
                                    dense: true,
                                    title: GestureDetector(
                                      onTap: () {
                                        // var l = List.filled(20, true);
                                        print(controller.isExpanded[index]);
                                      },
                                      child: Text(
                                        snapshot.key.toString().substring(
                                              0,
                                              snapshot.key
                                                  .toString()
                                                  .lastIndexOf('-'),
                                            ),
                                        // snapshot.value.length.toString(),
                                        style: TextStyle(
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    leading: CircleAvatar(
                                      radius: 20.r,
                                      backgroundColor: Colors.transparent,
                                      child: Image.asset(
                                        "assets/leagues_icons/${snapshot.key.toString().substring(
                                              snapshot.key
                                                      .toString()
                                                      .lastIndexOf('-') +
                                                  1,
                                            )}.jpeg",
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                Icon(
                                          Icons.error,
                                        ),
                                        width: 50.w,
                                        height: 50.h,
                                      ),
                                    ),
                                  ),
                                  body: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: snapshot.value.length,
                                    itemBuilder: (context, index) {
                                      return panels(
                                          snapshot, controller, context, index);
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      : SizedBox();
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget panels(DataSnapshot snapshot, HomeController controller,
      BuildContext context, int index) {
    var snapshotKey =
        snapshot.value[snapshot.value.keys.toList()[index].toString()];
    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Get.theme.dividerColor)),
      ),
      child: ListTile(
        // tileColor: Colors.transparent,
        title: Row(
          children: [
            Expanded(
              flex: 10,
              child: Row(
                children: [
                  Expanded(
                    flex: 7,
                    child: Text(
                      snapshotKey["data"]["match_hometeam_name"].toString(),
                      textAlign: TextAlign.end,
                      overflow: TextOverflow.clip,
                      style: TextStyle(
                        // color:,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Spacer(),
                  Expanded(
                    flex: 3,
                    child: Image.network(
                      snapshotKey["data"]["team_home_badge"].toString(),
                      errorBuilder: (context, error, stackTrace) =>
                          Icon(Icons.error),
                      // height: 20.h,
                      // width: 20.w,
                    ),
                  ),
                ],
              ),
            ),
            // Spacer(),
            Expanded(
              flex: 4,
              child: GestureDetector(
                onTap: () {
                  print(snapshotKey["data"]["match_time"]);
                  // print(DateTime.now().timeZoneOffset.inHours);
                  DateTime time = DateFormat("hh:mm")
                      .parse(snapshotKey["data"]["match_time"]);
                  print((int.parse(DateFormat("hh:mm")
                                  .parse(snapshotKey["data"]["match_time"])
                                  .hour
                                  .toString()) +
                              DateTime.now().timeZoneOffset.inHours)
                          .toString() +
                      ":" +
                      DateFormat("hh:mm")
                          .parse(snapshotKey["data"]["match_time"])
                          .minute
                          .toString());
                  // print(DateTime.parse('2020-01-02 07'));
                },
                child: Text(
                  snapshotKey["data"]["match_status"] != "Finished"
                      ? snapshotKey["data"]["match_hometeam_ft_score"]
                              .toString() +
                          " - " +
                          snapshotKey["data"]["match_awayteam_ft_score"]
                              .toString()
                      : controller.parseTimeToLocalTime(
                          snapshotKey["data"]["match_time"]),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    // color:,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 10,
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Image.network(
                      snapshotKey["data"]["team_away_badge"].toString(),
                      errorBuilder: (context, error, stackTrace) =>
                          Icon(Icons.error),
                      // height: 20.h,
                      // width: 20.w,
                    ),
                  ),
                  Spacer(),
                  Expanded(
                    flex: 7,
                    child: Text(
                      snapshotKey["data"]["match_awayteam_name"].toString(),
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.clip,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ExpansionTile(
//                   initiallyExpanded: true,
//                   // iconColor: Theme.of(context).primaryColor,
//                   leading: CircleAvatar(
//                     radius: 20.r,
//                     backgroundColor: Colors.transparent,
//                     child: Image.asset(
//                       "assets/leagues_icons/${controller.favLeaguesName[index]}.jpeg",
//                       errorBuilder: (context, error, stackTrace) => Icon(
//                         Icons.error,
//                       ),
//                       width: 50.w,
//                       height: 50.h,
//                     ),
//                   ),
//                   title: Text(
//                     controller.favLeaguesName[index].toString(),
//                     // style: Theme.of(context).textTheme.bodyLarge
//                   ),
//                   children: [
//                     FirebaseAnimatedList(
//                       defaultChild: Center(
//                         child: CircularProgressIndicator(),
//                       ),
//                       shrinkWrap: true,
//                       sort: (a, b) =>
//                           a.value['time'].compareTo(b.value['time']),
//                       physics: NeverScrollableScrollPhysics(),
//                       query: FirebaseDatabase.instance.reference().child(
//                           'match/2023-01-25/${controller.favLeaguesName[index].toString()}-${controller.favLeaguesId[index].toString()}'),
//                       itemBuilder: (context, snapshot, animation, int index) =>
//                           // Text(snapshot.toString()),
//                           panels(snapshot, controller, context),
//                     ),
//                   ],
//                 ),
