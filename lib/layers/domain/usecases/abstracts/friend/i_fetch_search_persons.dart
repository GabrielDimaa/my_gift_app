import '../../../entities/user_entity.dart';

abstract class IFetchSearchPersons {
  Future<List<UserEntity>> search(String name);
}