import '../../../entities/wish_entity.dart';

abstract class ISaveWish {
  Future<WishEntity> save(WishEntity entity);
}