import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:msc_device_image/const/api_url.dart';
import 'dart:convert';
import 'package:msc_device_image/style/color.dart';
import 'package:msc_device_image/screens/swipeMachine/model/swipe_image_model.dart';

class ImageOptionController extends GetxController {
  var isLoading = true.obs;
  var imageOptions = <ImageOption>[].obs;
  // final String apiUrl = 'https://bharatpaytest.mscorpres.net/swipeMachine/delivery/getImageOptions';


  @override
  void onInit() {
    fetchImageOptions();
    super.onInit();
  }

  final box = GetStorage();
  void fetchImageOptions() async {
    String? token = box.read('token');
    debugPrint('Retrieved Token: $token');

    if (token == null || token.isEmpty) {
      Get.snackbar('Error', 'Token not found. Please log in first.', backgroundColor: AppColors.error20);
      return;
    }

    try {
      isLoading(true);
      final response = await http.get(
        Uri.parse(swipeGetImageOptionApi),
        headers: {
          'authorization': '$token',
          'Content-Type': 'application/json',
        },
      );

      debugPrint('Response Status Code: ${response.statusCode}');
      debugPrint('Response Body: ${response.body}');
      debugPrint('Response Testing Token : $token');

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        if (jsonResponse['success']) {
          var data = jsonResponse['data'] as List;
          imageOptions.value = data.map((e) => ImageOption.fromJson(e)).toList();
        } else {
          Get.snackbar('Error', 'Failed to fetch image options: ${jsonResponse['message']}');
        }
      } else {
        Get.snackbar('Error', 'Failed to fetch image options. Status code: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
      debugPrint('Error ------------: $e');
    } finally {
      isLoading(false);
    }
  }
}