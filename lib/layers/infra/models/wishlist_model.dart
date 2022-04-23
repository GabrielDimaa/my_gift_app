import 'package:equatable/equatable.dart';

import '../../domain/entities/wishlist_entity.dart';
import './wish_model.dart';

class WishlistModel extends Equatable {
  final String id;
  final String description;
  final List<WishModel> wishes;

  const WishlistModel({
    required this.id,
    required this.description,
    required this.wishes,
  });

  WishlistEntity toEntity() {
    return WishlistEntity(
      id: id,
      description: description,
      wishes: wishes.map((e) => e.toEntity()).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'wishes': wishes.map((e) => e.toJson()).toList(),
    };
  }

  factory WishlistModel.fromJson(Map<String, dynamic> json) {
    return WishlistModel(
      id: json['id'],
      description: json['description'],
      wishes: json['wishes']?.map<WishModel>((e) => WishModel.fromJson(e)).toList() ?? [],
    );
  }

  static bool validateJson(Map<String, dynamic>? json) {
    return json != null &&
        json.keys.toSet().containsAll([
          'id',
          'description',
          'wishes',
        ]);
  }

  @override
  List<Object?> get props => [id, description, wishes];
}
