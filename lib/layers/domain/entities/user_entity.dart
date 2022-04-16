import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String name;
  final String email;
  final String photo;
  final bool emailVerified;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.photo,
    required this.emailVerified,
  });

  @override
  List<Object?> get props => [id, name, email, photo, emailVerified];
}
