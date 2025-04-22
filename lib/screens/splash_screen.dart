import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:msc_device_image/const/api_url.dart';
import 'package:msc_device_image/const/image_strings.dart';
import 'package:msc_device_image/routes/routes.dart';
import 'package:msc_device_image/service/logInApi.dart';
import 'package:msc_device_image/signUp/view/signUp_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    navigateToNextScreen();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 3));
    checkTokenAndNavigate();
  }

  void checkTokenAndNavigate() async {
    try {
      final token = box.read('token');
      // final tokenExpiry = box.read('tokenExpiry');
      final currentTime = DateTime.now().millisecondsSinceEpoch;

      debugPrint("Token: $token");
      // debugPrint("Token Expiry: $tokenExpiry");

      if (token == null || token.isEmpty) {
        debugPrint("Token is null or empty, navigating to WelcomeScreen");
        Get.to(() => const SignupScreen());
      }
      // else if (tokenExpiry != null && int.tryParse(tokenExpiry.toString()) != null && currentTime > int.parse(tokenExpiry.toString())) {
      //   debugPrint("Token has expired, redirecting to SignupScreen");
      //   Get.to(() => const SignupScreen());
      // }
      else {
        debugPrint("Token is valid, validating with server");
        final isTokenValid = await validateTokenWithServer(token);
        if (isTokenValid) {
          debugPrint("Token is valid, navigating to lock screen");
          Get.offNamed(ApplicationPages.dashboardScreen);
        } else {
          debugPrint("Token is invalid or expired, redirecting to SignupScreen");
          Get.to(() => const SignupScreen());
        }
      }
    } catch (e) {
      debugPrint("Error checking login status: $e");
      Get.to(() => const SignupScreen());
      // Get.offAllNamed(ApplicationPages.SignupScreen());
    }
  }

  Future<bool> validateTokenWithServer(String token) async {
    try {
      final response = await http.post(
        Uri.parse(logInApi),
        headers: {'authorization': '$token',},
      );

      debugPrint("Server response status code: ${response.statusCode}");
      debugPrint("Server response body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['isValid'] ?? true;
      } else {
        debugPrint("Failed to validate token: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      debugPrint("Error validating token: $e");
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: SizedBox(
          child: Image.asset(
            logo,
            filterQuality: FilterQuality.high,
          ),
        ),
      ),
    );
  }
}
