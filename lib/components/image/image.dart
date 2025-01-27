import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../icon/icon.dart';

class AppImage {
  static Future<dynamic> internal({
    required String token,
    required String url,
    double height = 30,
    double width = 30,
    bool isCircular = false,
  }) async {
    String fullUrl = url;
    Widget image = CachedNetworkImage(
      imageUrl: fullUrl,
      height: height,
      width: width,
      fit: BoxFit.cover,
      placeholder: (context, url) => Center(
        child: SizedBox(
          height: 25.sp,
          width: 25.sp,
          child: const CircularProgressIndicator(),
        ),
      ),
      errorWidget: (context, url, error) => Icon(AppIcon.error()),
      httpHeaders: {
        "Authorization": "Bearer $token",
      },
    );

    return isCircular ? ClipOval(child: image) : image;
  }

  static dynamic internet({
    required String url,
    double height = 30,
    double width = 30,
    bool isCircular = false,
  }) {
    String fullUrl = url;
    Widget image = CachedNetworkImage(
      imageUrl: fullUrl,
      height: height,
      width: width,
      fit: BoxFit.cover,
      placeholder: (context, url) => Center(
        child: SizedBox(
          height: 25.sp,
          width: 25.sp,
          child: const CircularProgressIndicator(),
        ),
      ),
      errorWidget: (context, url, error) => Icon(AppIcon.error()),
    );

    return isCircular ? ClipOval(child: image) : image;
  }
}
