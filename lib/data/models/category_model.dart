class CategoryModel {
  final int id;
  final String code;
  final String name;
  final DateTime createdAt;

  CategoryModel({
    required this.id,
    required this.code,
    required this.name,
    required this.createdAt,
  });

  factory CategoryModel.fromMap(Map<String, dynamic> data) {
    return CategoryModel(
      id: data['id'],
      code: data['code'],
      name: data['name'],
      createdAt: DateTime.parse(data['created_at']).toLocal(),
    );
  }
}
