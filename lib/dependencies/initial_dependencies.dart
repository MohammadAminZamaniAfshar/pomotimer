import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:sptimer/controller/app_settings_controller.dart';
import 'package:sptimer/controller/main_controller.dart';
import 'package:sptimer/data/databases/tasks_reportage_database.dart';

Future<void> initInitialDependencies() async {
  await Hive.initFlutter();
  await Get.put(AppSettingsController()).init();
  await Get.put(TasksReportageDatabase()).init();
  await Get.put(MainController()).init();
}
