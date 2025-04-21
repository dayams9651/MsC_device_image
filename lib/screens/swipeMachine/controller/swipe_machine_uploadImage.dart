import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:msc_device_image/const/api_url.dart';
import 'package:msc_device_image/screens/scanQR_screen_page.dart';
import 'package:msc_device_image/style/color.dart';

class SwipeMachineUploadImage extends GetxController {
  var uploadedImageMap = <String, String>{}.obs;
  var isSubmitting = false.obs;

  final box = GetStorage();

  Future<void> swipeImageImage(String filePath, {required String imageId}) async {
    String? token = box.read('token');
    if (token == null || token.isEmpty) {
      Get.snackbar('Error', 'Token not found. Please log in first.');
      return;
    }

    try {
      final file = File(filePath);
      final mimeType = lookupMimeType(filePath)?.split('/') ?? ['image', 'jpeg'];

      var request = http.MultipartRequest(
        'POST',
        Uri.parse(swipeUploadImgApi),
      );

      request.headers['authorization'] = token;
      request.files.add(await http.MultipartFile.fromPath(
        'file',
        file.path,
        contentType: MediaType(mimeType[0], mimeType[1]),
      ));

      var response = await request.send();

      if (response.statusCode == 200) {
        final resStr = await response.stream.bytesToString();
        final jsonRes = json.decode(resStr);

        if (jsonRes['success']) {
          uploadedImageMap[imageId] = jsonRes['data'];
          Get.snackbar("Success", jsonRes['message'], backgroundColor: AppColors.success40);

        } else {
          Get.snackbar("Upload Failed", "Image upload failed for $imageId", backgroundColor: AppColors.error20);
        }
      } else {
        Get.snackbar("Error", "Upload failed with status: ${response.statusCode}", backgroundColor: AppColors.error20);
      }
    } catch (e) {
      Get.snackbar("Error", "Exception during upload: $e", backgroundColor: AppColors.error20);
    }
  }

  Future<void> submitImageList({required String awbNo}) async {
    String? token = box.read('token');
    if (token == null || token.isEmpty) {
      Get.snackbar('Error', 'Token not found. Please log in first.', backgroundColor: AppColors.error20);
      return;
    }

    if (uploadedImageMap.isEmpty) {
      Get.snackbar("No Uploads", "No images have been uploaded.", backgroundColor: AppColors.error20);
      return;
    }

    try {
      isSubmitting.value = true;

      final body = {
        "awb_no": awbNo,
        "imagData": uploadedImageMap.entries.map((entry) {
          return {
            "image_id": entry.key,
            "img_url": entry.value,
          };
        }).toList(),
      };

      final response = await http.post(
        Uri.parse(swipeUploadImgListApi),
        headers: {
          'authorization': token,
          'Content-Type': 'application/json',
        },
        body: json.encode(body),
      );

      final res = json.decode(response.body);
      if (response.statusCode == 200 && res['success']) {
        Get.snackbar("Success", res['message'] ?? "Images submitted.", backgroundColor: AppColors.success40);
        Get.to(const ScanQrScreenPage(setResult: ''));
      } else {
        Get.snackbar("Failed", res['message'] ?? "Submission failed.", backgroundColor: AppColors.error20);
      }
    } catch (e) {
      Get.snackbar("Error", "Exception during submission: $e", backgroundColor: AppColors.error20);
    } finally {
      isSubmitting.value = false;
    }
  }
}
