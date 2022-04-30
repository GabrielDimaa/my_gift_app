import '../../entities/wish_entity.dart';

abstract class IGetWishes {
  Future<List<WishEntity>> get({required String id, required String wishlistId});
}