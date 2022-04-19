import 'package:desejando_app/layers/domain/helpers/params/login_params.dart';
import 'package:faker/faker.dart';

abstract class ParamsFactory {
  static LoginParams login() => LoginParams(
        email: faker.internet.email(),
        password: faker.internet.password(),
      );
}
