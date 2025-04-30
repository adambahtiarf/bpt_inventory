import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../components/message/message.dart';
import '../../../core/constant/app_enums.dart';
import '../../../core/utils/date_util.dart';
import '../../../data/models/create_transaction_model.dart';
import '../../../data/models/employee_model.dart';
import '../../../data/type/message_params.dart';
import '../../../main.dart';

class BorrowController extends GetxController {
  final SupabaseClient supabase = Supabase.instance.client;
  final RxList<EmployeeModel> employees = <EmployeeModel>[].obs;
  Rx<FormTransactionModel> createTransaction = FormTransactionModel(
    employeeId: 0,
    expectedReturnDate: DateTime.now(),
    purpose: "",
  ).obs;

  Future<void> fetchEmployees() async {
    try {
      final response = await supabase.from('employees').select('*').order('created_at', ascending: false);

      if (response.isNotEmpty) {
        employees.assignAll(
          (response as List).map((data) => EmployeeModel.fromMap(data)).toList(),
        );
      }
    } catch (e) {
      kLogger.e(e);
      MessageParams errMessage = (
        message: "Failed to fetch employees",
        messageEvent: MessageEvent.error,
        context: Get.context!,
      );
      AppMessage.snackBar(errMessage);
    }
  }

  Future<void> addTransaction({required int assetId}) async {
    try {
      if (_validateTransactionForm(createTransaction.value)) {
        final DateTime now = DateTime.now();

        await supabase.from('transaction').insert([
          {
            'asset_id': assetId,
            'employee_id': createTransaction.value.employeeId,
            'borrow_date': UtilDate.formatDate(now),
            'expected_return_date': createTransaction.value.expectedReturnDateTxtCtrl.text,
            'status': "BORROWED",
            'purpose': createTransaction.value.purposeTxtCtrl.text,
            'note': createTransaction.value.notesCtrl.text,
          }
        ]);

        await supabase.from('assets').update({
          'status': "CURRENTLY BORROWED",
        }).eq('id', assetId);

        Get.back(
          result: [
            true
          ],
        );
      } else {
        MessageParams errMessage = (
          message: "Please fill all the required fields",
          messageEvent: MessageEvent.error,
          context: Get.context!,
        );
        AppMessage.snackBar(errMessage);
      }
    } catch (e) {
      kLogger.e(e);
      MessageParams errMessage = (
        message: "Failed to create transaction",
        messageEvent: MessageEvent.error,
        context: Get.context!,
      );
      AppMessage.snackBar(errMessage);
    }
  }

  bool _validateTransactionForm(FormTransactionModel form) {
    final transaction = form;
    if (transaction.employeeId == 0) {
      return false;
    }

    if (transaction.expectedReturnDateTxtCtrl.text.isEmpty) {
      return false;
    }

    if (transaction.purposeTxtCtrl.text.isEmpty) {
      return false;
    }

    return true;
  }
}
