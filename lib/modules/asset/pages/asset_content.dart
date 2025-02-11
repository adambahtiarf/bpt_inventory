import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../components/badge/badge.dart';
import '../../../components/blank/blank.dart';
import '../../../components/icon/icon.dart';
import '../../../components/input/input.dart';
import '../../../components/text/text.dart';
import '../../../core/constant/app_colors.dart';
import '../../../core/constant/app_enums.dart';
import '../../../core/constant/constants.dart';
import '../../../core/utils/app_util.dart';
import '../../../main.dart';
import '../../../routes/app_routes.dart';
import '../controllers/asset_controller.dart';

class AssetContent extends StatefulWidget {
  const AssetContent({super.key});

  @override
  State<AssetContent> createState() => _AssetContentState();
}

class _AssetContentState extends State<AssetContent> {
  final AssetController controller = Get.find();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      controller.loadMore(query: _searchController.value.text);
    }
  }

  Future<void> _onRefresh() async {
    controller.resetData();
    await controller.fetchAssets();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppText.google(text: "Assets", color: AppColor.white),
        backgroundColor: AppColor.blue0A1A48,
      ),
      body: Column(
        children: [
          Obx(() {
            if (controller.loading.value && controller.assets.isEmpty) {
              return const LinearProgressIndicator();
            }
            return const Blank();
          }),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 8.sp),
            child: AppInput.global(
              txtCtrl: _searchController,
              textColor: AppColor.grey2B2B2B,
              hintText: "Search asset name or asset code...",
              prefixIcon: AppIcon.search(),
              prefixColor: AppColor.grey2B2B2B,
              action: TextInputAction.search,
              onChanged: (value) {
                controller.onSearchChanged(value); // Trigger debounced search
              },
              onFieldSubmitted: (value) {
                controller.onSearchChanged(value); // Trigger debounced search
              },
              autofocus: false,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.sp),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(() => AppText.google(
                      text: "Total asset: ${controller.totalAsset}",
                    )),
                Obx(() => AppText.google(
                      text: "Showing: ${controller.assets.length}",
                    )),
              ],
            ),
          ),
          SizedBox(
            height: 10.sp,
          ),
          Expanded(
            child: RefreshIndicator(
              backgroundColor: AppColor.white,
              onRefresh: _onRefresh,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.sp),
                child: Obx(() {
                  if (controller.loading.value && controller.assets.isEmpty) {
                    return const Blank();
                    // return const Center(child: CircularProgressIndicator());
                  } else if (controller.assets.isEmpty) {
                    return Center(child: AppText.google(text: "Data is not available"));
                  } else {
                    return GridView.builder(
                      controller: _scrollController, // Attach the ScrollController
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10.sp,
                        mainAxisSpacing: 10.sp,
                        childAspectRatio: 0.9,
                      ),
                      itemCount: controller.assets.length + (controller.hasMore ? 1 : 0), // +1 for the loading indicator
                      itemBuilder: (context, index) {
                        if (index < controller.assets.length) {
                          final asset = controller.assets[index];
                          return GestureDetector(
                            onTap: () async {
                              AppUtil.unfocus();
                              await Get.toNamed(AppRoutes.assetDetail, arguments: {
                                "assetId": asset.id,
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColor.white,
                                borderRadius: BorderRadius.circular(8.sp),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Stack(
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
                                              width: AppUtil.getDeviceSize(event: DeviceSizeEvent.width, context: context),
                                              height: 93.sp,
                                              imageBuilder: (context, imageProvider) {
                                                return ClipRRect(
                                                  borderRadius: BorderRadius.only(
                                                    topLeft: Radius.circular(8.sp),
                                                    topRight: Radius.circular(8.sp),
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
                                          : SizedBox(
                                              width: AppUtil.getDeviceSize(event: DeviceSizeEvent.width, context: context),
                                              height: 93.sp,
                                              child: Center(
                                                child: Icon(
                                                  AppIcon.noImage(),
                                                  size: 50.sp,
                                                  color: AppColor.greyE6E6E6,
                                                ),
                                              ),
                                            ),
                                      Positioned(
                                        top: 5,
                                        right: 5,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            AppBadge.assetCondition(status: asset.condition),
                                          ],
                                        ),
                                      ),
                                      asset.borrowable
                                          ? Positioned(
                                              left: 5,
                                              top: 5,
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                children: [
                                                  Icon(
                                                    AppIcon.borrow(),
                                                    color: AppColor.green29A835,
                                                  ),
                                                ],
                                              ),
                                            )
                                          : const Blank(),
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 5.sp, left: 5.sp, right: 5.sp, bottom: 5.sp),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Flexible(
                                              child: AppText.google(
                                                text: asset.name,
                                                size: 10.sp,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(left: 2.sp),
                                              child: AppBadge.assetCategory(category: asset.category != null ? asset.category!.code : ""),
                                            ),
                                          ],
                                        ),
                                        AppText.google(
                                          text: asset.assetCode,
                                          size: 8.sp,
                                          maxLines: 2,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        } else {
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 10.sp),
                            child: controller.hasMore
                                ? Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                          height: 10.sp,
                                          width: 10.sp,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2.sp,
                                          )),
                                      SizedBox(
                                        width: 8.sp,
                                      ),
                                      AppText.google(text: " Loading more..")
                                    ],
                                  ) // Show loading indicator
                                : const Text('No more items to load'),
                          );
                        }
                      },
                    );
                  }
                }),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Obx(
        () {
          if (controller.loading.value) {
            return const Blank();
          }
          return FloatingActionButton(
            onPressed: () async {
              var result = await Get.toNamed(AppRoutes.assetAdd);
              kLogger.e(result);
              if (result != null && result is List) {
                kLogger.e(result);
                if (result[0] == true) {
                  kLogger.e(result[0]);
                  controller.resetData();
                  controller.fetchAssets();
                }
              }
            },
            foregroundColor: AppColor.white,
            backgroundColor: AppColor.orangeEC6B0C,
            shape: const CircleBorder(),
            child: Icon(AppIcon.plus()),
          );
        },
      ),
    );
  }
}
