import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../components/badge/badge.dart';
import '../../../components/blank/blank.dart';
import '../../../components/button/button.dart';
import '../../../components/dialog/dialog.dart';
import '../../../components/icon/icon.dart';
import '../../../components/text/text.dart';
import '../../../core/constant/app_colors.dart';
import '../../../core/constant/app_enums.dart';
import '../../../core/constant/constants.dart';
import '../../../core/utils/app_util.dart';
import '../../../core/utils/date_util.dart';
import '../../../main.dart';
import '../../../routes/app_routes.dart';
import '../controllers/asset_controller.dart';

class AssetDetailPage extends StatefulWidget {
  const AssetDetailPage({super.key});

  @override
  State<AssetDetailPage> createState() => _AssetDetailPageState();
}

class _AssetDetailPageState extends State<AssetDetailPage> {
  final AssetController controller = Get.find();
  late final int assetId;
  @override
  void initState() {
    super.initState();
    assetId = Get.arguments["assetId"];
    kLogger.w(assetId);
    controller.fetchAssetDetail(assetId); // Fetch detail data
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: AppText.google(text: "Detail Asset", color: AppColor.white),
          backgroundColor: AppColor.blue0A1A48,
          iconTheme: IconThemeData(color: AppColor.white),
          actions: [
            Obx(
              () {
                if (controller.isLoadingDetail.value) {
                  return const Blank();
                }
                final asset = controller.selectedAsset.value;

                if (asset == null) {
                  return const Blank();
                }
                return AppButton.icon(
                  onPressed: () {
                    Get.toNamed(
                      AppRoutes.assetQR,
                      arguments: {
                        "qrData": "https://example.com/asset/123", // TODO : CHANGE THIS TO REAL LINK
                        "assetCode": asset.assetCode,
                      },
                    );
                  },
                  iconData: AppIcon.qr(),
                );
              },
            ),
            Obx(
              () {
                if (controller.isLoadingDetail.value) {
                  return const Blank();
                }
                final asset = controller.selectedAsset.value;

                if (asset == null) {
                  return const Blank();
                }
                return AppButton.icon(
                    onPressed: () {
                      Get.toNamed(
                        AppRoutes.assetEdit,
                        arguments: {
                          "asset": asset,
                        },
                      );
                    },
                    iconData: AppIcon.pen());
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Obx(
            () {
              if (controller.isLoadingDetail.value) {
                return const LinearProgressIndicator();
              }
              final asset = controller.selectedAsset.value;
              if (asset == null) {
                return Center(child: AppText.google(text: "Data is not available"));
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CarouselSlider(
                    options: CarouselOptions(
                      height: 180.sp,
                      viewportFraction: 1.0,
                      enableInfiniteScroll: false,
                    ),
                    items: (asset.images.isNotEmpty
                            ? asset.images
                            : [
                                null
                              ])
                        .map((image) {
                      return Builder(
                        builder: (BuildContext context) {
                          return SizedBox(
                            width: MediaQuery.of(context).size.width, // Ensures full width
                            child: image != null
                                ? GestureDetector(
                                    onTap: () => AppDialog.showImageDialog(context: context, imageUrl: "${Constants.kImageAssetBaseUrl}${image.path}"),
                                    child: CachedNetworkImage(
                                      imageUrl: "${Constants.kImageAssetBaseUrl}${image.path}",
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) => Center(
                                        child: SizedBox(
                                          width: 15.sp,
                                          height: 15.sp,
                                          child: const CircularProgressIndicator(),
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(
                                    color: AppColor.greyE6E6E6,
                                    child: Center(
                                      child: Icon(
                                        AppIcon.noImage(),
                                        size: 30.sp,
                                      ),
                                    ),
                                  ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.sp),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        asset.status == "CURRENTLY BORROWED"
                            ? Container(
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
                                        AppText.google(text: "Jessa Arditya - Sales", color: AppColor.white),
                                        AppText.google(text: "Expected return : 10/02/2005", size: 7.sp, color: AppColor.white),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            : SizedBox(
                                height: 10.sp,
                              ),
                        AppText.google(text: asset.name, size: 15.sp, weight: FontWeight.w500),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 5.sp),
                          child: Wrap(
                            spacing: 5.sp,
                            children: [
                              AppBadge.assetStatus(status: asset.status, size: 10.sp),
                              AppBadge.assetCondition(status: asset.condition, size: 10.sp),
                              AppBadge.assetCategory(category: asset.category?.name, size: 10.sp),
                              if (asset.borrowable == true) AppBadge.assetBorrowable(borrowable: true, size: 10.sp),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 5.sp,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: AppText.google(text: "Asset Code : ", weight: FontWeight.w500),
                            ),
                            AppText.google(text: asset.assetCode),
                          ],
                        ),
                        Divider(
                          color: AppColor.greyAAAAAA,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: AppText.google(text: "Purchase Date : ", weight: FontWeight.w500),
                            ),
                            AppText.google(text: UtilDate.formatDate(asset.purchaseDate)),
                          ],
                        ),
                        Divider(
                          color: AppColor.greyAAAAAA,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: AppText.google(text: "Activity Logs : ", weight: FontWeight.w500),
                            ),
                            GestureDetector(
                              child: AppText.google(
                                text: "Details",
                                color: AppColor.orangeEC6B0C,
                              ),
                            ),
                          ],
                        ),
                        Divider(
                          color: AppColor.greyAAAAAA,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: AppText.google(text: "Transaction Logs : ", weight: FontWeight.w500),
                            ),
                            GestureDetector(
                              child: AppText.google(
                                text: "Details",
                                color: AppColor.orangeEC6B0C,
                              ),
                            ),
                          ],
                        ),
                        Divider(
                          color: AppColor.greyAAAAAA,
                        ),
                        AppText.google(text: "Description ", weight: FontWeight.w500),
                        AppText.google(text: asset.desc),
                        SizedBox(
                          height: 50.sp,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        floatingActionButton: Obx(
          () {
            if (controller.isLoadingDetail.value) {
              return const Blank();
            }
            final asset = controller.selectedAsset.value;

            if (asset == null) {
              return const Blank();
            }
            return !asset.borrowable || asset.status != "AVAILABLE"
                ? const SizedBox()
                : AppButton.fill(
                    text: "Borrow Now",
                    buttonEvent: ButtonEvent.secondary,
                    onPressed: () {},
                  );
          },
        ));
  }
}
