import '../../domain/entities/tag_entity.dart';
import 'user_model.dart';

class TagModel {
  final String? id;
  final UserModel user;
  final String name;
  final String color;

  const TagModel({
    this.id,
    required this.user,
    required this.name,
    required this.color,
  });

  TagEntity toEntity() {
    return TagEntity(
      id: id,
      user: user.toEntity(),
      name: name,
      color: color,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'color': color,
      'user_id': user.id,
    };
  }

  TagModel clone({String? id}) {
    return TagModel(
      id: id ?? this.id,
      user: user.clone(),
      name: name,
      color: color,
    );
  }

  factory TagModel.fromEntity(TagEntity entity) {
    return TagModel(
      id: entity.id,
      user: UserModel.fromEntity(entity.user),
      name: entity.name,
      color: entity.color,
    );
  }

  factory TagModel.fromJson(Map<String, dynamic> json) {
    return TagModel(
      id: json['id'],
      name: json['name'],
      color: json['color'],
      user: UserModel.fromJson(json['user']),
    );
  }

  static bool validateJson(Map<String, dynamic>? json) {
    return json != null &&
        json.keys.toSet().containsAll([
          'id',
          'name',
          'color',
          'user_id',
        ]);
  }
}
