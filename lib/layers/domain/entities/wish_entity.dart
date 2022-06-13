import 'user_entity.dart';

class WishEntity {
  final String? id;
  final UserEntity user;
  String? wishlistId;
  String description;
  String? image;
  String? link;
  String? note;

  double priceRangeInitial;
  double priceRangeFinal;

  DateTime createdAt;

  bool expose;
  bool finished;

  WishEntity({
    this.id,
    required this.user,
    this.wishlistId,
    required this.description,
    this.image,
    this.link,
    this.note,
    required this.priceRangeInitial,
    required this.priceRangeFinal,
    required this.createdAt,
    this.expose = true,
    this.finished = false,
  });
}
