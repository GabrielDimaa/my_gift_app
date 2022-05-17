import '../../../entities/tag_entity.dart';
import '../../../entities/wishlist_entity.dart';

abstract class IGetWishlistsByTag {
  Future<List<WishlistEntity>> get(TagEntity tag);
}