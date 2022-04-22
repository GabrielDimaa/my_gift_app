import '../../infra/models/wish_model.dart';

abstract class IWishDataSource {
  Future<WishModel> getById(String id);
  Future<List<WishModel>> getAll(String userId);
}