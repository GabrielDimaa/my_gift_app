import 'package:desejando_app/layers/domain/usecases/login/i_login_email.dart';
import 'package:get/get.dart';

import './login_presenter.dart';
import '../../mixins/loading_manager.dart';

class GetxLoginPresenter extends GetxController with LoadingManager implements LoginPresenter {
  final ILoginEmail loginWithEmail;

  GetxLoginPresenter({required this.loginWithEmail});

  @override
  Future<void> login() async {
    try {
      setLoading(true);
    } finally {
      setLoading(false);
    }
  }

  @override
  Future<void> navigateToSignUp() async {
    // TODO: implement navigateToSignUp
    throw UnimplementedError();
  }
}