import '../../../entities/wish_entity.dart';

abstract class IGetWishById {
  Future<WishEntity> get(String id);
}