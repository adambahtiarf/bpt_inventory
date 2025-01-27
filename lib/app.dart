import 'dart:io';

import 'components/infoPage/info_builder.dart';
import 'components/theme/theme.dart';
import 'core/utils/app_util.dart';
import 'routes/app_routes.dart';

import 'components/infoPage/info_page.dart';
import 'main.dart';
import 'routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class App extends StatefulWidget {
  const App({
    super.key,
  });

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) => FutureBuilder(
        future: kGIns.allReady(),
        builder: _builder,
      );

  Widget _builder(BuildContext _, AsyncSnapshot<void> snapshot) => Sizer(builder: (_, orientation, deviceType) {
        if (!snapshot.hasError && snapshot.connectionState == ConnectionState.done) {
          return GetMaterialApp(
            getPages: AppPages.pages,
            initialRoute: AppRoutes.login,
            theme: AppTheme.light(),
            navigatorKey: Get.key,
          );
        } else {
          return GetMaterialApp(
            theme: AppTheme.light(),
            home: InfoPage(
              errWidget: InfoBuilder(
                description: "Hubungi tim untuk menanyakan proses perbaikannya, ya!",
                buttonText: Platform.isAndroid ? "Tutup Aplikasi" : "",
                onPressed: Platform.isAndroid ? AppUtil.closeApp : null,
                title: "Aplikasi lagi diperbaiki",
              ),
            ),
          );
        }
      });
}
