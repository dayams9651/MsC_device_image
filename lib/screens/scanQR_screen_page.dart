import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import '../common/widget/round_button.dart';
import '../const/image_strings.dart';
import '../style/color.dart';
import '../style/text_style.dart';
import 'controller/device_details_controller.dart';
import 'qe_result_screen.dart';

class ScanQrScreenPage extends StatefulWidget {
  final String setResult;
  const ScanQrScreenPage({
    required this.setResult,
    super.key,
  });
  @override
  State<ScanQrScreenPage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ScanQrScreenPage> {
  final MobileScannerController controller = MobileScannerController();
  final TextEditingController _textController = TextEditingController();
  final DeviceController deviceController = Get.put(DeviceController());
  final List<String> showBottomSheet = ['Missing Device Utility', 'Wrong Device Utility', 'AWB MIN'];
  final TextEditingController textController = TextEditingController();
  QRViewController? _qrViewController;
  bool isSubmitting = false;
  String selectedOption = "Missing Device Utility";
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _textController.clear();
  }

  void _toggleFlash() async {
    if (_qrViewController != null) {
      _qrViewController?.toggleFlash();
    }
  }

  @override
  void dispose() {
    _textController.clear();
    super.dispose();
  }

  void _submitText() async {
    final result = _textController.text;
    if (result.isNotEmpty) {
      setState(() {
        isSubmitting = true;
      });
      await deviceController.fetchDeviceDetails(result);
      setState(() {
        isSubmitting = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Scan QR/Barcode",
            style: AppTextStyles.kCaption13SemiBoldTextStyle.copyWith(color: AppColors.white),
          ),
        ),
        actions: [
          IconButton(onPressed: _toggleFlash, icon: Icon(Icons.flash_auto)),
        ],
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 18.0, right: 18),
                child: GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      builder: (BuildContext context) {
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: showBottomSheet.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(showBottomSheet[index]),
                              onTap: () {
                                Navigator.pop(context, showBottomSheet[index]);
                              },
                            );
                          },
                        );
                      },
                    ).then((selectedOption) {
                      if (selectedOption != null) {
                        setState(() {
                          textController.text = selectedOption;
                        });
                      }
                    });
                  },
                  child: AbsorbPointer(
                    child: SizedBox(
                      height: 65,
                      child: TextFormField(
                        controller: textController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: const InputDecoration(
                          hintText: "Select Option",
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.arrow_drop_down),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please select an option';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: Container(
                  width: 370,
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 2),
                  ),
                  child: QRView(
                    key: GlobalKey(debugLabel: 'QR'),
                    onQRViewCreated: (QRViewController controller) {
                      _qrViewController = controller;
                      _qrViewController?.resumeCamera();
                      _qrViewController?.scannedDataStream.listen((scanData) async {
                        if (scanData != null && scanData.code != null) {
                          String scannedCode = scanData.code ?? '';
                          if (scannedCode.length > 15) {
                            scannedCode = scannedCode.substring(0, 15);
                          }
                          if (_textController.text != scannedCode) {
                            setState(() {
                              _textController.text = scannedCode;
                            });
                          }
                        }
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text("OR", style: AppTextStyles.kBody16SemiBoldTextStyle.copyWith(color: AppColors.error60)),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _textController,
                        decoration: const InputDecoration(
                          hintText: 'Enter AWB / IMEI Number',
                          hintStyle: TextStyle(fontWeight: FontWeight.bold),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: textController.text == "Missing Device Utility"
                            ? AppColors.primaryColor
                            : Colors.transparent,
                      ),
                      child: textController.text == "Missing Device Utility"
                          ? TextButton(
                        onPressed: isSubmitting ? null : _submitText,
                        child: isSubmitting
                            ? const CircularProgressIndicator(color: AppColors.white)
                            : const Icon(
                          Icons.arrow_forward_ios_outlined,
                          size: 35,
                          color: AppColors.white,
                        ),
                      )
                          : const SizedBox(),
                    ),
                  ],
                ),
              ),
              Obx(() {
                final device = deviceController.deviceDetail.value;
                if (device != null) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Product Name : ${device.productName}", style: AppTextStyles.kSmall12SemiBoldTextStyle),
                        Text("Device IMEI: ${device.deviceImei}", style: AppTextStyles.kSmall12SemiBoldTextStyle),
                        Text("Device Model : ${device.deviceModel}", style: AppTextStyles.kSmall10SemiBoldTextStyle),
                        Text("Serial Number : ${device.serialNumber}", style: AppTextStyles.kSmall10SemiBoldTextStyle),
                        Text("Manufacturing Months : ${device.manufacturingMonth}", style: AppTextStyles.kSmall10SemiBoldTextStyle),
                        Text("Manufacturing Year : ${device.manufacturingYear}", style: AppTextStyles.kSmall10SemiBoldTextStyle),
                        Text("Manufacturing BY : ${device.manufacturer}", style: AppTextStyles.kSmall10SemiBoldTextStyle),
                      ],
                    ),
                  );
                } else {
                  return Image.asset(noData1, height: 250, width: 250);
                }
              }),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: RoundButton(
                  title: "Next",
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      Get.to(() => QrResultScreen(
                        result: _textController.text,
                        selectedOption: textController.text,
                      ));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Please select a valid option")),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


