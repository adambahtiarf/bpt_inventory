import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../components/blank/blank.dart';
import '../../../components/button/button.dart';
import '../../../components/text/text.dart';
import '../../../core/constant/app_colors.dart';
import '../../../core/constant/app_enums.dart';
import '../../../core/utils/app_util.dart';
import '../../../core/utils/date_util.dart';
import '../../../main.dart';
import '../../../routes/app_routes.dart';
import '../controllers/transaction_controller.dart';

class TransactionContent extends StatefulWidget {
  const TransactionContent({super.key});

  @override
  State<TransactionContent> createState() => _TransactionContentState();
}

class _TransactionContentState extends State<TransactionContent> {
  TransactionController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppText.google(text: "Transactions", color: AppColor.white),
        backgroundColor: AppColor.blue0A1A48,
      ),
      body: Obx(
        () {
          if (controller.loading.value) return const LinearProgressIndicator();
          return RefreshIndicator(
            backgroundColor: AppColor.white,
            onRefresh: () async {
              controller.resetData();
              controller.fetchTransactions();
            },
            child: ListView.builder(
              itemCount: controller.transactions.length,
              itemBuilder: (context, index) {
                final transaction = controller.transactions[index];
                return ExpansionTile(
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText.google(
                        text: UtilDate.timeAgo(transaction.createdAt),
                        size: 8.sp,
                      ),
                      AppText.google(text: transaction.asset!.name),
                    ],
                  ),
                  subtitle: AppText.google(text: "Borrowed by ${transaction.employee!.name}", color: AppColor.grey, size: 10.sp),
                  expandedAlignment: Alignment.bottomLeft,
                  expandedCrossAxisAlignment: CrossAxisAlignment.start,
                  childrenPadding: EdgeInsets.symmetric(
                    horizontal: 20.sp,
                  ),
                  children: [
                    AppText.google(text: "Status", size: 10.sp, color: AppColor.grey),
                    AppText.google(text: transaction.status, textAlign: TextAlign.start),
                    SizedBox(
                      height: 3.sp,
                    ),
                    AppText.google(text: "Borrow Date", size: 10.sp, color: AppColor.grey),
                    AppText.google(text: UtilDate.formatDate(transaction.borrowDate), textAlign: TextAlign.start),
                    SizedBox(
                      height: 3.sp,
                    ),
                    AppText.google(text: "Expected Return Date", size: 10.sp, color: AppColor.grey),
                    AppText.google(text: UtilDate.formatDate(transaction.expectedReturnDate), textAlign: TextAlign.start),
                    SizedBox(
                      height: 3.sp,
                    ),
                    AppText.google(text: "Actual Return Date", size: 10.sp, color: AppColor.grey),
                    AppText.google(text: UtilDate.formatDate(transaction.actualReturnDate), textAlign: TextAlign.start),
                    SizedBox(
                      height: 10.sp,
                    ),
                    AppText.google(text: "Purpose", size: 10.sp, color: AppColor.grey),
                    AppText.google(text: transaction.purpose, textAlign: TextAlign.start),
                    SizedBox(
                      height: 10.sp,
                    ),
                    AppText.google(text: "Note", size: 10.sp, color: AppColor.grey),
                    AppText.google(text: transaction.note, textAlign: TextAlign.start),
                    SizedBox(
                      height: 10.sp,
                    ),
                    transaction.status != "RETURNED"
                        ? SizedBox(
                            width: AppUtil.getDeviceSize(event: DeviceSizeEvent.width, context: context),
                            child: AppButton.fill(
                              text: "Return",
                              onPressed: () async {
                                var result = await Get.toNamed(AppRoutes.transactionReturn, arguments: {
                                  'transaction': transaction,
                                });

                                kLogger.e(result);
                                if (result != null && result is List) {
                                  kLogger.e("INI LIST");
                                  if (result[0] == true) {
                                    controller.resetData();
                                    await controller.fetchTransactions();
                                  }
                                }
                              },
                              buttonEvent: ButtonEvent.secondary,
                            ),
                          )
                        : const Blank(),
                    SizedBox(
                      height: 10.sp,
                    ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}
