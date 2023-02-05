import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:football/Controller/pages/Leagues/selectedLeageController.dart';
// import 'package:football/Controller/pages/Lea';
import 'package:football/View/keys/keys.dart';
import 'package:football/View/pages/League/matchInformation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
// import 'sel';

class SelectedLeague extends StatelessWidget {
  const SelectedLeague({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // HomeController x = Get.put(HomeController());
    return DefaultTabController(
      length: 3,
      child: new Scaffold(
        body: new NestedScrollView(
          // floatHeaderSlivers: true,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              new SliverAppBar(
                title: GestureDetector(
                  child: Text(Get.arguments[1].toString()),
                  onTap: () {
                    // print(Get.put(HomeController()));
                  },
                ),
                expandedHeight: 250.h,
                centerTitle: true,
                floating: false,
                pinned: true,
                snap: false,
                flexibleSpace: FlexibleSpaceBar(
                  stretchModes: [
                    StretchMode.zoomBackground,
                    StretchMode.blurBackground,
                    // StretchMode.fadeTitle,
                  ],
                  centerTitle: true,
                  collapseMode: CollapseMode.pin,
                  background: Image.network(
                    Get.arguments[2].toString(),
                    // cacheWidth: 1300,
                    // cacheHeight: 1000,
                    fit: BoxFit.cover,
                  ),
                ),
                bottom: TabBar(
                  tabs: <Tab>[
                    new Tab(text: "Table"),
                    new Tab(text: "Today/Past"),
                    new Tab(text: "upcoming"),
                  ], // <-- total of 2 tabs
                ),
              ),
            ];
          },
          body: GetBuilder(
              init: SelectedLeageController(),
              builder: (SelectedLeageController controller) {
                return new TabBarView(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(10.sp),
                      child: Card(
                        child: FutureBuilder(
                          future: controller.getData(),
                          builder: (context, snapshot) => !snapshot.hasData
                              ? Center(
                                  child: CircularProgressIndicator(),
                                )
                              : ListView.separated(
                                  physics: NeverScrollableScrollPhysics(),
                                  separatorBuilder: (context, index) =>
                                      Divider(),
                                  shrinkWrap: true,
                                  itemCount: snapshot.data.length,
                                  itemBuilder: (context, i) => GestureDetector(
                                    onLongPress: () {
                                      print("object");
                                      teamInfoModal(
                                          context, snapshot, i, controller);
                                    },
                                    child: Column(
                                      children: [
                                        i == 0
                                            ? SizedBox(
                                                height: 40.h,
                                                child: Center(
                                                  child: ListView.builder(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 10.h),
                                                    shrinkWrap: true,
                                                    itemCount: controller
                                                        .elements.length,
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    physics:
                                                        NeverScrollableScrollPhysics(),
                                                    itemBuilder:
                                                        (context, index) =>
                                                            Container(
                                                      width: (Get.width *
                                                              controller
                                                                  .flex[index] /
                                                              controller
                                                                  .sumOfFlex) -
                                                          (controller.sub +
                                                              -6.w),
                                                      child: Text(
                                                        controller
                                                            .elements[index],
                                                        textAlign:
                                                            controller.elements[
                                                                        index] !=
                                                                    "Team"
                                                                ? TextAlign
                                                                    .start
                                                                : TextAlign
                                                                    .center,
                                                        style: TextStyle(
                                                          fontSize: 14.sp,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : SizedBox(),
                                        SizedBox(
                                          height: 30.h,
                                          child: ListView.builder(
                                            // padding: EdgeInsets.only(left: 10.w),
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            scrollDirection: Axis.horizontal,
                                            shrinkWrap: true,
                                            itemCount:
                                                controller.elements.length,
                                            itemBuilder: (context, index) =>
                                                Container(
                                              width: (Get.width *
                                                      controller.flex[index] /
                                                      controller.sumOfFlex) -
                                                  controller.sub,
                                              child: Row(
                                                children: [
                                                  index == 0
                                                      ? Row(
                                                          children: [
                                                            SizedBox(width: 10),
                                                            Text(
                                                              (i + 1)
                                                                  .toString(),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      15.sp,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                            ),
                                                            Image.network(
                                                              snapshot.data[i][
                                                                  "team_badge"],
                                                              width: 30.w,
                                                              height: 20.h,
                                                              // cacheWidth: 60,
                                                              // cacheHeight: 60,
                                                              errorBuilder: (context,
                                                                      error,
                                                                      stackTrace) =>
                                                                  Icon(Icons
                                                                      .error),
                                                            ),
                                                          ],
                                                        )
                                                      : SizedBox(),
                                                  Expanded(
                                                    child: Text(
                                                      // controller.elements[index],
                                                      controller
                                                              .apiElement[index]
                                                              .toString()
                                                              .contains('GF')
                                                          ? controller
                                                              .calculateGD(
                                                                  snapshot.data[
                                                                          i][
                                                                      "overall_league_GF"],
                                                                  snapshot.data[
                                                                          i][
                                                                      "overall_league_GA"])
                                                              .toString()
                                                          : snapshot.data[
                                                              i][controller
                                                                  .apiElement[
                                                              index]],
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      textAlign:
                                                          controller.apiElement[
                                                                      index] !=
                                                                  "team_name"
                                                              ? TextAlign.center
                                                              : TextAlign.start,
                                                      style: TextStyle(
                                                        fontSize: 14.sp,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                        ),
                      ),
                    ),
                    FutureBuilder(
                      future: controller.getPastMatches(),
                      builder: (context, snapshot) => snapshot.hasData
                          ? ListView.builder(
                              padding: EdgeInsets.symmetric(vertical: 5.h),
                              itemCount: snapshot.data.length,
                              itemBuilder: (context, index) {
                                var data = snapshot.data[
                                    (snapshot.data.length ?? 0) - 1 - index];

                                // int reversedIndex = itemCount - 1 - index;
                                return GestureDetector(
                                  onTap: () {
                                    print(data["match_id"]);
                                    // controller.dispose();
                                    Get.to(() => MatchInforation(),
                                        arguments: ["ksl"]);
                                  },
                                  child: Card(
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 20.h, horizontal: 10.w),
                                      // minVerticalPadding: 20,
                                      // subtitle: data["match_stadium"] == ""
                                      //     ? null
                                      //     : Padding(
                                      //         padding: EdgeInsets.only(top: 10.h),
                                      //         child: Text(
                                      //           data["match_stadium"],
                                      //           style: TextStyle(
                                      //             fontSize: 12.sp,
                                      //           ),
                                      //           textAlign: TextAlign.center,
                                      //         ),
                                      //       ),
                                      // title: Text("kldw"),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(),
                                              Text(
                                                controller.dateFormater(
                                                    data["match_date"]),
                                                style: TextStyle(
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              data["match_live"] == "1"
                                                  ? CircleAvatar(
                                                      backgroundColor:
                                                          Colors.red,
                                                      radius: 3.r,
                                                    )
                                                  : SizedBox(),
                                            ],
                                          ),
                                          SizedBox(height: 5.h),
                                          Row(
                                            children: [
                                              Expanded(
                                                flex: 2,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        data[
                                                            "match_hometeam_name"],
                                                        style: TextStyle(
                                                          fontSize: 15.sp,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                    Image.network(
                                                      data["team_home_badge"],
                                                      errorBuilder: (context,
                                                              error,
                                                              stackTrace) =>
                                                          Icon(Icons.error),
                                                      width: 25.w,
                                                      height: 30.w,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                child: (data["match_status"] ==
                                                        "Finished")
                                                    ? Text(
                                                        data["match_hometeam_score"] +
                                                            " - " +
                                                            data[
                                                                "match_awayteam_score"],
                                                        style: TextStyle(
                                                          fontSize: 15.sp,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                        textAlign:
                                                            TextAlign.center,
                                                      )
                                                    : Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    2.w),
                                                        child: Text(
                                                          controller
                                                              .parseTimeToLocalTime(
                                                                  data[
                                                                      "match_time"]),
                                                          style: TextStyle(
                                                            decoration: data[
                                                                        "match_status"] ==
                                                                    "Postponed"
                                                                ? TextDecoration
                                                                    .lineThrough
                                                                : TextDecoration
                                                                    .none,
                                                            fontSize: 14.sp,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ),
                                              ),
                                              Expanded(
                                                flex: 2,
                                                child: Row(
                                                  children: [
                                                    Image.network(
                                                      data["team_away_badge"],
                                                      width: 25.w,
                                                      height: 30.w,
                                                      errorBuilder: (context,
                                                              error,
                                                              stackTrace) =>
                                                          Icon(Icons.error),
                                                    ),
                                                    Expanded(
                                                      // width:
                                                      //     (Get.width / 2.5) - 40.w,
                                                      child: Text(
                                                        data[
                                                            "match_awayteam_name"],
                                                        style: TextStyle(
                                                          fontSize: 15.sp,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          data["match_stadium"] == ""
                                              ? null
                                              : Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 10.h),
                                                  child: Text(
                                                    data["match_stadium"],
                                                    style: TextStyle(
                                                      fontSize: 12.sp,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              })
                          : Center(
                              child: CircularProgressIndicator(),
                            ),
                    ),
                    FutureBuilder(
                      future: controller.getFutureMatches(),
                      builder: (context, snapshot) => snapshot.hasData
                          ? ListView.builder(
                              padding: EdgeInsets.symmetric(vertical: 5.h),
                              itemCount: snapshot.data.length,
                              itemBuilder: (context, index) {
                                var data = snapshot.data[index];

                                // int reversedIndex = itemCount - 1 - index;
                                return GestureDetector(
                                  onTap: () {
                                    print(data["match_id"]);
                                  },
                                  child: Card(
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 20.h, horizontal: 10.w),
                                      // minVerticalPadding: 20,
                                      // subtitle: data["match_stadium"] == ""
                                      //     ? null
                                      //     : Padding(
                                      //         padding: EdgeInsets.only(top: 10.h),
                                      //         child: Text(
                                      //           data["match_stadium"],
                                      //           style: TextStyle(
                                      //             fontSize: 12.sp,
                                      //           ),
                                      //           textAlign: TextAlign.center,
                                      //         ),
                                      //       ),
                                      // title: Text("kldw"),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(),
                                              Text(
                                                controller.dateFormater(
                                                    data["match_date"]),
                                                style: TextStyle(
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              data["match_live"] == "1"
                                                  ? CircleAvatar(
                                                      backgroundColor:
                                                          Colors.red,
                                                      radius: 3.r,
                                                    )
                                                  : SizedBox(),
                                            ],
                                          ),
                                          SizedBox(height: 5.h),
                                          Row(
                                            children: [
                                              Expanded(
                                                flex: 2,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        data[
                                                            "match_hometeam_name"],
                                                        style: TextStyle(
                                                          fontSize: 15.sp,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                    Image.network(
                                                      data["team_home_badge"],
                                                      errorBuilder: (context,
                                                              error,
                                                              stackTrace) =>
                                                          Icon(Icons.error),
                                                      width: 25.w,
                                                      height: 30.w,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                child: (data["match_status"] ==
                                                        "Finished")
                                                    ? Text(
                                                        data["match_hometeam_score"] +
                                                            " - " +
                                                            data[
                                                                "match_awayteam_score"],
                                                        style: TextStyle(
                                                          fontSize: 15.sp,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                        textAlign:
                                                            TextAlign.center,
                                                      )
                                                    : Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    2.w),
                                                        child: Text(
                                                          controller
                                                              .parseTimeToLocalTime(
                                                                  data[
                                                                      "match_time"]),
                                                          style: TextStyle(
                                                            decoration: data[
                                                                        "match_status"] ==
                                                                    "Postponed"
                                                                ? TextDecoration
                                                                    .lineThrough
                                                                : TextDecoration
                                                                    .none,
                                                            fontSize: 14.sp,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ),
                                              ),
                                              Expanded(
                                                flex: 2,
                                                child: Row(
                                                  children: [
                                                    Image.network(
                                                      data["team_away_badge"],
                                                      width: 25.w,
                                                      height: 30.w,
                                                      errorBuilder: (context,
                                                              error,
                                                              stackTrace) =>
                                                          Icon(Icons.error),
                                                    ),
                                                    Expanded(
                                                      // width:
                                                      //     (Get.width / 2.5) - 40.w,
                                                      child: Text(
                                                        data[
                                                            "match_awayteam_name"],
                                                        style: TextStyle(
                                                          fontSize: 15.sp,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          data["match_stadium"] == ""
                                              ? null
                                              : Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 10.h),
                                                  child: Text(
                                                    data["match_stadium"],
                                                    style: TextStyle(
                                                      fontSize: 12.sp,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              })
                          : Center(
                              child: CircularProgressIndicator(),
                            ),
                    ),
                  ],
                );
              }),
        ),
      ),
    );
  }

  PersistentBottomSheetController<dynamic> teamInfoModal(
      BuildContext context,
      AsyncSnapshot<dynamic> snapshot,
      int i,
      SelectedLeageController controller) {
    return showBottomSheet(
      // enableDrag: false,
      context: context,
      builder: (context) => SafeArea(
        child: DefaultTabController(
          length: 3,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            physics: NeverScrollableScrollPhysics(),
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: 90.r,
                    child: Image.network(
                      snapshot.data[i]["team_badge"].toString(),
                      errorBuilder: (context, error, stackTrace) => Icon(
                        Icons.error,
                        size: 30.sp,
                      ),
                      // fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          snapshot.data[i]["team_name"].toString(),
                          style: TextStyle(
                            fontSize: 22.sp,
                            letterSpacing: 1,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 7.h),
                        Text(
                          snapshot.data[i]["league_name"].toString() +
                              " - " +
                              snapshot.data[i]["country_name"].toString(),
                          style: TextStyle(
                            fontSize: 12.sp,
                            // color: Colors.green,
                          ),
                        ),
                        SizedBox(height: 7.h),
                        Text(
                          snapshot.data[i]["overall_promotion"].toString(),
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              TabBar(
                // indicatorColor: Colors.green,
                // unselectedLabelColor: Colors.grey,
                tabs: [
                  Tab(text: "Overall"),
                  Tab(text: "Home"),
                  Tab(text: "Away"),
                ],
              ),
              SizedBox(
                height: 550.h,
                child: TabBarView(
                    // dragStartBehavior: DragStartBehavior.down,
                    children: [
                      Center(
                        child: ListView.separated(
                          shrinkWrap: true,
                          separatorBuilder: (context, index) => Divider(
                              // thickness: 1,
                              ),
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: controller.InfoInHashMap[0][1].keys
                              .toList()
                              .length,
                          itemBuilder: (context, index) => Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20.w, vertical: 10.h),
                            child: Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceAround,
                              // crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(
                                  child: Text(
                                      controller.InfoInHashMap[0][0].keys
                                          .toList()[index]
                                          .toString(),
                                      // textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15.sp,
                                      )),
                                ),
                                Expanded(
                                  child: Text(
                                      snapshot.data[i][controller
                                              .InfoInHashMap[0][0].values
                                              .toList()[index]]
                                          .toString(),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15.sp,
                                      )),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      ////////////
                      Center(
                        child: ListView.separated(
                          shrinkWrap: true,
                          separatorBuilder: (context, index) => Divider(
                              // thickness: 1,
                              ),
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: controller.InfoInHashMap[0][1].keys
                              .toList()
                              .length,
                          itemBuilder: (context, index) => Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20.w, vertical: 10.h),
                            child: Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceAround,
                              // crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(
                                  child: Text(
                                      controller.InfoInHashMap[0][1].keys
                                          .toList()[index]
                                          .toString(),
                                      // textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15.sp,
                                      )),
                                ),
                                Expanded(
                                  child: Text(
                                      snapshot.data[i][controller
                                              .InfoInHashMap[0][1].values
                                              .toList()[index]]
                                          .toString(),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15.sp,
                                      )),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      ////////
                      Center(
                        child: ListView.separated(
                          shrinkWrap: true,
                          separatorBuilder: (context, index) => Divider(
                              // thickness: 1,
                              ),
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: controller.InfoInHashMap[0][1].keys
                              .toList()
                              .length,
                          itemBuilder: (context, index) => Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20.w, vertical: 10.h),
                            child: Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceAround,
                              // crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(
                                  child: Text(
                                      controller.InfoInHashMap[0][2].keys
                                          .toList()[index]
                                          .toString(),
                                      // textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15.sp,
                                      )),
                                ),
                                Expanded(
                                  child: Text(
                                      snapshot.data[i][controller
                                              .InfoInHashMap[0][2].values
                                              .toList()[index]]
                                          .toString(),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15.sp,
                                      )),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ]),
              )
            ],
          ),
        ),
      ),
    );
  }
}
