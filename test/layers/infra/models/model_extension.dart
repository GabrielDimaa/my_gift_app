import 'package:my_gift_app/layers/infra/models/friends_model.dart';
import 'package:my_gift_app/layers/infra/models/tag_model.dart';
import 'package:my_gift_app/layers/infra/models/user_model.dart';
import 'package:my_gift_app/layers/infra/models/wish_model.dart';
import 'package:my_gift_app/layers/infra/models/wishlist_model.dart';

extension WishlistModelExtension on WishlistModel {
  bool equals(WishlistModel model) {
    return model.id == id && model.description == description && model.wishes.equals(wishes);
  }
}

extension WishModelExtension on WishModel {
  bool equals(WishModel model) {
    return model.id == id &&
        model.description == description &&
        model.wishlistId == wishlistId &&
        model.finished == finished &&
        model.expose == expose &&
        model.createdAt == createdAt &&
        model.priceRangeFinal == priceRangeFinal &&
        model.priceRangeInitial == priceRangeInitial &&
        model.note == note &&
        model.link == link &&
        model.image == image;
  }
}

extension WishlistsModelExtension on List<WishlistModel> {
  bool equals(List<WishlistModel> models) {
    if (models.length != length) return false;

    for (var i = 0; i < length; i++) {
      if (!models[0].equals(this[0])) return false;
    }

    return true;
  }
}

extension WishesModelExtension on List<WishModel> {
  bool equals(List<WishModel> models) {
    if (models.length != length) return false;

    for (var i = 0; i < length; i++) {
      if (!models[0].equals(this[0])) return false;
    }

    return true;
  }
}

extension UserModelExtension on UserModel {
  bool equals(UserModel model) {
    return model.id == id && model.email == email && model.password == password && model.name == name && model.photo == photo && model.emailVerified == emailVerified;
  }
}

extension UsersModelExtension on List<UserModel> {
  bool equals(List<UserModel> models) {
    if (models.length != length) return false;

    for (var i = 0; i < length; i++) {
      if (!models[i].equals(this[i])) return false;
    }

    return true;
  }
}

extension TagModelExtension on TagModel {
  bool equals(TagModel model) {
    return model.id == id && model.name == name && model.color == color;
  }
}

extension TagsModelExtension on List<TagModel> {
  bool equals(List<TagModel> models) {
    if (models.length != length) return false;

    for (var i = 0; i < length; i++) {
      if (!models[i].equals(this[i])) return false;
    }

    return true;
  }
}

extension FriendsModelExtension on FriendsModel {
  bool equals(FriendsModel model) {
    return friends.equals(model.friends);
  }
}
