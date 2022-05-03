import './wish_entity.dart';
import './tag_entity.dart';

class WishlistEntity {
  final String? id;
  String description;
  List<WishEntity> wishes;
  TagEntity tag;

  WishlistEntity({
    this.id,
    required this.description,
    required this.wishes,
    required this.tag,
  });
}
