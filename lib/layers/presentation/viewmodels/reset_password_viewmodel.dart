import 'package:get/get_rx/src/rx_types/rx_types.dart';

class ResetPasswordViewModel {
  final RxnString _email = RxnString();
  final RxnString _code = RxnString();
  final RxnString _newPassword = RxnString();

  String? get email => _email.value;
  String? get code => _code.value;
  String? get newPassword => _newPassword.value;

  void setEmail(String? value) => _email.value = value;
  void setCode(String? value) => _code.value = value;
  void setNewPassword(String? value) => _newPassword.value = value;
}
