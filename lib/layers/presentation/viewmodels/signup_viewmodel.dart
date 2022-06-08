import 'dart:io';

import 'package:get/get_rx/src/rx_types/rx_types.dart';

import '../../domain/entities/user_entity.dart';

class SignupViewModel {
  final RxnString _name = RxnString();
  final RxnString _email = RxnString();
  final RxnString _password = RxnString();
  final RxnString _confirmPassword = RxnString();
  final Rxn<File?> _photo = Rxn<File?>();

  String? get name => _name.value;
  String? get email => _email.value;
  String? get password => _password.value;
  String? get confirmPassword => _confirmPassword.value;
  File? get photo => _photo.value;

  void setName(String? value) => _name.value = value;
  void setEmail(String? value) => _email.value = value;
  void setPassword(String? value) => _password.value = value;
  void setConfirmPassword(String? value) => _confirmPassword.value = value;
  void setPhoto(File? value) => _photo.value = value;

  UserEntity toEntity() {
    return UserEntity(
      name: name!,
      email: email!,
      photo: photo?.path,
      emailVerified: false,
      password: password!,
    );
  }
}
