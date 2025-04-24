import 'package:get/get.dart';
import 'package:msc_device_image/screens/sim_module/bindings/text_scanner_bindings.dart';
import 'package:msc_device_image/screens/sim_module/views/text_scanner_view.dart';
import 'package:msc_device_image/screens/splash_screen.dart';
import 'package:msc_device_image/screens/view/dashboard_screen.dart';
import '../signUp/view/signUp_screen.dart';

class ApplicationPages {
  static const splashScreen = '/';
  static const bottomBarScreen = '/bottomBarScreen';
  static const dashboardScreen = '/dashboardScreen';
  static const textScannerScreen = '/textScannerScreen';

  static List<GetPage> getApplicationPages() => [
    GetPage(name: splashScreen, page: () => const SplashScreen()),
    GetPage(name: dashboardScreen, page: () => const DashboardScreen()),
    GetPage(
      name: textScannerScreen,
      page: () => TextScannerView(),
      binding: TextScannerBinding(),
    ),
    // GetPage(name: bottomBarScreen, page: () => const BottomBar()),
  ];
}
