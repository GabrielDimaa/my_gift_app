import 'package:equatable/equatable.dart';

import '../../domain/entities/user_entity.dart';

class UserModel extends Equatable {
  final String? id;
  final String name;
  final String email;
  final String phone;
  final String? photo;
  final bool emailVerified;

  const UserModel({
    this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.photo,
    required this.emailVerified,
  });

  UserEntity toEntity() {
    return UserEntity(
      id: id,
      name: name,
      email: email,
      phone: phone,
      photo: photo,
      emailVerified: emailVerified,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'photo': photo,
      'email_verified': emailVerified,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      photo: json['photo'],
      emailVerified: json['email_verified'],
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
    );
  }

  @override
  List<Object?> get props => [id, name, email, phone, photo, emailVerified];
}
