import '../../domain/entities/user_entity.dart';

class UserModel {
  final String? id;
  String name;
  String email;
  String? photo;
  bool emailVerified;
  String? password;

  UserModel({
    this.id,
    required this.name,
    required this.email,
    this.photo,
    required this.emailVerified,
    this.password,
  });

  UserEntity toEntity() {
    return UserEntity(
      id: id,
      name: name,
      email: email,
      photo: photo,
      emailVerified: emailVerified,
      password: password,
    );
  }

  UserModel clone(String? id) {
    return UserModel(
      id: id ?? this.id,
      name: name,
      email: email,
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
      photo: entity.photo,
      emailVerified: entity.emailVerified,
      password: entity.password,
    );
  }
}
