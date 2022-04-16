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
}