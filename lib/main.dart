import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import 'package:get/get.dart';
import 'package:quickscan_camera/app/core/theme/app_theme.dart';

import 'app/routes/app_pages.dart';

void main() {
  runApp(
    ScreenUtilPlusInit(
      designSize: const Size(360, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Grin Machine Test',
          theme: AppTheme.lightTheme,
          initialRoute: AppPages.INITIAL,
          getPages: AppPages.routes,
        );
      },
    ),
  );
}
