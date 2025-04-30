import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../components/message/message.dart';
import '../../../core/constant/app_enums.dart';
import '../../../core/utils/date_util.dart';
import '../../../data/models/transaction_model.dart';
import '../../../data/type/message_params.dart';
import '../../../main.dart';

class TransactionController extends GetxController {
  final SupabaseClient supabase = Supabase.instance.client;
  final ScrollController scrollController = ScrollController();
  RxList<TransactionModel> transactions = <TransactionModel>[].obs;
  final RxBool loading = false.obs;
  final int limit = 20;
  int offset = 0;
  bool hasMore = true;
  // Timer? _debounce;

  @override
  void onInit() {
    fetchTransactions();
    super.onInit();
  }

  void resetData() {
    // used for searching
    transactions.clear();
    offset = 0;
    hasMore = true;
  }

  Future<void> fetchTransactions({String query = ''}) async {
    if (!hasMore) return;

    try {
      loading.value = true;
      final response = await supabase.from('transaction').select('''
            *,
            assets (*,  asset_images (*)),
            employees (*)
          ''').order('created_at', ascending: false).range(offset, offset + limit - 1);

      kLogger.e(response);
      if (response.isNotEmpty) {
        transactions.addAll(
          (response as List).map((data) => TransactionModel.fromMap(data)).toList(),
        );

        offset += limit;
        hasMore = response.length == limit;
      } else {
        hasMore = false;
      }
    } catch (e) {
      kLogger.e(e);
      MessageParams errMessage = (
        message: "Fetch transaction failed",
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
      await fetchTransactions(query: query);
    }
  }

  Future<void> returnAsset({required int transactionId, required int assetId, required String status}) async {
    try {
      kLogger.e(assetId);
      kLogger.e(status);

      await supabase.from('transaction').update({
        'status': "RETURNED",
        'actual_return_date': UtilDate.formatDate(DateTime.now()),
      }).eq('id', transactionId);

      await supabase.from('assets').update({
        'condition': status,
        'status': "AVAILABLE"
      }).eq('id', assetId);

      Get.back(
        result: [
          true
        ],
      );
    } catch (e) {
      MessageParams errMessage = (
        message: "Return failed",
        messageEvent: MessageEvent.error,
        context: Get.context!,
      );
      AppMessage.snackBar(errMessage);
    }
  }
}
