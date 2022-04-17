import 'package:equatable/equatable.dart';

import '../../domain/entities/user_entity.dart';

class UserModel extends Equatable {
  final String id;
  final String name;
  final String email;
  final String photo;
  final bool emailVerified;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.photo,
    required this.emailVerified,
  });

  UserEntity toEntity() {
    return UserEntity(
      id: id,
      name: name,
      email: email,
      photo: photo,
      emailVerified: emailVerified,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'photo': photo,
      'email_verified': emailVerified,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      photo: json['photo'],
      emailVerified: json['email_verified'],
    );
  }

  @override
  List<Object?> get props => [id, name, email, photo, emailVerified];
}
