// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:msc_device_image/routes/routes.dart';
import 'style/color.dart';

void main() async {
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      minTextAdapt: true,
      designSize: const Size(300, 800),
      child: GetMaterialApp(
        enableLog: true,
        defaultTransition: Transition.fade,
        opaqueRoute: Get.isPlatformDarkMode,
        popGesture: Get.isLogEnable,
        transitionDuration: Get.defaultDialogTransitionDuration,
        defaultGlobalState: Get.isLogEnable,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
          useMaterial3: true,
          appBarTheme: const AppBarTheme(),
        ),
        initialRoute: ApplicationPages.splashScreen,
        getPages: ApplicationPages.getApplicationPages(),
      ),
    );
  }
}
