import 'package:flutter/material.dart';
import 'package:new_fly_easy_new/features/invite_members/widgets/scanner_overlay.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({Key? key}) : super(key: key);

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  MobileScannerController cameraController =
      MobileScannerController(detectionSpeed: DetectionSpeed.noDuplicates);
  String? value;

  @override
  void dispose() {
    super.dispose();
    cameraController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            MobileScanner(
                // allowDuplicates: false,
                controller: cameraController,
                onDetect: (barcode) async {
                  value = barcode.barcodes[0].displayValue;
                  Navigator.pop(context, value);
                }),
            QRScannerOverlay(overlayColour: Colors.black.withOpacity(.5)),
          ],
        ),
      ),
    );
  }
}
