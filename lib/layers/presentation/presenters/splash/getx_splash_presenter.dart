import 'package:get/get.dart';

import '../../../domain/entities/user_entity.dart';
import '../../../domain/usecases/abstracts/signup/i_check_email_verified.dart';
import '../../../domain/usecases/abstracts/signup/i_send_verification_email.dart';
import '../../../domain/usecases/abstracts/user/i_get_user_logged.dart';
import '../../ui/pages/dashboard/dashboard_page.dart';
import '../../ui/pages/login/login_page.dart';
import '../../ui/pages/signup/signup_confirm_email_page.dart';
import '../splash/splash_presenter.dart';

class GetxSplashPresenter extends GetxController implements SplashPresenter {
  final IGetUserLogged getUserLogged;
  final ICheckEmailVerified checkEmailVerified;
  final ISendVerificationEmail sendVerificationEmail;

  GetxSplashPresenter({
    required this.getUserLogged,
    required this.checkEmailVerified,
    required this.sendVerificationEmail,
  });

  @override
  void onInit() async {
    await load();
    super.onInit();
  }

  @override
  Future<void> load() async {
    try {
      await Future.delayed(const Duration(seconds: 2));

      final UserEntity? user = await getUserLogged.getUser();
      if (user == null) await navigateToLogin();

      final bool emailVerified = await checkEmailVerified.check(user!.id!);
      if (emailVerified) {
        await navigateToDashboard();
      } else {
        try {
          await sendVerificationEmail.send(user.id!);
        } finally {
          await navigateToConfirmEmail();
        }
      }
    } catch (e) {
      await navigateToLogin();
    }
  }

  @override
  Future<void> navigateToDashboard() async => await Get.offAll(() => const DashboardPage());

  @override
  Future<void> navigateToLogin() async => await Get.offAll(() => const LoginPage());

  @override
  Future<void> navigateToConfirmEmail() async => await Get.offAll(() => const SignupConfirmEmailPage(visibleToLogin: true));
}