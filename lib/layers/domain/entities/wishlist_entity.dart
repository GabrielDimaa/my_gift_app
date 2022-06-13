import './wish_entity.dart';
import './tag_entity.dart';
import 'user_entity.dart';

class WishlistEntity {
  final String? id;
  final UserEntity user;
  String description;
  List<WishEntity> wishes;
  TagEntity tag;

  WishlistEntity({
    this.id,
    required this.user,
    required this.description,
    required this.wishes,
    required this.tag,
  });
}
