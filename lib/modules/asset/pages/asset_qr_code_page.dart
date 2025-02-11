import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:sizer/sizer.dart';

import '../../../components/icon/icon.dart';
import '../../../components/message/message.dart';
import '../../../components/text/text.dart';
import '../../../core/constant/app_colors.dart';
import '../../../core/constant/app_enums.dart';
import '../../../core/utils/error_mapper_utils.dart';
import '../../../data/type/message_params.dart';

class AssetQrCodePage extends StatefulWidget {
  const AssetQrCodePage({super.key});

  @override
  State<AssetQrCodePage> createState() => _AssetQrCodePageState();
}

class _AssetQrCodePageState extends State<AssetQrCodePage> {
  final ScreenshotController screenshotController = ScreenshotController();
  late final String qrData;
  late final String assetCode;

  @override
  void initState() {
    super.initState();
    qrData = Get.arguments["qrData"];
    assetCode = Get.arguments["assetCode"];
  }

  String _getFormattedTimestamp() {
    final now = DateTime.now();
    final formattedDate = DateFormat('yyyyMMdd_HHmmss').format(now);
    return formattedDate;
  }

  Future<void> _saveQrCode() async {
    try {
      final Uint8List? imageBytes = await screenshotController.capture();

      if (imageBytes != null) {
        final result = await ImageGallerySaver.saveImage(imageBytes, name: "QR_${assetCode}_${_getFormattedTimestamp()}");

        if (result['isSuccess']) {
          MessageParams errMessage = (
            message: ErrorMapperUtils.errMessage(implEvent: ImplEvent.successSaveQr),
            messageEvent: MessageEvent.success,
            context: Get.context!,
          );
          AppMessage.snackBar(errMessage);
        } else {
          MessageParams errMessage = (
            message: ErrorMapperUtils.errMessage(implEvent: ImplEvent.failedSaveQr),
            messageEvent: MessageEvent.error,
            context: Get.context!,
          );
          AppMessage.snackBar(errMessage);
        }
      }
    } catch (e) {
      MessageParams errMessage = (
        message: ErrorMapperUtils.errMessage(implEvent: ImplEvent.failedSaveQr),
        messageEvent: MessageEvent.error,
        context: Get.context!,
      );
      AppMessage.snackBar(errMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppText.google(text: "QR Code Generator", color: AppColor.white),
        backgroundColor: AppColor.blue0A1A48,
        iconTheme: IconThemeData(color: AppColor.white),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Screenshot(
              controller: screenshotController,
              child: Container(
                padding: EdgeInsets.all(10.sp),
                color: AppColor.white,
                child: Column(
                  children: [
                    QrImageView(
                      data: qrData,
                      version: QrVersions.auto,
                      size: 200.sp,
                      backgroundColor: Colors.white,
                    ),
                    AppText.google(text: assetCode, size: 16.sp, weight: FontWeight.w500),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _saveQrCode,
        tooltip: 'Save QR Code',
        backgroundColor: AppColor.orangeEC6B0C,
        child: Icon(AppIcon.dowload()),
      ),
    );
  }
}
