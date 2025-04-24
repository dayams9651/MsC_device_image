import 'package:get/get.dart';
import 'package:msc_device_image/screens/sim_module/controller/text_scanner_controller.dart';
class TextScannerBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(TextScannerController());
    // Get.lazyPut<TextScannerController>(() => TextScannerController());
  }
}
