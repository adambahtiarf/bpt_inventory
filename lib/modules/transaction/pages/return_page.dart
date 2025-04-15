import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../components/blank/blank.dart';
import '../../../components/button/button.dart';
import '../../../components/icon/icon.dart';
import '../../../components/input/input.dart';
import '../../../components/sheet/sheet.dart';
import '../../../components/text/text.dart';
import '../../../core/constant/app_colors.dart';
import '../../../core/constant/app_enums.dart';
import '../../../core/constant/constants.dart';
import '../../../core/utils/app_util.dart';
import '../../../core/utils/date_util.dart';
import '../../../data/asset_conditions_data.dart';
import '../../../data/models/transaction_model.dart';
import '../controllers/transaction_controller.dart';

class ReturnPage extends StatefulWidget {
  const ReturnPage({super.key});

  @override
  State<ReturnPage> createState() => _ReturnPageState();
}

class _ReturnPageState extends State<ReturnPage> {
  TransactionController controller = Get.find();
  final TextEditingController conditionTxtCtrl = TextEditingController();
  TransactionModel transaction = Get.arguments["transaction"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppText.google(text: "Return asset", color: AppColor.white),
        backgroundColor: AppColor.blue0A1A48,
        iconTheme: IconThemeData(color: AppColor.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.sp),
          child: Column(
            children: [
              Container(
                width: AppUtil.getDeviceSize(event: DeviceSizeEvent.width, context: context),
                margin: EdgeInsets.only(top: 15.sp, bottom: 5.sp),
                decoration: BoxDecoration(
                  color: AppColor.white,
                  borderRadius: BorderRadius.circular(8.sp),
                ),
                padding: EdgeInsets.all(8.sp),
                child: Row(
                  children: [
                    transaction.asset!.images.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: "${Constants.kImageAssetBaseUrl}${transaction.asset!.images.first.path}",
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Center(
                              child: SizedBox(
                                width: 15.sp,
                                height: 15.sp,
                                child: const CircularProgressIndicator(),
                              ),
                            ),
                            width: 93.sp,
                            height: 93.sp,
                            imageBuilder: (context, imageProvider) {
                              return ClipRRect(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(8.sp),
                                  topRight: Radius.circular(8.sp),
                                  bottomLeft: Radius.circular(8.sp),
                                  bottomRight: Radius.circular(8.sp),
                                ),
                                child: Image(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                  width: AppUtil.getDeviceSize(event: DeviceSizeEvent.width, context: context),
                                  height: 93.sp,
                                ),
                              );
                            },
                          )
                        : const Blank(),
                    SizedBox(
                      width: 10.sp,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText.google(text: "Item to return", size: 10.sp, color: AppColor.grey),
                          AppText.google(
                            text: transaction.asset!.name,
                            weight: FontWeight.bold,
                            size: 16.sp,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(
                            height: 3.sp,
                          ),
                          AppText.google(text: "Status : ${transaction.status} "),
                          SizedBox(
                            height: 3.sp,
                          ),
                          AppText.google(text: "Last condition : ${transaction.asset!.condition} "),
                          SizedBox(
                            height: 3.sp,
                          ),
                          AppText.google(text: "Expected return date : ${UtilDate.formatDate(transaction.expectedReturnDate)}"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                color: AppColor.grey,
              ),
              SizedBox(
                height: 3.sp,
              ),
              Container(
                margin: EdgeInsets.only(bottom: 5.sp),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText.google(text: "Return Date"),
                    SizedBox(
                      height: 3.sp,
                    ),
                    AppInput.global(
                      hintText: "Borrow Date",
                      txtCtrl: TextEditingController(
                        text: UtilDate.formatDate(
                          DateTime.now(),
                        ),
                      ),
                      suffixIcon: AppIcon.calendarTodayRounded(),
                      // enabled: false,
                      readOnly: true,
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 5.sp),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText.google(text: "Return condition"),
                    SizedBox(
                      height: 3.sp,
                    ),
                    AppInput.global(
                      hintText: "Select a condition",
                      txtCtrl: conditionTxtCtrl,
                      readOnly: true,
                      suffixIcon: AppIcon.keyboardArrowDown(),
                      onTapFunc: () {
                        AppUtil.unfocus();
                        AppSheet.selectOne(
                            onSelectItem: ({required value}) async {
                              conditionTxtCtrl.text = value;
                              Get.back();
                            },
                            context: context,
                            title: "Borrowable",
                            options: AssetConditionsData.assetConditionsData);
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 5.sp,
              ),
              SizedBox(
                width: AppUtil.getDeviceSize(event: DeviceSizeEvent.width, context: context),
                child: AppButton.fill(
                  buttonEvent: ButtonEvent.secondary,
                  text: "Return",
                  onPressed: () async => await controller.returnAsset(
                    transactionId: transaction.id,
                    assetId: transaction.assetId,
                    status: conditionTxtCtrl.text,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
