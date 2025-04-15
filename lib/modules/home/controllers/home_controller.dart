import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeController extends GetxController {
  final SupabaseClient supabase = Supabase.instance.client;
  Future<int> fetchCard({required String queryCount}) async {
    try {
      int total = 0;
      switch (queryCount) {
        case "total_asset":
          total = await _fetchTotalAsset();
          break;
        case "active_transaction":
          total = await _fetchActiveTransaction();
          break;

        case "broken_asset":
          total = await _brokenAsset();
          break;

        case "total_employee":
          total = await _fetchTotalEmployee();
          break;
        default:
      }

      return total;
    } catch (e) {
      throw Exception();
    }
  }

  Future<int> _fetchTotalAsset() async {
    try {
      final response = await supabase.from('assets').select().count();
      return response.count;
    } catch (e) {
      throw Exception();
    }
  }

  Future<int> _fetchActiveTransaction() async {
    try {
      final response = await supabase.from('transaction').select().or('status.eq.BORROWED,status.eq.OVERDUE').count();

      return response.count; // Return count or 0 if null
    } catch (e) {
      throw Exception();
    }
  }

  Future<int> _brokenAsset() async {
    try {
      final response = await supabase.from('assets').select().eq('condition', 'BROKEN').count();

      return response.count; // Return count or 0 if null
    } catch (e) {
      throw Exception();
    }
  }

  Future<int> _fetchTotalEmployee() async {
    try {
      final response = await supabase.from('employees').select().count();
      return response.count;
    } catch (e) {
      throw Exception();
    }
  }
}
