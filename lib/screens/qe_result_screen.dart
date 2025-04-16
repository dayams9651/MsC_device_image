import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../const/image_strings.dart';
import '../style/color.dart';
import '../style/text_style.dart';
import 'controller/camera_controller.dart';

class QrResultScreen extends StatefulWidget {
  final String result;
  final String selectedOption;
  const QrResultScreen({super.key, required this.result,
    required this.selectedOption});
  @override
  State<QrResultScreen> createState() => _QrResultScreenState();
}
class _QrResultScreenState extends State<QrResultScreen> {
  final UploadController controller = Get.put(UploadController());
  // final TextEditingController _textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        automaticallyImplyLeading: false,
        title: const Text(''),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: LoadingAnimationWidget.twistingDots(
              leftDotColor: const Color(0xFF1A1A3F),
              rightDotColor: const Color(0xFFEA3799),
              size: 80,
            ),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 80,
                  width: 400,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.black),
                    color: Colors.white,
                  ),
                  child: Center(
                    child: Text(
                      widget.result,
                      style: AppTextStyles.kSmall12RegularTextStyle.copyWith(color: AppColors.white60),
                    ),
                  ),
                ),
                const SizedBox(height: 7),
                controller.selectedImages.isNotEmpty
                    ? Expanded(
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                    ),
                    itemCount: controller.selectedImages.length,
                    itemBuilder: (context, index) {
                      final File image = controller.selectedImages[index];
                      return Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Image.file(
                              image,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            left: 3,
                            bottom: 5,
                            child: GestureDetector(
                              onTap: () {
                                controller.removeImage(image);
                              },
                              child: const CircleAvatar(
                                backgroundColor: Colors.red,
                                radius: 15,
                                child: Icon(
                                  Icons.cancel,
                                  size: 27,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                )
                    : Center(child: Image.asset(noData1)),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      child: IconButton(
                        onPressed: () {
                          Get.back();
                        },
                        icon: const Icon(Icons.cancel_outlined, size: 38),
                      ),
                    ),
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: AppColors.success20,
                      child: IconButton(
                        onPressed: controller.pickImageFromCamera,
                        icon: const Icon(Icons.qr_code_scanner_outlined, size: 38),
                      ),
                    ),

                    CircleAvatar(
                      radius: 30,
                      child: IconButton(
                        onPressed: () {
                          String selectedOption = widget.selectedOption;
                          if (selectedOption == 'Missing Device Utility') {
                            controller.uploadImageMDU(widget.result);
                          } else if (selectedOption == 'Wrong Device Utility') {
                            controller.uploadImage(widget.result);
                          } else if (selectedOption == 'AWB MIN') {
                            controller.uploadImageMIN(widget.result);
                          } else {
                            Get.snackbar(
                              'Error',
                              'Please select a valid option from the dropdown',
                              backgroundColor: AppColors.error20,
                            );
                          }
                        },

                        icon: const Icon(Icons.check, size: 38),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
              ],
            ),
          );
        }
      }),
    );
  }
}


