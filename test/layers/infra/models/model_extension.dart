import 'package:desejando_app/layers/infra/models/user_model.dart';
import 'package:desejando_app/layers/infra/models/wish_model.dart';
import 'package:desejando_app/layers/infra/models/wishlist_model.dart';

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
    return model.id == id &&
        model.email == email &&
        model.phone == phone &&
        model.password == password &&
        model.name == name &&
        model.photo == photo &&
        model.emailVerified == emailVerified;
  }
}
