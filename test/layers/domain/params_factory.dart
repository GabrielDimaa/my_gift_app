import 'package:my_gift_app/layers/domain/helpers/params/friend_params.dart';
import 'package:my_gift_app/layers/domain/helpers/params/login_params.dart';
import 'package:my_gift_app/layers/domain/helpers/params/new_password_params.dart';
import 'package:faker/faker.dart';

abstract class ParamsFactory {
  static LoginParams login() => LoginParams(
        email: faker.internet.email(),
        password: faker.internet.password(),
      );

  static FriendParams friend() => FriendParams(
        friendUserId: faker.guid.guid(),
        userId: faker.guid.guid(),
      );

  static NewPasswordParams newPasswordParams() => NewPasswordParams(
        code: faker.randomGenerator.integer(9999, min: 1000).toString(),
        newPassword: faker.randomGenerator.string(20, min: 8),
      );
}
