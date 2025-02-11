import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:sizer/sizer.dart';

import '../../../components/scanner/scanner_buttons.dart';
import '../../../components/scanner/scanner_error.dart';
import '../../../core/utils/app_util.dart';
import '../../../routes/app_routes.dart';
import '../../asset/controllers/asset_controller.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key});

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  final AssetController _assetController = Get.find();
  final MobileScannerController controller = MobileScannerController(
    formats: const [
      BarcodeFormat.qrCode,
      BarcodeFormat.code128,
      BarcodeFormat.ean13,
      BarcodeFormat.ean8,
      BarcodeFormat.upcE,
      BarcodeFormat.upcA,
      BarcodeFormat.code39,
    ],
  );

  Future<void> _handleBarcode(BarcodeCapture barcodes) async {
    if (mounted) {
      Barcode? brc = barcodes.barcodes.firstOrNull;
      if (brc?.displayValue != null && brc?.displayValue != "") {
        controller.pause();
        await _assetController.fetchAssetDetailByAssetCode(brc?.displayValue);
        if (_assetController.selectedAsset.value != null) {
          await Get.toNamed(AppRoutes.assetDetail, arguments: {
            "assetId": _assetController.selectedAsset.value!.id,
          });
        }

        controller.start();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final scanWindow = Rect.fromCenter(
      center: MediaQuery.sizeOf(context).center(Offset.zero),
      width: 200,
      height: 200,
    );

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Center(
            child: MobileScanner(
              onDetect: _handleBarcode,
              fit: BoxFit.contain,
              controller: controller,
              scanWindow: scanWindow,
              errorBuilder: (context, error, child) {
                return ScannerErrorWidget(error: error);
              },
            ),
          ),
          ValueListenableBuilder(
            valueListenable: controller,
            builder: (context, value, child) {
              if (!value.isInitialized || !value.isRunning || value.error != null) {
                return const SizedBox();
              }
              return CustomPaint(
                painter: ScannerOverlay(scanWindow: scanWindow),
              );
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 35.sp),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ToggleFlashlightButton(controller: controller),
                  SwitchCameraButton(controller: controller),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Future<void> dispose() async {
    super.dispose();
    await controller.dispose();
  }
}

class ScannerOverlay extends CustomPainter {
  const ScannerOverlay({
    required this.scanWindow,
    this.borderRadius = 12.0,
  });

  final Rect scanWindow;
  final double borderRadius;

  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPath = Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    final cutoutPath = Path()
      ..addRRect(
        RRect.fromRectAndCorners(
          scanWindow,
          topLeft: Radius.circular(borderRadius),
          topRight: Radius.circular(borderRadius),
          bottomLeft: Radius.circular(borderRadius),
          bottomRight: Radius.circular(borderRadius),
        ),
      );

    final backgroundPaint = Paint()
      ..color = Colors.black.withOpacity(0.5)
      ..style = PaintingStyle.fill
      ..blendMode = BlendMode.dstOver;

    final backgroundWithCutout = Path.combine(
      PathOperation.difference,
      backgroundPath,
      cutoutPath,
    );

    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    final borderRect = RRect.fromRectAndCorners(
      scanWindow,
      topLeft: Radius.circular(borderRadius),
      topRight: Radius.circular(borderRadius),
      bottomLeft: Radius.circular(borderRadius),
      bottomRight: Radius.circular(borderRadius),
    );
    canvas.drawPath(backgroundWithCutout, backgroundPaint);
    canvas.drawRRect(borderRect, borderPaint);
  }

  @override
  bool shouldRepaint(ScannerOverlay oldDelegate) {
    return scanWindow != oldDelegate.scanWindow || borderRadius != oldDelegate.borderRadius;
  }
}

// import 'package:flutter/material.dart';
// import 'package:mobile_scanner/mobile_scanner.dart';

// class ScannerPage extends StatefulWidget {
//   const ScannerPage({super.key});

//   @override
//   State<ScannerPage> createState() => _ScannerPageState();
// }

// class _ScannerPageState extends State<ScannerPage> {
//   Barcode? _barcode;

//   Widget _buildBarcode(Barcode? value) {
//     if (value == null) {
//       return const Text(
//         'Scan something!',
//         overflow: TextOverflow.fade,
//         style: TextStyle(color: Colors.white),
//       );
//     }

//     return Text(
//       value.displayValue ?? 'No display value.',
//       overflow: TextOverflow.fade,
//       style: const TextStyle(color: Colors.white),
//     );
//   }

//   void _handleBarcode(BarcodeCapture barcodes) {
//     if (mounted) {
//       print(_barcode?.displayValue ?? "");

//       setState(() {
//         _barcode = barcodes.barcodes.firstOrNull;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Simple scanner')),
//       backgroundColor: Colors.black,
//       body: Stack(
//         children: [
//           MobileScanner(
//             onDetect: _handleBarcode,
//           ),
//           Align(
//             alignment: Alignment.bottomCenter,
//             child: Container(
//               alignment: Alignment.bottomCenter,
//               height: 100,
//               color: Colors.black.withOpacity(0.4),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   Expanded(child: Center(child: _buildBarcode(_barcode))),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
