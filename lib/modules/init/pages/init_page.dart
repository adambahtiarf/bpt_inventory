import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../components/button/button.dart';
import '../../../components/text/text.dart';
import '../../../routes/app_routes.dart';
import '../controllers/init_controller.dart';

class InitPage extends StatelessWidget {
  const InitPage({super.key});

  @override
  Widget build(BuildContext context) {
    final InitController controller = Get.find();
    return Scaffold(
      body: Center(
        child: Obx(() {
          if (!controller.loading.value) {
            if (!controller.isLocationGranted.value || !controller.isCameraGranted.value) {
              String missingPermission = '';

              if (!controller.isLocationGranted.value) {
                missingPermission = 'Lokasi';
              }
              if (!controller.isCameraGranted.value) {
                missingPermission += missingPermission.isEmpty ? 'Kamera' : ' dan Kamera';
              }
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AppText.google(text: "Mohon lengkapi izin: $missingPermission"),
                  SizedBox(
                    height: 10.sp,
                  ),
                  AppText.google(text: "Aplikasi memerlukan Anda untuk mengaktifkannya."),
                  AppButton.fill(
                    text: "Perbarui Izin",
                    onPressed: () async {
                      if (!controller.isLocationGranted.value) {
                        await controller.checkLocationPermission();
                      }
                      if (!controller.isCameraGranted.value) {
                        await controller.checkCameraPermission();
                      }
                    },
                  )
                ],
              );
            }
            Future.microtask(() => Get.offAllNamed(AppRoutes.login));
          }
          return const CircularProgressIndicator();
        }),
      ),
    );
  }
}
