import 'package:desejando_app/layers/domain/entities/wish_entity.dart';
import 'package:equatable/equatable.dart';

class WishlistEntity extends Equatable {
  final String? id;
  final String description;
  final List<WishEntity> wishes;

  const WishlistEntity({
    this.id,
    required this.description,
    required this.wishes,
  });

  @override
  List<Object?> get props => [id, description, wishes];
}
