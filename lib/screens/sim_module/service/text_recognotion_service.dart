import 'package:google_ml_kit/google_ml_kit.dart';

class TextRecognitionService {
  final textRecognizer = GoogleMlKit.vision.textRecognizer();

  Future<String> recognizeText(String imagePath) async {
    final inputImage = InputImage.fromFilePath(imagePath);
    final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
    return recognizedText.text;
  }

  void dispose() {
    textRecognizer.close();
  }
}
