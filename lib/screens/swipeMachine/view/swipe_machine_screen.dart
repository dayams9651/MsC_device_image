import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:msc_device_image/screens/controller/camera_controller.dart';
import 'package:msc_device_image/screens/swipeMachine/controller/swipe_machine_controller.dart';
import 'package:msc_device_image/screens/swipeMachine/controller/swipe_machine_uploadImage.dart';
import 'package:msc_device_image/style/color.dart';
import 'package:msc_device_image/style/text_style.dart';
class SwipeMachineScreen extends StatefulWidget {
  final String result;
  final String selectedOption;

  const SwipeMachineScreen({
    super.key,
    required this.result,
    required this.selectedOption,
  });

  @override
  State<SwipeMachineScreen> createState() => _ImageOptionScreenState();
}

class _ImageOptionScreenState extends State<SwipeMachineScreen> {
  final ImageOptionController controller = Get.put(ImageOptionController());
  final UploadController uploadController = Get.put(UploadController());
  final SwipeMachineUploadImage swipeImageController = Get.put(SwipeMachineUploadImage());

  late List<bool> checkBoxStates;
  late List<String?> imagePaths;
  late List<bool> isUploading;
  late List<bool> isUploaded;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final length = controller.imageOptions.length;
      setState(() {
        checkBoxStates = List<bool>.filled(length, false);
        imagePaths = List<String?>.filled(length, null);
        isUploading = List<bool>.filled(length, false);
        isUploaded = List<bool>.filled(length, false);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Swipe Machine",
            style: AppTextStyles.kCaption13SemiBoldTextStyle.copyWith(color: AppColors.white),
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final options = controller.imageOptions;
        if (checkBoxStates.length != options.length) {
          checkBoxStates = List<bool>.filled(options.length, false);
          imagePaths = List<String?>.filled(options.length, null);
          isUploading = List<bool>.filled(options.length, false);
          isUploaded = List<bool>.filled(options.length, false);
        }

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: options.length,
                itemBuilder: (context, index) {
                  final option = options[index];
                  return Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Checkbox(
                              value: checkBoxStates[index],
                              onChanged: (value) {
                                setState(() {
                                  checkBoxStates[index] = value ?? false;
                                });
                              },
                            ),
                            Expanded(
                              child: InkWell(
                                onTap: () async {
                                  final imagePath = await uploadController.pickImageFromCamera();
                                  if (imagePath != null) {
                                    setState(() {
                                      imagePaths[index] = imagePath;
                                      isUploaded[index] = false;
                                    });
                                  }
                                },
                                child: Container(
                                  height: 38,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(7),
                                    border: Border.all(color: AppColors.white40, width: 2),
                                  ),
                                  child: Center(
                                    child: Text(
                                      imagePaths[index] ?? option.imgName,
                                      style: const TextStyle(fontSize: 16),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 5),
                            Container(
                              width: 100,
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(7),
                                border: Border.all(color: AppColors.primaryColor),
                                color: checkBoxStates[index] ? AppColors.primaryColor : Colors.grey,
                              ),
                              child: TextButton(
                                onPressed: checkBoxStates[index] && !isUploading[index]
                                    ? () async {
                                  final path = imagePaths[index];
                                  if (path != null) {
                                    setState(() => isUploading[index] = true);

                                    await swipeImageController.swipeImageImage(
                                      path,
                                      imageId: option.imageId,
                                    );
                                    setState(() {
                                      isUploading[index] = false;
                                      isUploaded[index] = true;
                                    });
                                  } else {
                                    Get.snackbar("No Image", "Please capture an image before uploading.");
                                  }
                                }
                                    : null,
                                child: isUploading[index]
                                    ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                )
                                    : Text(
                                  isUploaded[index] ? "Uploaded" : "Upload",
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            const SizedBox(width: 5),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Obx(() {
                return SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryColor),
                    onPressed: swipeImageController.isSubmitting.value
                        ? null
                        : () => swipeImageController.submitImageList(awbNo: widget.result),
                    child: swipeImageController.isSubmitting.value
                        ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                        : const Text("Submit"),
                  ),
                );
              }),
            ),
          ],
        );
      }),
    );
  }
}
