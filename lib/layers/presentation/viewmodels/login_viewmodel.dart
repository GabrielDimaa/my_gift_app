import 'package:get/get_rx/src/rx_types/rx_types.dart';

class LoginViewModel {
  RxnString email = RxnString();
  RxnString password = RxnString();

  void setEmail(String? value) => email.value = value;
  void setPassword(String? value) => password.value = value;
}