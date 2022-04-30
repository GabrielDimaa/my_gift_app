import '../../domain/entities/user_entity.dart';

class UserModel {
  final String? id;
  String name;
  String email;
  String phone;
  String? photo;
  bool emailVerified;
  String? password;

  UserModel({
    this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.photo,
    required this.emailVerified,
    this.password,
  });

  UserEntity toEntity() {
    return UserEntity(
      id: id,
      name: name,
      email: email,
      phone: phone,
      photo: photo,
      emailVerified: emailVerified,
      password: password,
    );
  }

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      name: entity.name,
      email: entity.email,
      phone: entity.phone,
      photo: entity.photo,
      emailVerified: entity.emailVerified,
      password: entity.password,
    );
  }
}
