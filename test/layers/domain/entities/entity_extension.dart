import 'package:desejando_app/layers/domain/entities/friends_entity.dart';
import 'package:desejando_app/layers/domain/entities/tag_entity.dart';
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
      if (!entities[i].equals(this[i])) return false;
    }

    return true;
  }
}

extension WishEntityExtension on List<WishEntity> {
  bool equals(List<WishEntity> entities) {
    if (entities.length != length) return false;

    for (var i = 0; i < length; i++) {
      if (!entities[i].equals(this[i])) return false;
    }

    return true;
  }
}

extension UserExtension on UserEntity {
  bool equals(UserEntity entity) {
    return entity.id == id && entity.email == email && entity.password == password && entity.name == name && entity.photo == photo && entity.emailVerified == emailVerified;
  }
}

extension UsersListsExtension on List<UserEntity> {
  bool equals(List<UserEntity> entities) {
    if (entities.length != length) return false;

    for (var i = 0; i < length; i++) {
      if (!entities[i].equals(this[i])) return false;
    }

    return true;
  }
}

extension TagExtension on TagEntity {
  bool equals(TagEntity entity) {
    return entity.id == id && entity.name == name && entity.color == color;
  }
}

extension TaglistsExtension on List<TagEntity> {
  bool equals(List<TagEntity> entities) {
    if (entities.length != length) return false;

    for (var i = 0; i < length; i++) {
      if (!entities[i].equals(this[i])) return false;
    }

    return true;
  }
}

extension FriendExtension on FriendsEntity {
  bool equals(FriendsEntity entity) {
    return friends.equals(entity.friends);
  }
}
