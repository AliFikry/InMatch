import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:get/state_manager.dart';
import 'package:http/http.dart' as http;

import '../../View/keys/keys.dart';

class ChooseLeagueController extends GetxController {
  TextEditingController search = TextEditingController();
  String searchValue = "";
  var requestData;
  bool searchState;
  List leagueName = [];
  List leagueId = [];
  List leagueLogo = [];

  List selectedLeague = [];
  List selectedLeagueName = [];

  List searchedLeagueName = [];
  List searchedLeagueId = [];
  List searchedLeagueLogo = [];
  @override
  void onInit() {
    fetchRequest();
    super.onInit();
    fetchRequest();
    searchState = false;
  }

  Future<FutureBuilder> fetchRequest() async {
    leagueName.clear();
    leagueId.clear();
    leagueLogo.clear();
    var request = await http.get(
      Uri.parse(
          'https://apiv3.apifootball.com/?action=get_leagues&APIkey=$apiKey'),
    );
    var data = jsonDecode(request.body);
    // print(l.length);
    for (var e in data) {
      // print();
      leagueName.add(e["league_name"]);
      leagueId.add(e["league_id"]);
      leagueLogo.add(e["league_logo"]);
    }
    update();
  }

  void toggleSearchState() {
    searchState = !searchState;
    update();
  }

  void searchLeague(String value) {
    searchValue = value;
    searchedLeagueName.clear();
    searchedLeagueId.clear();
    searchedLeagueLogo.clear();
    if (value != "") {
      for (var i = 0; i < leagueName.length; i++) {
        if (leagueName[i].toString().contains(searchValue.trim())) {
          print(leagueName[i]);
          searchedLeagueName.add(leagueName[i]);
          searchedLeagueId.add(leagueId[i]);
          searchedLeagueLogo.add(leagueLogo[i]);
        }
      }
    }
    update();
    print(searchValue);
    print(leagueName.length);
  }

  void addOrRemoveLeague(String id, String name) {
    if (selectedLeague.contains(id)) {
      selectedLeague.remove(id);
      selectedLeagueName.remove(name);
    } else {
      selectedLeague.add(id);
      selectedLeagueName.add(name);
    }
    // print(selectedLeague);
    update();
  }

  Future<void> setFavoriteLeague() async {
    await FirebaseFirestore.instance
        .collection(FirebaseAuth.instance.currentUser.uid.toString())
        .doc("favourites")
        .set({
      "leaguesId": selectedLeague,
      "leaguesName": selectedLeagueName,
    });
  }
}
