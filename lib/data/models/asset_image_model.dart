class AssetImageModel {
  final int id;
  final DateTime createdAt;
  final int assetId;
  final String path;

  AssetImageModel({
    required this.id,
    required this.createdAt,
    required this.assetId,
    required this.path,
  });

  factory AssetImageModel.fromMap(Map<String, dynamic> data) {
    return AssetImageModel(
      id: data['id'],
      createdAt: DateTime.parse(data['created_at']),
      assetId: data['asset_id'],
      path: data['path'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'created_at': createdAt.toIso8601String(),
      'asset_id': assetId,
      'path': path,
    };
  }
}
