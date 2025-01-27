import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:signature/signature.dart';
import 'package:sizer/sizer.dart';

import '../../components/message/message.dart';
import '../../data/type/message_params.dart';
import '../../routes/app_routes.dart';
import '../constant/app_enums.dart';
import 'error_mapper_utils.dart';
import 'permission_util.dart';

class AppUtil {
  static bool get isTablet => SizerUtil.deviceType == DeviceType.tablet;

  static bool get isMobile => SizerUtil.deviceType == DeviceType.mobile;

  static void back({
    required bool mounted,
  }) {
    if (mounted) Get.back();
  }

  static void returnArguments({
    required List<dynamic> arguments,
    required bool mounted,
  }) {
    if (mounted) {
      Get.back(
        result: arguments,
      );
    }
  }

  static Size appBarPS() {
    if (isTablet) {
      return Size.fromHeight(
        (kToolbarHeight + 30.sp),
      );
    }

    if (isMobile) {
      return Size.fromHeight(
        (kToolbarHeight + 10.sp),
      );
    }

    return Size.zero;
  }

  static double? appBarLW() {
    if (isTablet) return 50.sp;

    return null;
  }

  static double? appBarTS() {
    if (isMobile) return 0;

    return null;
  }

  static double? appBarTH() {
    if (isTablet) return (kToolbarHeight + 30.sp);

    if (isMobile) return (kToolbarHeight + 10.sp);

    return null;
  }

  static double statusBarHeight({
    required BuildContext context,
  }) =>
      MediaQueryData.fromView(
        View.of(
          context,
        ),
      ).viewPadding.top;

  static void closeApp() {
    if (Platform.isAndroid) {
      try {
        SystemNavigator.pop();
      } on PlatformException catch (_) {}
    }
  }

  static void backToInit() {
    Get.offAllNamed(AppRoutes.login);
  }

  static Future<File?> openCamera() async {
    bool cameraPermission = await PermissionUtil.getCameraPermission();

    if (!cameraPermission) {
      MessageParams errMessage = (
        message: ErrorMapperUtils.errMessage(implEvent: ImplEvent.openCamera),
        messageEvent: MessageEvent.error,
        context: Get.context!,
      );
      AppMessage.snackBar(errMessage);
      return null;
    }

    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      return File(pickedFile.path);
    }

    return null;
  }

  static Future<File> generateImgPreview({
    required GlobalKey<State<StatefulWidget>> repaintKey,
  }) async {
    try {
      if (repaintKey.currentContext != null) {
        final boundary = repaintKey.currentContext!.findRenderObject() as RenderRepaintBoundary;

        final image = await boundary.toImage();

        final byte = await image.toByteData(
          format: ImageByteFormat.png,
        );

        if (byte != null) {
          final imageBytes = byte.buffer.asUint8List();

          final fileName = DateTime.now().millisecondsSinceEpoch.toString();

          final appDocsDirectory = await getApplicationDocumentsDirectory();

          final file = await File("${appDocsDirectory.path}/$fileName.png").create();

          return file.writeAsBytes(
            imageBytes,
          );
        }

        throw Exception('Failed to generate image');
      }

      throw Exception('Failed to generate image');
    } on MissingPlatformDirectoryException catch (_) {
      throw Exception('Failed to generate image');
    } on FileSystemException catch (_) {
      throw Exception('Failed to generate image');
    } catch (_) {
      throw Exception('Failed to generate image');
    }
  }

  static double getDeviceSize({
    required DeviceSizeEvent event,
    required BuildContext context,
  }) {
    Size deviceSize = MediaQuery.sizeOf(
      context,
    );

    switch (event) {
      case DeviceSizeEvent.height:
        return deviceSize.height;

      case DeviceSizeEvent.width:
        return deviceSize.width;

      default:
    }

    return 0;
  }

  static Future<File> createSignatureFile({
    required SignatureController signatureCtrl,
  }) async {
    try {
      final fileName = "signature-${DateTime.now().millisecondsSinceEpoch.toString().trim()}";

      final appDocsDirectory = await getApplicationDocumentsDirectory();

      final uInt8List = await signatureCtrl.toPngBytes();

      if (uInt8List != null) {
        return await File(
          "${appDocsDirectory.path.trim()}/$fileName.png",
        ).create().then(
              (result) => result.writeAsBytes(
                uInt8List,
              ),
            );
      }

      throw Exception('Failed to save image');
    } on MissingPlatformDirectoryException catch (_) {
      throw Exception('Failed to save image');
    } on FileSystemException catch (_) {
      throw Exception('Failed to save image');
    }
  }
}
