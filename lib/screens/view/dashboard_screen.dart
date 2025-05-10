import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:msc_device_image/common/widget/round_button.dart';
import 'package:msc_device_image/routes/routes.dart';
import 'package:shimmer/shimmer.dart';
import '../../common/widget/const_shimmer_effects.dart';
import '../../service/logInApi.dart';
import '../../style/color.dart';
import '../../style/text_style.dart';
import '../scanQR_screen_page.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final UserLogInService controller = Get.put(UserLogInService());

  Future<bool> _onWillPop() async {
    return await showDialog(
        context: context,
        builder: (context) => AlertDialog(
            title: const Text('Confirmation'),
            content: const Text('Are you sure you want to exit?'),
            actions: [
            TextButton(
            onPressed: () => Navigator.of(context).pop(false),
              child: const Text('No'),
              ),
              TextButton(
                onPressed: () {
                  SystemNavigator.pop();
                },
                child: const Text('Yes'),
              ),
               ],
             ),
          ) ?? false;
       }

  void _showLogoutConfirmation() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Log out"),
          content: Text("Are you sure you want to logout?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text("Logout"),
            ),
          ],
        );
      },
    );

  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text("Dashboard", style: AppTextStyles.kPrimaryTextStyle),
          backgroundColor: AppColors.white,
          actions: [
            // IconButton(onPressed: _toggleFlash, icon: Icon(Icons.flash_auto)),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: IconButton(
                onPressed: _showLogoutConfirmation,
                icon: const Icon(Icons.login, size: 35, color: AppColors.error60),
              ),
            ),
          ],
          // leading: IconButton(
          //   icon: const Icon(Icons.arrow_back_ios, size: 24),
          //   onPressed: () async {
          //     if (await _onWillPop()) {
          //       Get.back();
          //     }
          //   },
          // ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Obx(() {
            if (controller.isLoading.value) {
              return Shimmer.fromColors(
                baseColor: baseColor,
                highlightColor: highLightColor,
                child: loadSke(),
              );
            } else {
              final profileData = controller.logInData.value;
              return Column(
                children: [
                  Container(
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppColors.primaryColor,
                    ),
                    child: Center(
                      child: ListTile(
                        title: Text(
                          "${profileData?.data?.username.toString()} (${profileData?.data?.companyId})",
                          style: AppTextStyles.kCaption14SemiBoldTextStyle,
                        ),
                        subtitle: Text(
                          "${profileData?.data?.crnId}",
                          style: AppTextStyles.kCaption13RegularTextStyle,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  RoundButton(
                    title: "Capture Image",
                    onTap: () {
                      Get.to(() => ScanQrScreenPage(setResult: ''));
                    },
                  ),
                  RoundButton(
                    title: "SIM Module",
                    onTap: () {
                      Get.toNamed(ApplicationPages.simModuleScreen);
                    },
                  ),
                  const SizedBox(height: 5),
                ],
              );
            }
          }),
        ),
      ),
    );
  }
}