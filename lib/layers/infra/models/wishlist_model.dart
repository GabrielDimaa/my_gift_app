import '../../domain/entities/wishlist_entity.dart';
import './tag_model.dart';
import './wish_model.dart';

class WishlistModel {
  final String? id;
  final String description;
  final List<WishModel> wishes;
  final TagModel tag;

  const WishlistModel({
    this.id,
    required this.description,
    required this.wishes,
    required this.tag,
  });

  WishlistEntity toEntity() {
    return WishlistEntity(
      id: id,
      description: description,
      wishes: wishes.map((e) => e.toEntity()).toList(),
      tag: tag.toEntity(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'tag_id': tag.id,
    };
  }

  WishlistModel clone({String? id}) {
    return WishlistModel(
      id: id ?? this.id,
      description: description,
      wishes: wishes,
      tag: tag,
    );
  }

  factory WishlistModel.fromEntity(WishlistEntity entity) {
    return WishlistModel(
      id: entity.id,
      description: entity.description,
      wishes: entity.wishes.map((e) => WishModel.fromEntity(e)).toList(),
      tag: TagModel.fromEntity(entity.tag),
    );
  }

  factory WishlistModel.fromJson(Map<String, dynamic> json) {
    return WishlistModel(
      id: json['id'],
      description: json['description'],
      wishes: json['wishes']?.map<WishModel>((e) => WishModel.fromJson(e)).toList() ?? [],
      tag: TagModel.fromJson(json['tag']),
    );
  }

  static bool validateJson(Map<String, dynamic>? json) {
    return json != null && json.keys.toSet().containsAll(['id', 'description', 'tag_id']);
  }
}
