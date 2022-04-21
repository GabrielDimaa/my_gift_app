import 'package:equatable/equatable.dart';

import '../../domain/entities/user_entity.dart';

class UserModel extends Equatable {
  final String? id;
  final String name;
  final String email;
  final String phone;
  final String? photo;
  final bool emailVerified;
  final String? password;

  const UserModel({
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

  @override
  List<Object?> get props => [id, name, email, phone, photo, emailVerified, password];
}
