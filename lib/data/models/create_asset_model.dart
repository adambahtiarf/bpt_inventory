import 'package:flutter/material.dart';

import 'asset_image_model.dart';

class FormAssetModel {
  String? assetCode;
  String categoryCode;
  int categoryId;
  bool borrowable;
  DateTime purchaseDate;
  List<String> imagePaths;
  List<AssetImageModel>? images;
  TextEditingController nameCtrl;
  TextEditingController descCtrl;
  TextEditingController conditionCtrl;
  TextEditingController statusCtrl;
  TextEditingController categoryCtrl;
  TextEditingController borrowableCtrl;
  TextEditingController purchaseDateCtrl;
  int? id;

  FormAssetModel({
    required this.assetCode,
    required this.categoryCode,
    required this.categoryId,
    required this.borrowable,
    required this.purchaseDate,
    required this.imagePaths,
    this.images,
    this.id,
  })  : nameCtrl = TextEditingController(),
        descCtrl = TextEditingController(),
        conditionCtrl = TextEditingController(),
        statusCtrl = TextEditingController(),
        categoryCtrl = TextEditingController(),
        borrowableCtrl = TextEditingController(),
        purchaseDateCtrl = TextEditingController();

  void dispose() {
    nameCtrl.dispose();
    descCtrl.dispose();
    conditionCtrl.dispose();
    statusCtrl.dispose();
    categoryCtrl.dispose();
    borrowableCtrl.dispose();
    purchaseDateCtrl.dispose();
  }
}
