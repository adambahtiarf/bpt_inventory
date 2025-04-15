import 'asset_image_model.dart';
import 'asset_log_model.dart';
import 'category_model.dart';
import 'transaction_model.dart';

class AssetModel {
  final int id;
  final String assetCode;
  final String name;
  final String desc;
  final String condition;
  final bool borrowable;
  final String status;
  final DateTime purchaseDate;
  final DateTime createdAt;
  final DateTime? deletedAt;
  final List<AssetImageModel> images;
  final List<AssetLogModel> logs;
  final List<TransactionModel> transactions;
  final CategoryModel? category; // Relationship

  AssetModel({
    required this.id,
    required this.assetCode,
    required this.name,
    required this.desc,
    required this.condition,
    required this.borrowable,
    required this.status,
    required this.purchaseDate,
    required this.createdAt,
    this.deletedAt,
    required this.images,
    required this.logs,
    required this.transactions,
    this.category,
  });

  factory AssetModel.fromMap(Map<String, dynamic> data) {
    return AssetModel(
      id: data['id'],
      assetCode: data['asset_code'],
      name: data['name'],
      desc: data['desc'],
      condition: data['condition'],
      borrowable: data['borrowable'],
      status: data['status'],
      purchaseDate: DateTime.parse(data['purchase_date']).toLocal(),
      createdAt: DateTime.parse(data['created_at']).toLocal(),
      deletedAt: data['deleted_at'] != null ? DateTime.parse(data['deleted_at']).toLocal() : null,
      images: (data['asset_images'] as List?)?.map((image) => AssetImageModel.fromMap(image)).toList() ?? [],
      logs: (data.containsKey('asset_logs') && data['asset_logs'] is List) ? (data['asset_logs'] as List).map((log) => AssetLogModel.fromMap(log)).toList() : [],
      transactions: (data.containsKey('transaction') && data['transaction'] is List) ? (data['transaction'] as List).map((log) => TransactionModel.fromMap(log)).toList() : [],
      category: data['categories'] != null ? CategoryModel.fromMap(data['categories']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'asset_code': assetCode,
      'name': name,
      'desc': desc,
      'condition': condition,
      'borrowable': borrowable,
      'status': status,
      'purchase_date': purchaseDate.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
      'asset_images': images.map((image) => image.toMap()).toList(),
      'asset_logs': logs.map((log) => log.toMap()).toList(),
      'asset_transaction': transactions.map((transaction) => transaction.toMap()).toList(),
    };
  }
}
