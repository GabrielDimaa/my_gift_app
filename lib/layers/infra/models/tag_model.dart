

import '../../domain/entities/tag_entity.dart';

class TagModel {
  final String? id;
  final String name;
  final String color;

  const TagModel({
    this.id,
    required this.name,
    required this.color,
  });

  TagEntity toEntity() {
    return TagEntity(
      id: id,
      name: name,
      color: color,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'color': color,
    };
  }

  factory TagModel.fromEntity(TagEntity entity) {
    return TagModel(
      id: entity.id,
      name: entity.name,
      color: entity.color,
    );
  }

  factory TagModel.fromJson(Map<String, dynamic> json) {
    return TagModel(
      id: json['id'],
      name: json['name'],
      color: json['color'],
    );
  }

  static bool validateJson(Map<String, dynamic>? json) {
    return json != null &&
        json.keys.toSet().containsAll([
          'id',
          'name',
          'color',
        ]);
  }
}
