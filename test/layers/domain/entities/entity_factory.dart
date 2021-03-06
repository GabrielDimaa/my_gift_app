import 'package:my_gift_app/layers/domain/entities/friends_entity.dart';
import 'package:my_gift_app/layers/domain/entities/tag_entity.dart';
import 'package:my_gift_app/layers/domain/entities/user_entity.dart';
import 'package:my_gift_app/layers/domain/entities/wish_entity.dart';
import 'package:my_gift_app/layers/domain/entities/wishlist_entity.dart';
import 'package:faker/faker.dart';

abstract class EntityFactory {
  static WishEntity wish({String? id, bool withId = true, bool withWishlistId = true}) => WishEntity(
        id: withId ? id ?? faker.guid.guid() : null,
        user: user(),
        wishlistId: withWishlistId ? faker.guid.guid() : null,
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

  static List<WishEntity> wishes({String? id, int length = 4}) => List.generate(length, (_) => wish(id: id));

  static WishlistEntity wishlist({String? id, bool withId = true}) => WishlistEntity(
        id: withId ? id ?? faker.guid.guid() : null,
        user: user(),
        description: faker.lorem.sentence(),
        wishes: wishes(),
        tag: tag(),
      );

  static List<WishlistEntity> wishlists({int length = 4}) => List.generate(length, (_) => wishlist());

  static UserEntity user({bool emailVerified = true, bool withId = true}) => UserEntity(
        id: withId ? faker.guid.guid() : null,
        name: faker.person.name(),
        email: faker.internet.email(),
        photo: faker.internet.httpsUrl(),
        emailVerified: emailVerified,
        password: faker.internet.password(),
      );

  static List<UserEntity> users({int length = 4}) => List.generate(length, (_) => user());

  static TagEntity tag({bool withId = true}) => TagEntity(
        id: withId ? faker.guid.guid() : null,
        user: user(),
        name: faker.lorem.word(),
        color: "#00000",
      );

  static List<TagEntity> tags({int length = 4}) => List.generate(length, (_) => tag());

  static FriendsEntity friends() => FriendsEntity(friends: users());
}
