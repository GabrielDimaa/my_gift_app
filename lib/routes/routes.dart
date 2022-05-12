import 'package:get/get.dart';

import '../layers/presentation/ui/pages/login/login_page.dart';
import '../layers/presentation/ui/pages/signup/signup_page.dart';

class Routes {
  List<GetPage> getRoutes() => [
    GetPage(name: "/login", page: () => const LoginPage()),
    GetPage(name: "/signup", page: () => const SignupPage()),
  ];
}