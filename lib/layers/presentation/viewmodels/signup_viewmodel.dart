import 'dart:io';

import 'package:get/get_rx/src/rx_types/rx_types.dart';

import '../../domain/entities/user_entity.dart';

class SignupViewModel {
  RxnString name = RxnString();
  RxnString email = RxnString();
  RxnString password = RxnString();
  RxnString confirmPassword = RxnString();
  Rxn photo = Rxn();

  void setName(String? value) => name.value = value;

  void setEmail(String? value) => email.value = value;

  void setPassword(String? value) => password.value = value;

  void setConfirmPassword(String? value) => confirmPassword.value = value;

  void setPhoto(File? value) => photo.value = value;

  UserEntity toEntity() {
    return UserEntity(
      name: name.value!,
      email: email.value!,
      photo: photo.value!,
      emailVerified: false,
      password: password.value!,
    );
  }
}
