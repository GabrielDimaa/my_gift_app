import './wish_entity.dart';

class WishlistEntity {
  final String? id;
  String description;
  List<WishEntity> wishes;

  WishlistEntity({
    this.id,
    required this.description,
    required this.wishes,
  });
}
