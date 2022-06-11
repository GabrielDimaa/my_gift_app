import 'package:get/get.dart';

import '../layers/presentation/ui/pages/dashboard/dashboard_page.dart';
import '../layers/presentation/ui/pages/login/login_page.dart';
import '../layers/presentation/ui/pages/signup/signup_confirm_email_page.dart';
import '../layers/presentation/ui/pages/signup/signup_page.dart';
import '../layers/presentation/ui/pages/signup/signup_password_page.dart';
import '../layers/presentation/ui/pages/signup/signup_photo_page.dart';
import '../layers/presentation/ui/pages/splash/splash_page.dart';
import '../layers/presentation/ui/pages/wish/wish_register_page.dart';
import '../layers/presentation/ui/pages/wishlist/wishlist_register_page.dart';
import '../layers/presentation/ui/pages/wishlist/wishlists_fetch_page.dart';

class Routes {
  List<GetPage> getRoutes() => [
        GetPage(name: "/splash", page: () => const SplashPage()),
        GetPage(name: "/login", page: () => const LoginPage()),
        GetPage(name: "/signup", page: () => const SignupPage()),
        GetPage(name: "/signup_password", page: () => const SignupPasswordPage()),
        GetPage(name: "/signup_photo", page: () => const SignupPhotoPage()),
        GetPage(name: "/signup_confirm_email", page: () => const SignupConfirmEmailPage()),
        GetPage(name: "/dashboard", page: () => const DashboardPage()),
        GetPage(name: "/wishlists_fetch", page: () => const WishlistsFetchPage()),
        GetPage(name: "/wishlist_register", page: () => const WishlistRegisterPage()),
        GetPage(name: "/wish_register", page: () => WishRegisterPage(viewModel: Get.arguments['viewModel'], wishlistViewModel: Get.arguments['wishlistViewModel'])),
      ];
}
