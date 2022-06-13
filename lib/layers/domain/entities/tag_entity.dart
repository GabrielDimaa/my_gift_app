import 'user_entity.dart';

class TagEntity {
  final String? id;
  final UserEntity user;
  String name;
  String color;

  TagEntity({
    this.id,
    required this.user,
    required this.name,
    required this.color,
  });
}