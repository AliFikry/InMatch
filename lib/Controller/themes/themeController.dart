import 'dart:io';

import 'package:flutter/scheduler.dart';
import 'package:football/View/keys/keys.dart';
import 'package:get/state_manager.dart';
import 'package:path_provider/path_provider.dart';

class ThemeController extends GetxController {
  // @override
  bool isDark = false;

  Future<void> onInit() async {
    // TODO: implement onInit
    super.onInit();
    // print(SchedulerBinding.instance.platformDispatcher.platformBrightness.name);

    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    isDark =
        await File(appDocPath + "/darkMode.txt").readAsString().toString() ==
                "true"
            ? true
            : false;
    var exists = await File(appDocPath + "/darkMode.txt").exists();
    if (exists) {
      isDark = await File(appDocPath + "/darkMode.txt").readAsString() == "true"
          ? true
          : false;
      update();
    } else {
      isDark = true;
      update();
    }
    // File(appDocPath + "/darkMode.txt").readAsStringSync();
  }

  Future<void> toggleMode() async {
    isDark = !isDark;

    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    var file =
        File(appDocPath + "/darkMode.txt").writeAsStringSync(isDark.toString());
    update();

    print(await File(appDocPath + "/darkMode.txt").readAsString());
  }
}
