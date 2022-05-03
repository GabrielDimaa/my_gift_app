import 'package:desejando_app/layers/infra/models/tag_model.dart';
import 'package:desejando_app/layers/infra/models/user_model.dart';
import 'package:desejando_app/layers/infra/models/wish_model.dart';
import 'package:desejando_app/layers/infra/models/wishlist_model.dart';
import 'package:faker/faker.dart';

abstract class ModelFactory {
  static WishModel wish({String? id, String? wishlistId, bool withId = true}) => WishModel(
        id: withId ? id ?? faker.guid.guid() : null,
        wishlistId: wishlistId ?? faker.guid.guid(),
        description: faker.lorem.sentence(),
        image: faker.internet.httpsUrl(),
        link: faker.internet.httpsUrl(),
        note: faker.lorem.sentence(),
        priceRangeInitial: 40,
        priceRangeFinal: 60,
        createdAt: DateTime(2022),
        expose: faker.randomGenerator.boolean(),
        finished: faker.randomGenerator.boolean(),
      );

  static List<WishModel> wishes({String? wishlistId, int length = 4}) => List.generate(length, (_) => wish(wishlistId: wishlistId));

  static WishlistModel wishlist({String? id, bool withId = true}) => WishlistModel(
        id: withId ? id ?? faker.guid.guid() : null,
        description: faker.lorem.sentence(),
        wishes: wishes(wishlistId: id),
        tag: tag(),
      );

  static List<WishlistModel> wishlists({int length = 4}) => List.generate(length, (_) => wishlist());

  static UserModel user({bool emailVerified = true, bool withId = true, String? password = "12345678"}) => UserModel(
        id: withId ? faker.guid.guid() : null,
        name: faker.person.name(),
        email: faker.internet.email(),
        phone: faker.phoneNumber.random.fromPattern(["(##)#####-####"]),
        photo: faker.internet.httpsUrl(),
        emailVerified: emailVerified,
        password: password,
      );

  static TagModel tag({bool withId = true}) => TagModel(
        id: withId ? faker.guid.guid() : null,
        name: faker.lorem.word(),
        color: "#00000",
      );

  static List<TagModel> tags({int length = 4}) => List.generate(length, (_) => tag());
}
