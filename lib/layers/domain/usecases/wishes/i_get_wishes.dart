import '../../entities/wish_entity.dart';

abstract class IGetWishes {
  Future<List<WishEntity>> get(String userId);
}