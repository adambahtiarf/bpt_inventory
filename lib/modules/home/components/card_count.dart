import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../components/blank/blank.dart';
import '../../../components/text/text.dart';
import '../../../core/constant/app_colors.dart';
import '../controllers/home_controller.dart';

class CardCount extends StatefulWidget {
  final String queryCount;
  final String label;
  const CardCount({
    required this.queryCount,
    required this.label,
    super.key,
  });

  @override
  State<CardCount> createState() => _CardCountState();
}

class _CardCountState extends State<CardCount> {
  final HomeController controller = Get.find();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: controller.fetchCard(queryCount: widget.queryCount),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Blank();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.connectionState == ConnectionState.done) {
          return Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.sp),
                color: AppColor.white,
              ),
              padding: EdgeInsets.all(8.sp),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText.google(text: widget.label),
                  SizedBox(
                    height: 3.sp,
                  ),
                  AppText.google(text: snapshot.data.toString(), size: 30.sp, weight: FontWeight.bold),
                ],
              ),
            ),
          );
        }
        return const Blank();
      },
    );
  }
}
