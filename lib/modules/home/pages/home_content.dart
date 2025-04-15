import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../components/text/text.dart';
import '../../../core/constant/app_colors.dart';
import '../../../core/constant/app_enums.dart';
import '../../../core/utils/app_util.dart';
import '../components/card_count.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppText.google(text: "Home", color: AppColor.white),
        backgroundColor: AppColor.blue0A1A48,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.sp),
          child: Column(
            children: [
              SizedBox(
                height: 10.sp,
              ),
              Container(
                margin: EdgeInsets.only(bottom: 10.sp),
                width: AppUtil.getDeviceSize(event: DeviceSizeEvent.width, context: context),
                child: Row(
                  children: [
                    const CardCount(queryCount: "total_asset", label: "Total Asset"),
                    SizedBox(
                      width: 10.sp,
                    ),
                    const CardCount(queryCount: "active_transaction", label: "Active Transaction"),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 10.sp),
                width: AppUtil.getDeviceSize(event: DeviceSizeEvent.width, context: context),
                child: Row(
                  children: [
                    const CardCount(queryCount: "broken_asset", label: "Broken Asset"),
                    SizedBox(
                      width: 10.sp,
                    ),
                    const CardCount(queryCount: "total_employee", label: "Total Employee"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
