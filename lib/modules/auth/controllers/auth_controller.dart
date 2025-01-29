import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../components/message/message.dart';
import '../../../core/constant/app_enums.dart';
import '../../../core/utils/error_mapper_utils.dart';
import '../../../data/models/user_model.dart';
import '../../../data/type/message_params.dart';
import '../../../main.dart';

class AuthController extends GetxController {
  final SupabaseClient supabase = Supabase.instance.client;

  Rx<UserModel?> user = Rx<UserModel?>(null);

  RxBool obsecurePasswordInput = true.obs;

  RxBool initLoading = false.obs;

  RxBool loading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _authStateListener();
  }

  void _authStateListener() {
    supabase.auth.onAuthStateChange.listen((data) {
      final event = data.event;
      final currentRoute = Get.currentRoute;

      switch (event) {
        case AuthChangeEvent.initialSession:
          initLoading.value = true;
          final currentUser = supabase.auth.currentUser;
          if (currentUser != null) {
            user.value = UserModel(
              id: currentUser.id,
              email: currentUser.email ?? '',
            );
            if (currentRoute == '/') {
              Get.offAllNamed('/home');
            }
          } else {
            initLoading.value = false;
          }
          break;

        case AuthChangeEvent.signedIn:
          final currentUser = supabase.auth.currentUser;
          if (currentUser != null) {
            user.value = UserModel(
              id: currentUser.id,
              email: currentUser.email ?? '',
            );
            if (currentRoute == '/') {
              Get.offAllNamed('/home');
            }
          }
          break;

        case AuthChangeEvent.signedOut:
          user.value = null;
          if (currentRoute != '/') {
            Get.offAllNamed('/');
          }

          break;

        default:
          break;
      }
    });
  }

  Future<void> login({required String email, required String password}) async {
    try {
      loading.value = true;
      await supabase.auth.signInWithPassword(email: email, password: password);
    } catch (e) {
      kLogger.e(e);
      MessageParams errMessage = (
        message: ErrorMapperUtils.errMessage(implEvent: ImplEvent.loginFailed),
        messageEvent: MessageEvent.error,
        context: Get.context!,
      );
      AppMessage.snackBar(errMessage);
    } finally {
      loading.value = false;
    }
  }

  Future<void> logout() async {
    await supabase.auth.signOut();
  }
}
