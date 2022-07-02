import 'package:get/get_rx/src/rx_types/rx_types.dart';

import '../../domain/entities/user_entity.dart';

class UserViewModel {
  late final RxString _id;
  late final RxString _name;
  late final RxString _email;
  late final RxnString _photo;
  late final RxBool _emailVerified;

  String get id => _id.value;
  String get shortName => _name.value.split(" ").first;
  String get name => _name.value;
  String get email => _email.value;
  String? get photo => _photo.value;
  bool get emailVerified => _emailVerified.value;

  void setName(String? value) => _name.value = value ?? "";

  void setEmail(String? value) => _email.value = value ?? "";

  void setPhoto(String? value) => _photo.value = value;

  UserViewModel({
    required String id,
    required String name,
    required String email,
    String? photo,
    bool emailVerified = false,
  }) {
    _id = RxString(id);
    _name = RxString(name);
    _email = RxString(email);
    _photo = RxnString(photo);
    _emailVerified = RxBool(emailVerified);
  }

  UserEntity toEntity() {
    return UserEntity(
      id: id,
      name: name.trim(),
      email: email.trim(),
      photo: photo,
      emailVerified: emailVerified,
    );
  }

  factory UserViewModel.fromEntity(UserEntity entity) {
    return UserViewModel(
      id: entity.id!,
      name: entity.name,
      email: entity.email,
      photo: entity.photo,
      emailVerified: entity.emailVerified,
    );
  }
}
