import 'package:get/get.dart';
import 'package:msc_device_image/screens/sim_module/service/text_recognotion_service.dart';

class TextScannerController extends GetxController {
  final recognizedText = ''.obs;
  final nameText = ''.obs;
  void scanTextFromImage(String imagePath) async {
    final text = await TextRecognitionService().recognizeText(imagePath);
    recognizedText.value = text;
    nameText.value = text;
  }
}
