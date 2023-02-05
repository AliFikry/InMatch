import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:football/Controller/pages/Home/homeController.dart';
import 'package:football/Controller/pages/chooseController.dart';
import 'package:football/View/keys/keys.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'main.dart';

class ChooseLeague extends StatelessWidget {
  const ChooseLeague({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Choose League"),
        actions: [
          GetBuilder<ChooseLeagueController>(
              init: ChooseLeagueController(),
              builder: (c) {
                return IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      // Get.back();
                      c.toggleSearchState();
                    });
              }),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60.h),
          child: GetBuilder<ChooseLeagueController>(
              builder: (chooseLeagueController) {
            return AnimatedContainer(
              width: chooseLeagueController.searchState ? 0.95.sw : .50.sw,
              duration: Duration(milliseconds: 300),
              child: !chooseLeagueController.searchState
                  ? Padding(
                      padding: EdgeInsets.only(bottom: 30.h),
                      child: Text(
                        "Choose League to get started",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          // fontSize: 15.sp,
                          color: ThemeData.dark().hintColor,
                        ),
                      ),
                    )
                  : TextFormField(
                      controller: chooseLeagueController.search,
                      onEditingComplete: () {
                        chooseLeagueController
                            .searchLeague(chooseLeagueController.search.text);
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                        prefixIcon: !chooseLeagueController.searchState
                            ? null
                            : Icon(
                                Icons.search,
                                color: Colors.white,
                              ),
                        suffixIcon: !chooseLeagueController.searchState
                            ? null
                            : IconButton(
                                onPressed: () {
                                  chooseLeagueController.search.clear();
                                  chooseLeagueController.searchValue = "";
                                  chooseLeagueController.searchLeague("");
                                  chooseLeagueController..toggleSearchState();
                                },
                                icon: Icon(
                                  Icons.clear,
                                  color: Colors.white,
                                  size: 21.sp,
                                ),
                              ),
                        border: !chooseLeagueController.searchState
                            ? null
                            : OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.white, width: 2.0),
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                        hintText: "Search....",
                        hintStyle: TextStyle(
                          fontSize: 16,
                          letterSpacing: 0.5,
                          fontWeight: FontWeight.w400,
                        ),
                        filled: true,
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.white, width: 2.0),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                    ),
            );
          }),
        ),
      ),
      body: FutureBuilder(
        future: http.get(Uri.parse(
            'https://apiv3.apifootball.com/?action=get_leagues&APIkey=${apiKey}')),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            var data = jsonDecode(snapshot.data.body);
            return GetBuilder<ChooseLeagueController>(
                // init: ChooseLeagueController(),
                builder: (chooseLeagueController) {
              return Padding(
                padding: EdgeInsets.only(top: 10.h),
                child: chooseLeagueController.searchValue != ""
                    ? GridView.count(
                        crossAxisCount: 3,
                        crossAxisSpacing: 5.0,
                        mainAxisSpacing: 5.0,
                        children: List.generate(
                          // ignore: division_optimization
                          (chooseLeagueController.searchedLeagueName.length / 2)
                              .toInt(),
                          (index) => GestureDetector(
                            onTap: () {
                              chooseLeagueController.addOrRemoveLeague(
                                chooseLeagueController.leagueId[index],
                                chooseLeagueController.leagueName[index],
                              );
                            },
                            child: Card(
                              color: chooseLeagueController.selectedLeague
                                      .contains(chooseLeagueController
                                          .leagueId[index])
                                  ? Colors.green[400].withOpacity(0.9)
                                  : null,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  CircleAvatar(
                                    radius: 20.r,
                                    backgroundColor: Colors.transparent,
                                    child: Image.asset(
                                      'assets/leagues_icons/${chooseLeagueController.searchedLeagueId[index]}.jpeg',
                                      height: 40.h,
                                      width: 100.w,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              Image.network(
                                        chooseLeagueController
                                            .searchedLeagueLogo[index],
                                        height: 40.h,
                                        width: 100.w,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                Icon(Icons.error),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    chooseLeagueController
                                        .searchedLeagueName[index],
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w500,
                                      color: ThemeData.dark().primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    : GridView.count(
                        crossAxisCount: 3,
                        crossAxisSpacing: 5.0,
                        mainAxisSpacing: 5.0,
                        children: List.generate(
                          chooseLeagueController.leagueName.length,
                          (index) => GestureDetector(
                            onTap: () {
                              // chooseLeagueController.fetchRequest();
                              chooseLeagueController.addOrRemoveLeague(
                                chooseLeagueController.leagueId[index],
                                chooseLeagueController.leagueName[index],
                              );
                            },
                            child: Card(
                              color: chooseLeagueController.selectedLeague
                                      .contains(chooseLeagueController
                                          .leagueId[index])
                                  ? Colors.green[400].withOpacity(0.9)
                                  : null,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  CircleAvatar(
                                    radius: 20.r,
                                    backgroundColor: Colors.transparent,
                                    child: Image.asset(
                                      'assets/leagues_icons/${chooseLeagueController.leagueId[index]}.jpeg',
                                      height: 40.h,
                                      width: 100.w,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              Image.network(
                                        chooseLeagueController
                                            .leagueLogo[index],
                                        height: 40.h,
                                        width: 100.w,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                Icon(Icons.error),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    chooseLeagueController.leagueName[index],
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w500,
                                      color: ThemeData.dark()
                                          .textTheme
                                          .bodyLarge
                                          .color,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
              );
            });
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: GetBuilder<ChooseLeagueController>(
        builder: (controller) {
          if (controller.selectedLeague.isNotEmpty) {
            return FloatingActionButton(
              onPressed: () async {
                await controller.setFavoriteLeague();
                controller.dispose();

                Get.off(() => MainScreen());
                Get.put(HomeController().retriveFavorite());
              },
              child: Icon(
                Icons.arrow_forward_sharp,
                size: 25.sp,
              ),
              // backgroundColor: Colors.green[400],
            );
          } else {
            return SizedBox();
          }
        },
      ),
    );
  }
}
