import 'package:get/get.dart';
import 'package:msc_device_image/screens/splash_screen.dart';
import 'package:msc_device_image/screens/view/dashboard_screen.dart';

import '../screens/sim_module/views/sim_module_homePage_screen.dart';
class ApplicationPages {
  static const splashScreen = '/';
  static const bottomBarScreen = '/bottomBarScreen';
  static const dashboardScreen = '/dashboardScreen';
  static const simModuleScreen = '/simModuleScreen';

  static List<GetPage> getApplicationPages() => [
    GetPage(name: splashScreen, page: () => const SplashScreen()),
    GetPage(name: dashboardScreen, page: () => const DashboardScreen()),
    // GetPage(
    //   name: textScannerScreen,
    //   page: () => TextScannerView(),
    //   binding: TextScannerBinding(),
    // ),
    GetPage(name: simModuleScreen, page: () => SimModuleHomepageScreen()),
  ];
}
