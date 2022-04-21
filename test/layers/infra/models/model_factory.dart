import 'package:desejando_app/layers/infra/models/user_model.dart';
import 'package:desejando_app/layers/infra/models/wish_model.dart';
import 'package:faker/faker.dart';

abstract class ModelFactory {
  static WishModel wish() => WishModel(
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

  static UserModel user({bool emailVerified = true}) => UserModel(
        id: faker.guid.guid(),
        name: faker.person.name(),
        email: faker.internet.email(),
        phone: faker.phoneNumber.random.fromPattern(["(##)#####-####"]),
        photo: faker.internet.httpsUrl(),
        emailVerified: emailVerified,
        password: faker.internet.password(),
      );

  static UserModel userWithoutId({bool emailVerified = true, String? password = "12345678"}) => UserModel(
        name: faker.person.name(),
        email: faker.internet.email(),
        phone: faker.phoneNumber.random.fromPattern(["(##)#####-####"]),
        photo: faker.internet.httpsUrl(),
        emailVerified: emailVerified,
        password: password,
      );
}
