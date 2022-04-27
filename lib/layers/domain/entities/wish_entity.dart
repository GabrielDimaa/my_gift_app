import 'package:equatable/equatable.dart';

class WishEntity extends Equatable {
  final String? id;
  final String? wishlistId;
  final String description;
  final String? image;
  final String? link;
  final String? note;

  final double priceRangeInitial;
  final double priceRangeFinal;

  final DateTime createdAt;

  final bool expose;
  final bool finished;

  const WishEntity({
    this.id,
    this.wishlistId,
    required this.description,
    this.image,
    this.link,
    this.note,
    required this.priceRangeInitial,
    required this.priceRangeFinal,
    required this.createdAt,
    required this.expose,
    required this.finished,
  });

  @override
  List<Object?> get props => [id, wishlistId, description, image, link, note, priceRangeInitial, priceRangeFinal, createdAt, expose, finished];
}
