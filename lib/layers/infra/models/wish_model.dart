import '../../domain/entities/wish_entity.dart';
import '../helpers/errors/infra_error.dart';

class WishModel {
  final String? id;
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

  WishModel({
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
    if (wishlistId == null) throw InvalidDataInfraError();

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

  WishModel clone({String? id}) {
    return WishModel(
      id: id ?? this.id,
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

  factory WishModel.fromEntity(WishEntity entity) {
    if (entity.id != null && entity.wishlistId == null) throw InvalidDataInfraError();

    return WishModel(
      id: entity.id,
      wishlistId: entity.wishlistId,
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
    if (json['wishlist_id'] == null) throw InvalidDataInfraError();

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
