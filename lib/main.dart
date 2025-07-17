import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasks/routes/app_pages.dart';
import 'package:tasks/routes/app_routes.dart';
import 'bindings/app_bindings.dart';
import 'core/theme/app_theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Task App',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      initialRoute: AppRoutes.taskList,
      getPages: AppPages.pages,
      initialBinding: AppBindings(),
      debugShowCheckedModeBanner: false,
    );
  }
}