import 'package:get/get_rx/src/rx_types/rx_types.dart';

import '../../domain/entities/user_entity.dart';

class UserViewModel {
  late final RxString _id;
  late final RxString _name;
  late final RxString _email;
  late final RxnString _photo;

  String get id => _id.value;
  String get shortName => _name.value.split(" ").first;
  String get name => _name.value;
  String get email => _email.value;
  String? get photo => _photo.value;

  UserViewModel({
    required String id,
    required String name,
    required String email,
    String? photo,
  }) {
    _id = RxString(id);
    _name = RxString(name);
    _email = RxString(email);
    _photo = RxnString(photo);
  }

  factory UserViewModel.fromEntity(UserEntity entity) {
    return UserViewModel(
      id: entity.id!,
      name: entity.name,
      email: entity.email,
      photo: entity.photo,
    );
  }
}
