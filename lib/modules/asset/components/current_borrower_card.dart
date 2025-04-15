import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../components/blank/blank.dart';
import '../../../components/button/button.dart';
import '../../../components/icon/icon.dart';
import '../../../components/text/text.dart';
import '../../../core/constant/app_colors.dart';
import '../../../core/constant/app_enums.dart';
import '../../../core/utils/app_util.dart';
import '../../../core/utils/date_util.dart';
import '../../../main.dart';
import '../../../routes/app_routes.dart';
import '../controllers/asset_controller.dart';

class CurrentBorrowerCard extends StatefulWidget {
  final int assetId;
  const CurrentBorrowerCard({super.key, required this.assetId});

  @override
  State<CurrentBorrowerCard> createState() => _CurrentBorrowerCardState();
}

class _CurrentBorrowerCardState extends State<CurrentBorrowerCard> {
  final AssetController _assetController = Get.find();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _assetController.findCurrentBorrower(assetId: widget.assetId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Blank();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.connectionState == ConnectionState.done) {
          final transaction = _assetController.transaction.value;
          if (transaction == null) {
            return Text('Error: ${snapshot.error}');
          }
          if (transaction.status == "RETURNED") {
            return const Blank();
          }
          return Container(
            width: AppUtil.getDeviceSize(event: DeviceSizeEvent.width, context: context),
            margin: EdgeInsets.symmetric(vertical: 10.sp),
            decoration: BoxDecoration(
              color: AppColor.blue0A1A48,
              borderRadius: BorderRadius.circular(4.sp),
            ),
            padding: EdgeInsets.all(8.sp),
            child: Row(
              children: [
                Icon(
                  AppIcon.borrow(),
                  color: AppColor.white,
                ),
                SizedBox(
                  width: 8.sp,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText.google(text: "Current Borrower", size: 8.sp, weight: FontWeight.w600, color: AppColor.white),
                    AppText.google(text: "${transaction.employee!.name} - ${transaction.employee!.department}", color: AppColor.white),
                    AppText.google(text: "Expected return : ${UtilDate.formatDate(transaction.expectedReturnDate)}", size: 7.sp, color: AppColor.white),
                  ],
                ),
                const Spacer(),
                AppButton.text(
                    text: "Return",
                    textColor: AppColor.orangeEC6B0C,
                    onPressed: () async {
                      var result = await Get.toNamed(AppRoutes.transactionReturn, arguments: {
                        'transaction': transaction,
                      });
                      kLogger.e(result);
                      if (result != null && result is List) {
                        kLogger.e("INI LIST");
                        if (result[0] == true) {
                          kLogger.e("");
                          _assetController.findCurrentBorrower(assetId: widget.assetId);
                        }
                      }
                    })
              ],
            ),
          );
        } else {
          return const Blank();
        }
      },
    );
  }
}
