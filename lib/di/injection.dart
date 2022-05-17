import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../layers/domain/usecases/implements/login/login_email.dart';
import '../layers/domain/usecases/implements/signup/signup_email.dart';
import '../layers/infra/datasources/firebase_user_account_datasource.dart';
import '../layers/infra/repositories/user_account_repository.dart';
import '../layers/presentation/presenters/login/getx_login_presenter.dart';
import '../layers/presentation/presenters/signup/getx_signup_presenter.dart';

class Injection {
  static final Injection _instance = Injection._();

  Injection._();

  factory Injection() {
    return _instance;
  }

  void setup() {
    //Firebase
    Get.lazyPut(() => FirebaseAuth.instance, fenix: true);
    //endregion

    //region DataSource
    Get.lazyPut(() => FirebaseUserAccountDataSource(firebaseAuth: Get.find<FirebaseAuth>()), fenix: true);
    //endregion

    //region Repository
    Get.lazyPut(() => UserAccountRepository(userAccountDataSource: Get.find<FirebaseUserAccountDataSource>()), fenix: true);
    //endregion

    //region UseCases
    Get.lazyPut(() => LoginEmail(userAccountRepository: Get.find<UserAccountRepository>()), fenix: true);
    Get.lazyPut(() => SignUpEmail(userAccountRepository: Get.find<UserAccountRepository>()), fenix: true);
    //endregion

    //region Presenters
    Get.lazyPut(() => GetxLoginPresenter(loginWithEmail: Get.find<LoginEmail>()), fenix: true);
    Get.lazyPut(() => GetxSignupPresenter(signUpEmail: Get.find<SignUpEmail>()), fenix: true);
    //endregion
  }
}