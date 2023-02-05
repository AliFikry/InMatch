import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:football/Controller/pages/Leagues/countriesLeaguesController.dart';
import 'package:get/get.dart';

class CountriesLeagues extends StatelessWidget {
  const CountriesLeagues({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("All Leagues"),
      ),
      body: GetBuilder(
          init: CountriesLeaguesController(),
          builder: (CountriesLeaguesController controller) {
            return ListView.builder(
              // physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                return controller.data[index];
              },
              // children: [],
              itemCount: controller.data.length,
            );
          }),
    );
  }
}
