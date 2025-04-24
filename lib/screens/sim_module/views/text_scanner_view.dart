import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:msc_device_image/screens/sim_module/controller/text_scanner_controller.dart';
import 'package:msc_device_image/style/color.dart';

class TextScannerView extends StatelessWidget {
  final TextScannerController controller = Get.find();
  final TextEditingController textEditingController = TextEditingController();

  TextScannerView({super.key});

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      controller.scanTextFromImage(pickedFile.path);
      textEditingController.text = controller.nameText.value;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: const Text(
          "SIM Module",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(7.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: AppColors.primaryColor,
              ),
              child: TextButton(
                onPressed: pickImage,
                child: const Text("Scan Page"),
              ),
            ),
            const SizedBox(height: 20),
            Obx(() {
              textEditingController.text = controller.nameText.value;
              return TextField(
                controller: textEditingController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  hintText: "Scanned text will appear here",
                ),
                style: const TextStyle(fontSize: 16),
                maxLines: 2,
              );
            }),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}