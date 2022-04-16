import '../../domain/entities/wish_entity.dart';

abstract class IWishRepository {
  Future<WishEntity> getById(String id);
}