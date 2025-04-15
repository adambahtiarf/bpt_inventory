class AssetLogModel {
  final int id;
  final DateTime createdAt;
  final int assetId;
  final String log;

  AssetLogModel({
    required this.id,
    required this.createdAt,
    required this.assetId,
    required this.log,
  });

  factory AssetLogModel.fromMap(Map<String, dynamic> data) {
    return AssetLogModel(
      id: data['id'],
      createdAt: DateTime.parse(data['created_at']).toLocal(),
      assetId: data['asset_id'],
      log: data['log'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'created_at': createdAt.toIso8601String(),
      'asset_id': assetId,
      'log': log,
    };
  }
}
