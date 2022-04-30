import '../../external/helpers/errors/external_error.dart';
import '../../domain/entities/wish_entity.dart';

class WishModel {
  final String? id;
  final String wishlistId;
  final String description;
  final String? image;
  final String? link;
  final String? note;

  final double priceRangeInitial;
  final double priceRangeFinal;

  final DateTime createdAt;

  final bool expose;
  final bool finished;

  const WishModel({
    this.id,
    required this.wishlistId,
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

  WishEntity toEntity() {
    return WishEntity(
      id: id,
      wishlistId: wishlistId,
      description: description,
      image: image,
      link: link,
      note: note,
      priceRangeInitial: priceRangeInitial,
      priceRangeFinal: priceRangeFinal,
      createdAt: createdAt,
      expose: expose,
      finished: finished,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'wishlist_id': wishlistId,
      'description': description,
      'image': image,
      'link': link,
      'note': note,
      'price_range_initial': priceRangeInitial,
      'price_range_final': priceRangeFinal,
      'created_at': createdAt.toIso8601String(),
      'expose': expose,
      'finished': finished,
    };
  }

  factory WishModel.fromEntity(WishEntity entity) {
    if (entity.wishlistId == null) throw InvalidDataExternalError();

    return WishModel(
      id: entity.id,
      wishlistId: entity.wishlistId!,
      description: entity.description,
      image: entity.image,
      link: entity.link,
      note: entity.note,
      priceRangeInitial: entity.priceRangeInitial,
      priceRangeFinal: entity.priceRangeFinal,
      createdAt: entity.createdAt,
      expose: entity.expose,
      finished: entity.finished,
    );
  }

  factory WishModel.fromJson(Map<String, dynamic> json) {
    if (json['wishlist_id'] == null) throw InvalidDataExternalError();

    return WishModel(
      id: json['id'],
      wishlistId: json['wishlist_id'],
      description: json['description'],
      image: json['image'],
      link: json['link'],
      note: json['note'],
      priceRangeInitial: json['price_range_initial'],
      priceRangeFinal: json['price_range_final'],
      createdAt: DateTime.parse(json['created_at']),
      expose: json['expose'],
      finished: json['finished'],
    );
  }

  static bool validateJson(Map<String, dynamic>? json) {
    return json != null &&
        json.keys.toSet().containsAll([
          'id',
          'wishlist_id',
          'description',
          'price_range_initial',
          'price_range_final',
          'created_at',
          'expose',
          'finished',
        ]);
  }
}
