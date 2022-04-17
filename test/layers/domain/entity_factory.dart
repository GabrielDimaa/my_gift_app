import 'package:desejando_app/layers/domain/entities/user_entity.dart';
import 'package:desejando_app/layers/domain/entities/wish_entity.dart';
import 'package:faker/faker.dart';

abstract class EntityFactory {
  static WishEntity wish() => WishEntity(
        id: faker.guid.guid(),
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

  static UserEntity user({bool emailVerified = true}) => UserEntity(
        id: faker.guid.guid(),
        name: faker.person.name(),
        email: faker.internet.email(),
        photo: faker.internet.httpsUrl(),
        emailVerified: emailVerified,
      );
}