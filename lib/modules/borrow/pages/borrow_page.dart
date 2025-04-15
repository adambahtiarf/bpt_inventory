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
import '../../../data/models/asset_model.dart';
import '../controllers/borrow_controller.dart';

class BorrowPage extends StatefulWidget {
  const BorrowPage({super.key});

  @override
  State<BorrowPage> createState() => _BorrowPageState();
}

class _BorrowPageState extends State<BorrowPage> {
  BorrowController controller = Get.find();

  AssetModel asset = Get.arguments["asset"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppText.google(text: "Borrow", color: AppColor.white),
        backgroundColor: AppColor.blue0A1A48,
        iconTheme: IconThemeData(color: AppColor.white),
      ),
      body: FutureBuilder(
          future: controller.fetchEmployees(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Blank();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.connectionState == ConnectionState.done) {
              return SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.sp),
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
                            asset.images.isNotEmpty
                                ? CachedNetworkImage(
                                    imageUrl: "${Constants.kImageAssetBaseUrl}${asset.images.first.path}",
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
                                  AppText.google(text: "Item to borrow", size: 10.sp, color: AppColor.grey),
                                  AppText.google(
                                    text: asset.name,
                                    weight: FontWeight.bold,
                                    size: 16.sp,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  AppText.google(text: "Current condition : ${asset.condition} "),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 5.sp),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText.google(text: "Employee"),
                            SizedBox(
                              height: 3.sp,
                            ),
                            Row(
                              children: [
                                Flexible(
                                  child: AppInput.global(
                                    hintText: "Select employee",
                                    txtCtrl: controller.createTransaction.value.employeeTxtCtrl,
                                    readOnly: true,
                                    suffixIcon: AppIcon.keyboardArrowDown(),
                                    onTapFunc: () {
                                      AppUtil.unfocus();
                                      final categoryOptions = controller.employees.map((employee) {
                                        return {
                                          'label': '${employee.name} -r ${employee.department}',
                                          'value': employee.id,
                                        };
                                      }).toList();
                                      AppSheet.selectOneWithMapOptions(
                                          onSelectItem: ({required Map<String, Object> result}) async {
                                            final label = result["label"] as String;
                                            final value = result["value"] as int;
                                            controller.createTransaction.update((v) {
                                              if (v != null) {
                                                v.employeeId = value;
                                                v.employeeTxtCtrl.text = label;
                                              }
                                            });

                                            Get.back();
                                          },
                                          context: context,
                                          title: "Employees",
                                          options: categoryOptions);
                                    },
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 2.sp),
                                  child: AppButton.icon(
                                    iconData: AppIcon.addEmployee(),
                                    iconColor: AppColor.grey,
                                    onPressed: () {},
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 5.sp),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText.google(text: "Borrow Date"),
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
                            AppText.google(text: "Expected Return Date"),
                            SizedBox(
                              height: 3.sp,
                            ),
                            AppInput.global(
                              hintText: "Select expected return date",
                              txtCtrl: controller.createTransaction.value.expectedReturnDateTxtCtrl,
                              suffixIcon: AppIcon.calendarTodayRounded(),
                              readOnly: true,
                              onTapFunc: () async {
                                AppUtil.unfocus();
                                final DateTime now = DateTime.now();
                                final DateTime minDate = now;
                                final DateTime maxDate = DateTime(now.year + 30, now.month, now.day);

                                final DateTime? picked = await showDatePicker(
                                  context: context,
                                  initialDate: now,
                                  firstDate: minDate,
                                  lastDate: maxDate,
                                );

                                if (picked != null) {
                                  controller.createTransaction.update((v) {
                                    if (v != null) {
                                      v.expectedReturnDate = picked;
                                      v.expectedReturnDateTxtCtrl.text = UtilDate.formatDate(picked);
                                    }
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 5.sp),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText.google(text: "Purpose"),
                            SizedBox(
                              height: 3.sp,
                            ),
                            AppInput.global(
                              hintText: "Input Notes",
                              txtCtrl: controller.createTransaction.value.purposeTxtCtrl,
                              minLines: 2,
                              maxLines: 5,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 5.sp),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText.google(text: "Note"),
                            SizedBox(
                              height: 3.sp,
                            ),
                            AppInput.global(
                              hintText: "Input Notes",
                              txtCtrl: controller.createTransaction.value.notesCtrl,
                              minLines: 2,
                              maxLines: 5,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: AppUtil.getDeviceSize(event: DeviceSizeEvent.width, context: context),
                        child: AppButton.fill(
                          text: "Submit",
                          buttonEvent: ButtonEvent.secondary,
                          onPressed: () async => controller.addTransaction(assetId: asset.id),
                        ),
                      )
                    ],
                  ),
                ),
              );
            }
            return const Blank();
          }),
    );
  }
}
