import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../layers/domain/repositories/i_user_account_repository.dart';
import '../layers/domain/usecases/login/i_login_email.dart';
import '../layers/domain/usecases/login/login_email.dart';
import '../layers/infra/datasources/firebase_user_account_datasource.dart';
import '../layers/infra/datasources/i_user_account_datasource.dart';
import '../layers/infra/repositories/user_account_repository.dart';
import '../layers/presentation/presenters/login/getx_login_presenter.dart';

class Injection {
  static final Injection _instance = Injection._();

  Injection._();

  factory Injection() {
    return _instance;
  }

  void setup() {
    //Firebase
    Get.lazyPut(() => FirebaseAuth.instance);
    //endregion

    //region DataSource
    Get.lazyPut(() => FirebaseUserAccountDataSource(firebaseAuth: Get.find<FirebaseAuth>()));
    //endregion

    //region Repository
    Get.lazyPut(() => UserAccountRepository(userAccountDataSource: Get.find<FirebaseUserAccountDataSource>()));
    //endregion

    //region UseCases
    Get.lazyPut(() => LoginEmail(userAccountRepository: Get.find<UserAccountRepository>()));
    //endregion

    //region Presenters
    Get.lazyPut(() => GetxLoginPresenter(loginWithEmail: Get.find<LoginEmail>()));
    //endregion
  }
}