import 'package:get/get.dart';

import '../layers/presentation/ui/pages/login/login_page.dart';
import '../layers/presentation/ui/pages/signup/signup_confirm_email_page.dart';
import '../layers/presentation/ui/pages/signup/signup_page.dart';
import '../layers/presentation/ui/pages/signup/signup_password_page.dart';
import '../layers/presentation/ui/pages/signup/signup_photo_page.dart';

class Routes {
  List<GetPage> getRoutes() => [
    GetPage(name: "/login", page: () => const LoginPage()),
    GetPage(name: "/signup", page: () => const SignupPage()),
    GetPage(name: "/signup_password", page: () => const SignupPasswordPage()),
    GetPage(name: "/signup_photo", page: () => const SignupPhotoPage()),
    GetPage(name: "/signup_confirm_email", page: () => const SignupConfirmEmailPage()),
  ];
}