import '../../infra/models/wish_model.dart';

abstract class IWishDataSource {
  Future<WishModel> getById(String id);
  Future<List<WishModel>> getByWishlist(String wishlistId);
  Future<WishModel> create(WishModel model);
  Future<WishModel> update(WishModel model);
  Future<void> delete(String id);
}