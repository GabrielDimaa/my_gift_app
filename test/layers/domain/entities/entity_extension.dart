import 'package:desejando_app/layers/domain/entities/user_entity.dart';
import 'package:desejando_app/layers/domain/entities/wish_entity.dart';
import 'package:desejando_app/layers/domain/entities/wishlist_entity.dart';

extension WishlistEntityExtension on WishlistEntity {
  bool equals(WishlistEntity entity) {
    return entity.id == id && entity.description == description && entity.wishes.equals(wishes);
  }
}

extension WishesEntityExtension on WishEntity {
  bool equals(WishEntity entity) {
    return entity.id == id &&
        entity.description == description &&
        entity.wishlistId == wishlistId &&
        entity.finished == finished &&
        entity.expose == expose &&
        entity.createdAt == createdAt &&
        entity.priceRangeFinal == priceRangeFinal &&
        entity.priceRangeInitial == priceRangeInitial &&
        entity.note == note &&
        entity.link == link &&
        entity.image == image;
  }
}

extension WishlistsEntityExtension on List<WishlistEntity> {
  bool equals(List<WishlistEntity> entities) {
    if (entities.length != length) return false;

    for (var i = 0; i < length; i++) {
      if (!entities[0].equals(this[0])) return false;
    }

    return true;
  }
}

extension WishEntityExtension on List<WishEntity> {
  bool equals(List<WishEntity> entities) {
    if (entities.length != length) return false;

    for (var i = 0; i < length; i++) {
      if (!entities[0].equals(this[0])) return false;
    }

    return true;
  }
}

extension UserExtension on UserEntity {
  bool equals(UserEntity entity) {
    return entity.id == id &&
        entity.email == email &&
        entity.phone == phone &&
        entity.password == password &&
        entity.name == name &&
        entity.photo == photo &&
        entity.emailVerified == emailVerified;
  }
}
