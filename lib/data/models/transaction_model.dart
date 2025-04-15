import 'asset_model.dart';
import 'employee_model.dart';

class TransactionModel {
  final int id;
  final int assetId;
  final DateTime borrowDate;
  final DateTime expectedReturnDate;
  final DateTime? actualReturnDate;
  final String status;
  final String purpose;
  final String note;
  final DateTime createdAt;
  final int employeeId;
  final EmployeeModel? employee;
  final AssetModel? asset;

  TransactionModel({
    required this.id,
    required this.assetId,
    required this.borrowDate,
    required this.expectedReturnDate,
    this.actualReturnDate,
    required this.status,
    required this.purpose,
    required this.note,
    required this.createdAt,
    required this.employeeId,
    this.employee,
    this.asset,
  });

  factory TransactionModel.fromMap(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'],
      assetId: json['asset_id'],
      borrowDate: DateTime.parse(json['borrow_date']),
      expectedReturnDate: DateTime.parse(json['expected_return_date']),
      actualReturnDate: json['actual_return_date'] != null ? DateTime.tryParse(json['actual_return_date']) : null,
      status: json['status'],
      purpose: json['purpose'],
      note: json['note'],
      createdAt: DateTime.parse(json['created_at']),
      employeeId: json['employee_id'],
      employee: json['employees'] != null ? EmployeeModel.fromMap(json['employees']) : null,
      asset: json['assets'] != null ? AssetModel.fromMap(json['assets']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'asset_id': assetId,
      'borrow_date': borrowDate.toIso8601String(),
      'expected_return_date': expectedReturnDate.toIso8601String(),
      'actual_return_date': actualReturnDate?.toIso8601String(),
      'status': status,
      'purpose': purpose,
      'note': note,
      'created_at': createdAt.toIso8601String(),
      'employee_id': employeeId,
      'employees': employee?.toJson(),
    };
  }
}
