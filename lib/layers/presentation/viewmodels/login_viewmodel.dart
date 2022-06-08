import 'package:get/get_rx/src/rx_types/rx_types.dart';

import '../../domain/helpers/params/login_params.dart';

class LoginViewModel {
  final RxnString _email = RxnString();
  final RxnString _password = RxnString();

  String? get email => _email.value;
  String? get password => _password.value;

  void setEmail(String? value) => _email.value = value;
  void setPassword(String? value) => _password.value = value;

  LoginParams toParams() => LoginParams(email: email!.trim(), password: password!);
}
