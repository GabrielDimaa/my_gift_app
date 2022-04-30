import 'package:desejando_app/layers/domain/entities/wish_entity.dart';

import '../../../../i18n/resources.dart';
import '../../../domain/entities/wishlist_entity.dart';
import '../../../domain/helpers/errors/domain_error.dart';
import '../../../domain/usecases/wishlist/i_save_wishlist.dart';
import '../../repositories/i_wish_repository.dart';
import '../../repositories/i_wishlist_repository.dart';

class SaveWishlist implements ISaveWishlist {
  final IWishlistRepository wishlistRepository;
  final IWishRepository wishRepository;

  SaveWishlist({required this.wishlistRepository, required this.wishRepository});

  @override
  Future<WishlistEntity> save(WishlistEntity entity) async {
    try {
      if (entity.id == null) {
        final WishlistEntity wishlistResponse = await wishlistRepository.create(entity);
        if (wishlistResponse.id == null) throw ValidationDomainError(message: R.string.saveError);

        final List<WishEntity> wishes = [];

        for (var wish in entity.wishes) {
          wish.wishlistId = wishlistResponse.id;
          final WishEntity wishSaved = await wishRepository.create(wish);

          if (wishSaved.id != null) wishes.add(wishSaved);
        }

        wishlistResponse.wishes = wishes;

        return wishlistResponse;
      } else {
        return await wishlistRepository.update(entity);
      }
    } on DomainError {
      rethrow;
    } catch (e) {
      throw UnexpectedDomainError(R.string.saveError);
    }
  }
}
