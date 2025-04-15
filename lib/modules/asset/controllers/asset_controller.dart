import 'dart:async';
import 'dart:io';

import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../components/message/message.dart';
import '../../../core/constant/app_enums.dart';
import '../../../core/utils/date_util.dart';
import '../../../core/utils/error_mapper_utils.dart';
import '../../../data/models/asset_model.dart';
import '../../../data/models/category_model.dart';
import '../../../data/models/create_asset_model.dart';
import '../../../data/models/transaction_model.dart';
import '../../../data/type/message_params.dart';
import '../../../main.dart';

class AssetController extends GetxController {
  final SupabaseClient supabase = Supabase.instance.client;
  final RxList<AssetModel> assets = <AssetModel>[].obs;
  final Rx<AssetModel?> selectedAsset = Rx<AssetModel?>(null);
  final RxList<CategoryModel> categories = <CategoryModel>[].obs;
  final RxInt totalAsset = 0.obs;
  final Rx<TransactionModel?> transaction = Rx<TransactionModel?>(null);
  // final Rx<CreateAssetModel?> assetForm = Rx<CreateAssetModel?>(null);

  Rx<FormAssetModel> createAsset = FormAssetModel(
    assetCode: "",
    categoryCode: "",
    categoryId: 0,
    borrowable: false,
    purchaseDate: DateTime.now(),
    imagePaths: [],
  ).obs;

  Rx<FormAssetModel> editAsset = FormAssetModel(
    assetCode: "",
    categoryCode: "",
    categoryId: 0,
    borrowable: false,
    purchaseDate: DateTime.now(),
    imagePaths: [],
  ).obs;

  final RxBool isLoadingDetail = false.obs;
  final RxBool loading = false.obs;
  final int limit = 20;
  int offset = 0;
  bool hasMore = true;
  Timer? _debounce;

  @override
  void onInit() {
    fetchAssets();
    super.onInit();
  }

  void resetData() {
    assets.clear();
    offset = 0;
    hasMore = true;
  }

  Future<void> fetchAssets({String query = ''}) async {
    if (!hasMore) return;

    try {
      loading.value = true;
      totalAsset.value = await _getAssetsCount();
      final response = await supabase.from('assets').select('''
            *,
            asset_images (*),
            categories!inner(*)
          ''').or('name.ilike.%$query%,asset_code.ilike.%$query%').order('created_at', ascending: false).range(offset, offset + limit - 1);

      kLogger.e(response);
      if (response.isNotEmpty) {
        assets.addAll(
          (response as List).map((data) => AssetModel.fromMap(data)).toList(),
        );

        offset += limit;
        hasMore = response.length == limit;
      } else {
        hasMore = false;
      }
    } catch (e) {
      kLogger.e(e);
      MessageParams errMessage = (
        message: ErrorMapperUtils.errMessage(implEvent: ImplEvent.fetchFailed),
        messageEvent: MessageEvent.error,
        context: Get.context!,
      );
      AppMessage.snackBar(errMessage);
    } finally {
      loading.value = false;
    }
  }

  Future<void> loadMore({String query = ''}) async {
    if (hasMore) {
      await fetchAssets(query: query);
    }
  }

  void onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (query.length >= 2) {
        resetData();
        fetchAssets(query: query);
      } else if (query.isEmpty) {
        resetData();
        fetchAssets();
      }
    });
  }

  Future<void> fetchAssetDetail(int assetId) async {
    try {
      isLoadingDetail.value = true;
      selectedAsset.value = null;

      final response = await supabase.from('assets').select('''
            *,
            asset_images (*),
            asset_logs(*),
            transaction(*, employees(*)),
            categories!inner(*)
          ''').eq('id', assetId).order('created_at', ascending: false, referencedTable: 'asset_logs').single();

      if (response.isNotEmpty) {
        kLogger.e(response);
        selectedAsset.value = AssetModel.fromMap(response);
      }
    } catch (e) {
      kLogger.e(e);
      MessageParams errMessage = (
        message: ErrorMapperUtils.errMessage(implEvent: ImplEvent.fetchFailed),
        messageEvent: MessageEvent.error,
        context: Get.context!,
      );
      AppMessage.snackBar(errMessage);
    } finally {
      isLoadingDetail.value = false;
    }
  }

  Future<void> fetchAssetDetailByAssetCode(String? assetCode) async {
    try {
      if (assetCode == null) {
        throw Exception();
      }
      isLoadingDetail.value = true;
      selectedAsset.value = null;

      final response = await supabase.from('assets').select('''
            *,
            asset_images (*),
            categories!inner(*)
          ''').eq('asset_code', assetCode).single();

      if (response.isNotEmpty) {
        kLogger.e(response);
        selectedAsset.value = AssetModel.fromMap(response);
      }
    } catch (e) {
      kLogger.e(e);
      MessageParams errMessage = (
        message: ErrorMapperUtils.errMessage(implEvent: ImplEvent.fetchFailed),
        messageEvent: MessageEvent.error,
        context: Get.context!,
      );
      AppMessage.snackBar(errMessage);
    } finally {
      isLoadingDetail.value = false;
    }
  }

  Future<void> fetchCategories() async {
    try {
      loading.value = true;
      final response = await supabase.from('categories').select('id, code, name, created_at').order('created_at', ascending: false);

      if (response.isNotEmpty) {
        categories.assignAll(
          (response as List).map((data) => CategoryModel.fromMap(data)).toList(),
        );
      }
    } catch (e) {
      kLogger.e(e);
      MessageParams errMessage = (
        message: "Failed to fetch categories",
        messageEvent: MessageEvent.error,
        context: Get.context!,
      );
      AppMessage.snackBar(errMessage);
    } finally {
      loading.value = false;
    }
  }

  void resetCreateAsset() {
    createAsset.value = FormAssetModel(
      assetCode: "",
      categoryCode: "",
      categoryId: 0,
      borrowable: false,
      purchaseDate: DateTime.now(),
      imagePaths: [],
    );
  }

  void resetEditAsset() {
    editAsset.value = FormAssetModel(
      assetCode: "",
      categoryCode: "",
      categoryId: 0,
      borrowable: false,
      purchaseDate: DateTime.now(),
      imagePaths: [],
    );
  }

  Future<void> saveAsset() async {
    try {
      loading.value = true;
      if (_validateAsset(createAsset.value)) {
        final DateTime now = DateTime.now();
        String uniqueTimeStamp = "${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}";
        final asset = createAsset.value;
        final totalAsset = await _getAssetsCount();
        createAsset.value.assetCode = "${asset.categoryCode}-$uniqueTimeStamp$totalAsset";

        kLogger.i(createAsset.value.assetCode);

        final addAssetResponse = await supabase
            .from('assets')
            .insert([
              {
                'asset_code': createAsset.value.assetCode,
                'name': createAsset.value.nameCtrl.text,
                'desc': createAsset.value.descCtrl.text,
                'condition': createAsset.value.conditionCtrl.text,
                'borrowable': createAsset.value.borrowable,
                'status': createAsset.value.statusCtrl.text,
                'purchase_date': createAsset.value.purchaseDateCtrl.text,
                'category_id': createAsset.value.categoryId
              }
            ])
            .select()
            .single();

        kLogger.i(addAssetResponse);
        for (var i = 0; i < createAsset.value.imagePaths.length; i++) {
          final File imageFile = File(createAsset.value.imagePaths[i]);

          String fileName = "${DateTime.now().millisecondsSinceEpoch}.png";
          String path = fileName;
          final uplopadImageResponse = await supabase.storage.from('asset_images').upload(path, imageFile);
          kLogger.i(uplopadImageResponse);

          final addAssetImageResponse = await supabase.from('asset_images').insert([
            {
              'asset_id': addAssetResponse['id'],
              'path': fileName,
            }
          ]);
          kLogger.i(addAssetImageResponse);

          Get.back(
            result: [
              true
            ],
          );
        }
      } else {
        MessageParams errMessage = (
          message: ErrorMapperUtils.errMessage(implEvent: ImplEvent.failedToValidateAddAsset),
          messageEvent: MessageEvent.error,
          context: Get.context!,
        );
        AppMessage.snackBar(errMessage);
      }
    } catch (e) {
      kLogger.e(e);
      MessageParams errMessage = (
        message: ErrorMapperUtils.errMessage(implEvent: ImplEvent.failedToAddAsset),
        messageEvent: MessageEvent.error,
        context: Get.context!,
      );
      AppMessage.snackBar(errMessage);
    } finally {
      loading.value = false;
    }
  }

  Future<void> updateAsset(int assetId) async {
    try {
      loading.value = true;
      kLogger.e(editAsset.value.borrowableCtrl.text);
      if (_validateAsset(editAsset.value)) {
        final asset = editAsset.value;
        final updateAssetResponse = await supabase
            .from('assets')
            .update({
              'name': asset.nameCtrl.text,
              'desc': asset.descCtrl.text,
              'condition': asset.conditionCtrl.text,
              'borrowable': asset.borrowable,
              'status': asset.statusCtrl.text,
              'purchase_date': asset.purchaseDateCtrl.text,
              'category_id': asset.categoryId,
            })
            .eq('id', assetId)
            .select('''
            *,
            asset_images (*),
            asset_logs(*),
            transaction(*, employees(*)),
            categories!inner(*)
          ''')
            .order('created_at', ascending: false, referencedTable: 'asset_logs')
            .single();

        kLogger.i(updateAssetResponse);

        for (var i = 0; i < editAsset.value.imagePaths.length; i++) {
          final File imageFile = File(editAsset.value.imagePaths[i]);

          String fileName = "${DateTime.now().millisecondsSinceEpoch}.png";
          String path = fileName;

          final uploadImageResponse = await supabase.storage.from('asset_images').upload(path, imageFile);
          kLogger.i(uploadImageResponse);

          final addAssetImageResponse = await supabase.from('asset_images').insert([
            {
              'asset_id': assetId,
              'path': fileName,
            }
          ]);
          kLogger.i(addAssetImageResponse);
        }

        final newestData = await supabase.from('assets').select('''
            *,
            asset_images (*),
            asset_logs(*),
            transaction(*, employees(*)),
            categories!inner(*)
          ''').eq('id', assetId).order('created_at', ascending: false, referencedTable: 'asset_logs').single();

        AssetModel data = AssetModel.fromMap(newestData);
        selectedAsset.value = data;

        _updateAssetInList(data.id, data);

        kLogger.e(selectedAsset.value!.images.length);
        Get.back(
          result: [
            true
          ],
        );
      } else {
        MessageParams errMessage = (
          message: ErrorMapperUtils.errMessage(implEvent: ImplEvent.failedToValidateAddAsset),
          messageEvent: MessageEvent.error,
          context: Get.context!,
        );
        AppMessage.snackBar(errMessage);
      }
    } catch (e) {
      kLogger.e(e);
      MessageParams errMessage = (
        message: ErrorMapperUtils.errMessage(implEvent: ImplEvent.failedToAddAsset),
        messageEvent: MessageEvent.error,
        context: Get.context!,
      );
      AppMessage.snackBar(errMessage);
    } finally {
      loading.value = false;
    }
  }

  void _updateAssetInList(int assetId, AssetModel assetRespon) {
    int index = assets.indexWhere((asset) => asset.id == assetId);

    if (index != -1) {
      assets[index] = assetRespon;
    } else {
      kLogger.w("Asset with id $assetId not found in the list.");
    }
  }

  bool _validateAsset(FormAssetModel form) {
    final asset = form;
    kLogger.e(asset.categoryId);
    if (asset.categoryId == 0) {
      return false;
    }

    if (asset.nameCtrl.text.isEmpty) {
      return false;
    }

    if (asset.descCtrl.text.isEmpty) {
      return false;
    }

    if (asset.conditionCtrl.text.isEmpty) {
      return false;
    }

    if (asset.statusCtrl.text.isEmpty) {
      return false;
    }

    if (asset.categoryCtrl.text.isEmpty) {
      return false;
    }

    if (asset.borrowableCtrl.text.isEmpty) {
      return false;
    }

    if (asset.purchaseDateCtrl.text.isEmpty) {
      return false;
    }

    return true;
  }

  Future<void> deleteAssetImageById(int assetImageId, int index) async {
    try {
      final imageRecord = await supabase.from('asset_images').select('path').eq('id', assetImageId).single();

      if (imageRecord.isNotEmpty) {
        final String imagePath = imageRecord['path'];

        await supabase.storage.from('asset_images').remove([
          imagePath
        ]);
        kLogger.i("Deleted image from storage: $imagePath");
        await supabase.from('asset_images').delete().eq('id', assetImageId);
        kLogger.i("Deleted image record from database with ID: $assetImageId");

        editAsset.update((asset) {
          asset?.images?.removeAt(index);
        });

        final updatedAssetResponse = await supabase.from('assets').select('''
            *,
            asset_images (*),
            categories!inner(*)
          ''').eq('id', editAsset.value.id!).single();

        final AssetModel updatedAsset = AssetModel.fromMap(updatedAssetResponse);

        selectedAsset.value = updatedAsset;
        _updateAssetInList(updatedAsset.id, updatedAsset);
      } else {
        kLogger.w("No image found with ID: $assetImageId");
      }
    } catch (e) {
      kLogger.e("Failed to delete asset image: $e");
      throw Exception("Failed to delete asset image: $e");
    }
  }

  Future<int> _getAssetsCount() async {
    final response = await supabase.from('assets').select().count();
    kLogger.e(response.count + 1);
    return response.count;
  }

  Future<void> setEditForm(AssetModel asset) async {
    try {
      editAsset.value = FormAssetModel(
        id: asset.id,
        assetCode: asset.assetCode,
        categoryCode: asset.category!.code,
        categoryId: asset.category!.id,
        borrowable: asset.borrowable,
        purchaseDate: asset.purchaseDate,
        imagePaths: [],
        images: asset.images,
      );
      editAsset.value.nameCtrl.text = asset.name;
      editAsset.value.descCtrl.text = asset.desc;
      editAsset.value.conditionCtrl.text = asset.condition;
      editAsset.value.statusCtrl.text = asset.status;
      editAsset.value.categoryCtrl.text = asset.category!.name;
      editAsset.value.borrowableCtrl.text = asset.borrowable ? "YES" : "NO";
      editAsset.value.purchaseDateCtrl.text = UtilDate.formatDate(asset.purchaseDate);
    } catch (e) {
      kLogger.e(e);
      MessageParams errMessage = (
        message: ErrorMapperUtils.errMessage(implEvent: ImplEvent.fetchFailed),
        messageEvent: MessageEvent.error,
        context: Get.context!,
      );
      AppMessage.snackBar(errMessage);
    } finally {}
  }

  Future<void> findCurrentBorrower({required int assetId}) async {
    try {
      final response = await supabase.from('transaction').select('*, employees(*), assets(*, asset_images(*))').eq('asset_id', assetId).order('created_at', ascending: false).limit(1).maybeSingle();

      if (response != null) {
        transaction.value = TransactionModel.fromMap(response);
      } else {}

      kLogger.e(response);
    } catch (e) {
      kLogger.e(e);
      MessageParams errMessage = (
        message: ErrorMapperUtils.errMessage(implEvent: ImplEvent.fetchFailed),
        messageEvent: MessageEvent.error,
        context: Get.context!,
      );
      AppMessage.snackBar(errMessage);
    }
  }
}
