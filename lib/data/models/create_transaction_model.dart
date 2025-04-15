import 'package:flutter/material.dart';

class FormTransactionModel {
  int employeeId;
  DateTime expectedReturnDate;
  String purpose;
  String? notes;
  TextEditingController employeeTxtCtrl;
  TextEditingController expectedReturnDateTxtCtrl;
  TextEditingController purposeTxtCtrl;
  TextEditingController notesCtrl;

  FormTransactionModel({
    required this.employeeId,
    required this.expectedReturnDate,
    required this.purpose,
    this.notes,
  })  : employeeTxtCtrl = TextEditingController(),
        expectedReturnDateTxtCtrl = TextEditingController(),
        purposeTxtCtrl = TextEditingController(),
        notesCtrl = TextEditingController();

  void dispose() {
    employeeTxtCtrl.dispose();
    expectedReturnDateTxtCtrl.dispose();
    purposeTxtCtrl.dispose();
    notesCtrl.dispose();
  }
}
