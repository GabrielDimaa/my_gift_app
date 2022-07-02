import 'package:get/get.dart';

import '../layers/presentation/ui/pages/dashboard/dashboard_page.dart';
import '../layers/presentation/ui/pages/friend/friends_page.dart';
import '../layers/presentation/ui/pages/friend/profile_page.dart';
import '../layers/presentation/ui/pages/login/login_page.dart';
import '../layers/presentation/ui/pages/signup/signup_confirm_email_page.dart';
import '../layers/presentation/ui/pages/signup/signup_page.dart';
import '../layers/presentation/ui/pages/signup/signup_password_page.dart';
import '../layers/presentation/ui/pages/signup/signup_photo_page.dart';
import '../layers/presentation/ui/pages/splash/splash_page.dart';
import '../layers/presentation/ui/pages/user/code_reset_password_page.dart';
import '../layers/presentation/ui/pages/user/email_reset_password_page.dart';
import '../layers/presentation/ui/pages/user/user_edit_profile_page.dart';
import '../layers/presentation/ui/pages/wish/wish_details_page.dart';
import '../layers/presentation/ui/pages/wish/wish_register_page.dart';
import '../layers/presentation/ui/pages/wishlist/wishlist_details_page.dart';
import '../layers/presentation/ui/pages/wishlist/wishlist_register_page.dart';
import '../layers/presentation/ui/pages/wishlist/wishlists_fetch_page.dart';
import 'routes.dart';

class Pages {
  List<GetPage> getPages() => [
        GetPage(name: splashRoute, page: () => const SplashPage()),
        GetPage(name: loginRoute, page: () => const LoginPage()),
        GetPage(name: signupRoute, page: () => const SignupPage()),
        GetPage(name: signupPasswordRoute, page: () => const SignupPasswordPage()),
        GetPage(name: signupPhotoRoute, page: () => const SignupPhotoPage()),
        GetPage(name: signupConfirmEmailRoute, page: () => const SignupConfirmEmailPage()),
        GetPage(name: dashboardRoute, page: () => const DashboardPage()),
        GetPage(name: wishlistsFetchRoute, page: () => const WishlistsFetchPage()),
        GetPage(name: wishlistDetailsRoute, page: () => WishlistDetailsPage(viewModel: Get.arguments)),
        GetPage(name: wishlistRegisterRoute, page: () => WishlistRegisterPage(viewModel: Get.arguments)),
        GetPage(name: wishRegisterRoute, page: () => WishRegisterPage(viewModel: Get.arguments['viewModel'], wishlistViewModel: Get.arguments['wishlistViewModel'])),
        GetPage(name: wishDetailsRoute, page: () => WishDetailsPage(viewModel: Get.arguments)),
        GetPage(name: friendsRoute, page: () => const FriendsPage()),
        GetPage(name: profileRoute, page: () => ProfilePage(viewModel: Get.arguments)),
        GetPage(name: userEditProfileRoute, page: () => const UserEditProfilePage()),
        GetPage(name: emailResetPasswordRoute, page: () => EmailResetPasswordPage(logged: Get.arguments ?? false)),
      ];
}
