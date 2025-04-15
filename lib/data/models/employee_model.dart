class EmployeeModel {
  final int id;
  final String name;
  final String email;
  final bool active;
  final String position;
  final DateTime createdAt;
  final String department;
  final String phoneNumber;

  EmployeeModel({
    required this.id,
    required this.name,
    required this.email,
    required this.active,
    required this.position,
    required this.createdAt,
    required this.department,
    required this.phoneNumber,
  });

  factory EmployeeModel.fromMap(Map<String, dynamic> json) {
    return EmployeeModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      active: json['active'],
      position: json['position'],
      createdAt: DateTime.parse(json['created_at']),
      department: json['departement'],
      phoneNumber: json['phone_number'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'active': active,
      'position': position,
      'created_at': createdAt.toIso8601String(),
      'departement': department,
      'phone_number': phoneNumber,
    };
  }
}
