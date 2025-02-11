import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';
import '../../../components/button/button.dart';
import '../../../components/icon/icon.dart';
import '../../../components/input/input.dart';
import '../../../components/message/message.dart';
import '../../../components/sheet/sheet.dart';
import '../../../components/text/text.dart';
import '../../../core/constant/app_colors.dart';
import '../../../core/constant/app_enums.dart';
import '../../../core/utils/app_util.dart';
import '../../../core/utils/date_util.dart';
import '../../../core/utils/error_mapper_utils.dart';
import '../../../data/asset_borrowable_data.dart';
import '../../../data/asset_conditions_data.dart';
import '../../../data/asset_statuses_data.dart';
import '../../../data/models/category_model.dart';
import '../../../data/models/create_asset_model.dart';
import '../../../data/type/message_params.dart';
import '../../../main.dart';
import '../controllers/asset_controller.dart';

class AssetAddPage extends StatefulWidget {
  const AssetAddPage({super.key});

  @override
  State<AssetAddPage> createState() => _AssetAddPageState();
}

class _AssetAddPageState extends State<AssetAddPage> {
  final AssetController controller = Get.find();
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchCategories();
      controller.resetCreateAsset();
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    final statusCamera = await Permission.camera.request();

    if (statusCamera.isGranted) {
      final pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        controller.createAsset.update((asset) {
          asset?.imagePaths.add(pickedFile.path);
        });
      }
    } else {
      kLogger.e(statusCamera.name);
      MessageParams errMessage = (
        message: ErrorMapperUtils.errMessage(implEvent: ImplEvent.openCamera),
        messageEvent: MessageEvent.success,
        context: Get.context!,
      );
      AppMessage.snackBar(errMessage);
    }
  }

  void _removePath(int index) {
    controller.createAsset.update((asset) {
      asset?.imagePaths.removeAt(index);
    });
  }

  void _showImagePickerOptions() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text("Take a Photo"),
              onTap: () {
                Get.back(); // Close bottom sheet
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.image),
              title: const Text("Choose from Gallery"),
              onTap: () {
                Get.back(); // Close bottom sheet
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.close),
              title: const Text("Cancel"),
              onTap: () => Get.back(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppText.google(text: "Add Asset", color: AppColor.white),
        backgroundColor: AppColor.blue0A1A48,
        iconTheme: IconThemeData(color: AppColor.white),
      ),
      body: Obx(() {
        List<CategoryModel> categories = controller.categories;
        FormAssetModel? createAsset = controller.createAsset.value;
        if (controller.loading.value) {
          return const LinearProgressIndicator();
        }
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.sp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10.sp,
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 5.sp),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText.google(text: "Name"),
                      SizedBox(
                        height: 3.sp,
                      ),
                      AppInput.global(hintText: "Enter asset name", txtCtrl: createAsset.nameCtrl),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 5.sp),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText.google(text: "Category"),
                      SizedBox(
                        height: 3.sp,
                      ),
                      Row(
                        children: [
                          Flexible(
                            child: AppInput.global(
                              hintText: "Select a category",
                              txtCtrl: createAsset.categoryCtrl,
                              readOnly: true,
                              suffixIcon: AppIcon.keyboardArrowDown(),
                              onTapFunc: () {
                                AppUtil.unfocus();
                                final categoryOptions = categories.map((category) {
                                  return {
                                    'label': category.name,
                                    'value': category.id,
                                    'code': category.code,
                                  };
                                }).toList();
                                AppSheet.selectOneWithMapOptions(
                                    onSelectItem: ({required Map<String, Object> result}) async {
                                      kLogger.e("asdasd");
                                      final label = result["label"] as String;
                                      final value = result["value"] as int;
                                      final code = result["code"] as String;
                                      createAsset.categoryCtrl.text = label;
                                      createAsset.categoryId = value;
                                      createAsset.categoryCode = code;
                                      Get.back();
                                    },
                                    context: context,
                                    title: "Category",
                                    options: categoryOptions);
                              },
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 2.sp),
                            child: AppButton.icon(
                              iconData: AppIcon.plus(),
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
                      AppText.google(text: "Condition"),
                      SizedBox(
                        height: 3.sp,
                      ),
                      AppInput.global(
                        hintText: "Select a condition",
                        txtCtrl: createAsset.conditionCtrl,
                        readOnly: true,
                        suffixIcon: AppIcon.keyboardArrowDown(),
                        onTapFunc: () {
                          AppUtil.unfocus();
                          AppSheet.selectOne(
                              onSelectItem: ({required value}) async {
                                createAsset.conditionCtrl.text = value;
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
                Container(
                  margin: EdgeInsets.only(bottom: 5.sp),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText.google(text: "Borrowable"),
                      SizedBox(
                        height: 3.sp,
                      ),
                      AppInput.global(
                        hintText: "Select is the borrowable",
                        txtCtrl: createAsset.borrowableCtrl,
                        readOnly: true,
                        suffixIcon: AppIcon.keyboardArrowDown(),
                        onTapFunc: () {
                          AppUtil.unfocus();
                          AppSheet.selectOne(
                              onSelectItem: ({required value}) async {
                                createAsset.borrowableCtrl.text = value;
                                if (value == "TRUE") {
                                  createAsset.borrowable = true;
                                } else {
                                  createAsset.borrowable = true;
                                }
                                Get.back();
                              },
                              context: context,
                              title: "Conditions",
                              options: AssetBorrowableData.assetBorrowable);
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
                      AppText.google(text: "Status"),
                      SizedBox(
                        height: 3.sp,
                      ),
                      AppInput.global(
                        hintText: "Select current status",
                        txtCtrl: createAsset.statusCtrl,
                        readOnly: true,
                        suffixIcon: AppIcon.keyboardArrowDown(),
                        onTapFunc: () {
                          AppUtil.unfocus();
                          AppSheet.selectOne(
                              onSelectItem: ({required value}) async {
                                createAsset.statusCtrl.text = value;
                                Get.back();
                              },
                              context: context,
                              title: "Conditions",
                              options: AssetStatusesData.assetStatuses);
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
                      AppText.google(text: "Purchase Date"),
                      SizedBox(
                        height: 3.sp,
                      ),
                      AppInput.global(
                          hintText: "Select purchase date",
                          txtCtrl: createAsset.purchaseDateCtrl,
                          suffixIcon: AppIcon.calendarTodayRounded(),
                          readOnly: true,
                          onTapFunc: () async {
                            AppUtil.unfocus();
                            final DateTime now = DateTime.now();
                            final DateTime minDate = DateTime(now.year - 30, now.month, now.day);
                            final DateTime maxDate = now;

                            final DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: now,
                              firstDate: minDate,
                              lastDate: maxDate,
                            );

                            if (picked != null) {
                              createAsset.purchaseDateCtrl.text = UtilDate.formatDate(picked);
                              createAsset.purchaseDate = picked;
                            }
                          }),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 5.sp),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText.google(text: "Description"),
                      SizedBox(
                        height: 3.sp,
                      ),
                      AppInput.global(
                        txtCtrl: createAsset.descCtrl,
                        minLines: 3,
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
                      AppText.google(text: "Add Images"),
                      SizedBox(
                        height: 3.sp,
                      ),
                      Wrap(
                        spacing: 10.sp,
                        children: [
                          for (var i = 0; i < createAsset.imagePaths.length; i++)
                            Container(
                              width: 80.sp,
                              height: 80.sp,
                              padding: EdgeInsets.all(5.sp),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.sp),
                                border: Border.all(
                                  color: AppColor.greyAAAAAA,
                                  width: 1.sp,
                                ),
                              ),
                              child: Center(
                                child: Stack(
                                  children: [
                                    Image.file(
                                      width: AppUtil.getDeviceSize(event: DeviceSizeEvent.width, context: context),
                                      height: AppUtil.getDeviceSize(event: DeviceSizeEvent.height, context: context),
                                      File(createAsset.imagePaths[i]),
                                      fit: BoxFit.cover, // Adjust how the image fits in its container
                                      errorBuilder: (context, error, stackTrace) {
                                        return Center(
                                          child: Icon(AppIcon.error()),
                                        );
                                      },
                                    ),
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: GestureDetector(
                                        onTap: () => _removePath(i),
                                        child: Icon(
                                          AppIcon.closeRounded(),
                                          color: AppColor.redCF1322,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          GestureDetector(
                            onTap: _showImagePickerOptions,
                            child: Container(
                              width: 80.sp,
                              height: 80.sp,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.sp),
                                border: Border.all(
                                  color: AppColor.greyAAAAAA,
                                  width: 1.sp,
                                ),
                              ),
                              padding: EdgeInsets.all(8.sp),
                              child: Center(
                                child: Icon(
                                  AppIcon.addImage(),
                                  size: 25.sp,
                                  color: AppColor.greyAAAAAA,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10.sp,
                ),
                SizedBox(
                  width: AppUtil.getDeviceSize(event: DeviceSizeEvent.width, context: context),
                  child: AppButton.fill(
                    text: "Save",
                    onPressed: () => controller.saveAsset(),
                    buttonEvent: ButtonEvent.secondary,
                  ),
                ),
                SizedBox(
                  height: 30.sp,
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
