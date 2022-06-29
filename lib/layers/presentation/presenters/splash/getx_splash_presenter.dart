import 'package:get/get.dart';

import '../../../../app_theme.dart';
import '../../../../monostates/user_global.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../domain/enums/theme_mode.dart';
import '../../../domain/helpers/errors/domain_error.dart';
import '../../../domain/usecases/abstracts/config/i_get_theme.dart';
import '../../../domain/usecases/abstracts/signup/i_check_email_verified.dart';
import '../../../domain/usecases/abstracts/signup/i_send_verification_email.dart';
import '../../../domain/usecases/abstracts/user/i_get_user_logged.dart';
import '../../ui/pages/dashboard/dashboard_page.dart';
import '../../ui/pages/login/login_page.dart';
import '../../ui/pages/signup/signup_confirm_email_page.dart';
import '../splash/splash_presenter.dart';

class GetxSplashPresenter extends GetxController implements SplashPresenter {
  final IGetUserLogged _getUserLogged;
  final ICheckEmailVerified _checkEmailVerified;
  final ISendVerificationEmail _sendVerificationEmail;
  final IGetTheme _getTheme;

  GetxSplashPresenter({
    required IGetUserLogged getUserLogged,
    required ICheckEmailVerified checkEmailVerified,
    required ISendVerificationEmail sendVerificationEmail,
    required IGetTheme getTheme,
  })  : _getUserLogged = getUserLogged,
        _checkEmailVerified = checkEmailVerified,
        _sendVerificationEmail = sendVerificationEmail,
        _getTheme = getTheme;

  @override
  Future<void> initialize([viewModel]) async {
    try {
      await Future.delayed(const Duration(seconds: 2));

      final UserEntity? user = await _getUserLogged.getUser();
      if (user == null) await navigateToLogin();

      final bool emailVerified = await _checkEmailVerified.check(user!.id!);
      if (emailVerified) {
        UserGlobal().setUser(user);
        final theme = await _getTheme.get();
        if (theme != null) AppTheme.theme.value = theme.toMaterial();

        await navigateToDashboard();
      } else {
        try {
          await _sendVerificationEmail.send(user.id!);
        } finally {
          await navigateToConfirmEmail();
        }
      }
    } on DomainError catch (e) {
      throw Exception(e.message);
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
