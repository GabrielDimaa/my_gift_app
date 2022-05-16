import 'package:desejando_app/layers/domain/entities/user_entity.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class SignupViewModel {
  RxnString name = RxnString();
  RxnString email = RxnString();
  RxnString password = RxnString();
  RxnString confirmPassword = RxnString();
  RxnString phone = RxnString();

  void setName(String? value) => name.value = value;

  void setEmail(String? value) => email.value = value;

  void setPassword(String? value) => password.value = value;

  void setConfirmPassword(String? value) => confirmPassword.value = value;

  void setPhone(String? value) => phone.value = value;

  UserEntity toEntity() {
    return UserEntity(
      name: name.value!,
      email: email.value!,
      phone: phone.value!,
      emailVerified: false,
      password: password.value!,
    );
  }
}
