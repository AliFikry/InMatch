// ignore_for_file: missing_return

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

var imageError = "https://pngimg.com/uploads/football/football_PNG52781.png";
//colors
var backgroundColor = Colors.black;
var primaryColor = Color(0xFF252626);
var secondaryColor = Color(0xFF1C1C1C);
var UserLocation;
var userCountry, userCountryId;
bool _visible = false;
var userLeagueChoosen = [];
bool firstTimeUser = false;
// final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

// class Loading extends StatefulWidget {
//   const Loading({Key key}) : super(key: key);

//   @override
//   State<Loading> createState() => _LoadingState();
// }

// class _LoadingState extends State<Loading> {
//   Timer timer;

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     timer = Timer.periodic(Duration(seconds: 10), (timer) {
//       setState(() {
//         _visible = true;
//       });
//       // break;
//       print("refreshed");
//       timer.cancel();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {

//   }
// }
// Widget Loading(BuildContext context ,void function){
//   return
// }
DateTime loginClickTime;

bool isRedundentClick(DateTime currentTime) {
  if (loginClickTime == null) {
    loginClickTime = currentTime;
    print("first click");
    return false;
  }
  print('diff is ${currentTime.difference(loginClickTime).inSeconds}');
  if (currentTime.difference(loginClickTime).inSeconds < 7) {
    //set this difference time in seconds
    return true;
  }

  loginClickTime = currentTime;
  return false;
}

var apiKey = "89a952ab1679ba89e41f12ddb18312d720165f742b26546dcefaa8947364fd25";
//8822649208e5c2f0bb23853b0f5a109be936c4b65ff04df1d27d573c78af6267
var applicationName = "InMatch";
bool isGuest = false;

var leagueNameWithCountry = [
  "England - Premier League", //0
  "France - Ligue 1", //2
  "Italy - Serie A", //3
  "Spain - La Liga", //4
  "Germany - Bundesliga", //5
];
var leagueName = [
  "Premier League", //0
  "Ligue 1", //2
  "Serie A", //3
  "La Liga", //4
  "Bundesliga", //5
];
var leagueId = [
  "152",
  "168",
  "207",
  "302",
  "175",
];
var leagueFlag = [
  // "https://apiv3.apifootball.com/badges/logo_leagues/152_premier-league.png",
  'https://assets.turbologo.com/blog/en/2020/01/19084653/Premier-League-symbol-958x575.png',
  // "https://apiv3.apifootball.com/badges/logo_leagues/168_ligue-1.png",
  "https://1.bp.blogspot.com/-lNKd4x7HrKY/XIoZkfzHocI/AAAAAAAAI7A/n6WWyuRLTvEldGo1mWIrrwLAiDrIPa8RwCK4BGAYYCw/s1600/icon%2Bligue%2B1%2Bfrance%2Bfootball%2B.png",
  // "https://apiv3.apifootball.com/badges/logo_leagues/207_serie-a.png",
  "https://forzaitalianfootball.com/wp-content/uploads/2019/05/New-Serie-A-logo.png",
  // "https://apiv3.apifootball.com/badges/logo_leagues/302_la-liga.png",
  "https://cdn.freelogovectors.net/wp-content/uploads/2020/08/laligalogo.png",
  // "https://apiv3.apifootball.com/badges/logo_leagues/175_bundesliga.png",
  "https://1.bp.blogspot.com/-CEv9U71JK5M/XIocK_9poCI/AAAAAAAAI7c/922f8z6txtgtk9vqYvnAkZZiF0TpjaPEwCK4BGAYYCw/s1600/icon%2Bbundesliga%2Bfootball%2Bgermany%2B.png",
];

var leaguesColor = [
  0xFF00ff85,
  0xFFdae025,
  0xFF008fd7,
  0xFFF5F5F5,
  0xFFD3010C,
];

// league_info
var days = DateFormat.d().format(DateTime.now().subtract(
  Duration(days: 30),
));
var month = DateFormat.M().format(DateTime.now().subtract(
  Duration(days: 30),
));

var toDateUpcoming = DateFormat.y().format(DateTime.now().add(
      Duration(days: 30),
    )) +
    "-" +
    DateFormat.M().format(DateTime.now().add(
      Duration(days: 30),
    )) +
    "-" +
    DateFormat.d().format(DateTime.now().add(
      Duration(days: 30),
    ));
var fromDateUpcoming = DateFormat.y().format(
      DateTime.now().add(
        Duration(days: 1),
      ),
    ) +
    "-" +
    DateFormat.M().format(
      DateTime.now().add(
        Duration(days: 1),
      ),
    ) +
    "-" +
    DateFormat.d().format(
      DateTime.now().add(
        Duration(days: 1),
      ),
    );

var isSelected = [
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false
];
var imageToChooseLeague = [
  "https://apiv3.apifootball.com/badges/logo_leagues/152_premier-league.png", //0
  "https://apiv3.apifootball.com/badges/logo_leagues/302_la-liga.png", //1
  "https://apiv3.apifootball.com/badges/logo_leagues/175_bundesliga.png", //2
  "https://apiv3.apifootball.com/badges/logo_leagues/207_serie-a.png", //3
  "https://apiv3.apifootball.com/badges/logo_leagues/244_eredivisie.png", //4
  "https://apiv3.apifootball.com/badges/logo_leagues/168_ligue-1.png", //5
  "https://apiv3.apifootball.com/badges/logo_leagues/99_serie-a.png", //6
  "https://apiv3.apifootball.com/badges/logo_leagues/266_primeira-liga.png", //7
  "https://apiv3.apifootball.com/badges/logo_leagues/44_liga-profesional-argentina.png", //8
  "https://apiv3.apifootball.com/badges/logo_leagues/235_liga-mx.png", //9
  "https://apiv3.apifootball.com/badges/logo_leagues/322_s%C3%BCper-lig.png", //10
  // "https://seeklogo.com/images/U/UEFA_Champions_League-logo-DD9AE0500D-seeklogo.com.png", //11
];
var idToChooseLeague = [
  "152",
  "302",
  "175",
  "207",
  "244",
  "168",
  "99",
  "266",
  "44",
  "235",
  "322",
  // "3",
];
var countriesToChooseLeagues = [
  "England",
  "Spain",
  "Germany",
  "Italy",
  "Netherlands",
  "France",
  "Brazil",
  "Portugal",
  "Argentina",
  "Mexico",
  "Turkey",
  // "",
];
var leaguesToChooseLeague = [
  "Premier League",
  "La liga",
  "Bundesliga",
  "Serie A",
  "Eredivisie",
  "Ligue 1",
  "Serie A",
  "Primeira liga",
  "Argentine Primera División",
  "Liga MX",
  "Süper Lig",
  // "Champions League"
];
