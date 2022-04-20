import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String? id;
  final String name;
  final String email;
  final String phone;
  final String? photo;
  final bool emailVerified;
  final String? password;

  const UserEntity({
    this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.photo,
    required this.emailVerified,
    this.password,
  });

  @override
  List<Object?> get props => [id, name, email, phone, photo, emailVerified, password];
}
