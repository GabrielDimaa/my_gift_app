import 'package:get/get.dart';

import '../layers/presentation/ui/pages/login/login_page.dart';

class Routes {
  List<GetPage> getRoutes() => [
    GetPage(name: "/login", page: () => const LoginPage())
  ];
}