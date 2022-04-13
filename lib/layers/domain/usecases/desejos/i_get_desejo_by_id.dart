import '../../entities/desejo_entity.dart';

abstract class IGetDesejoById {
  Future<DesejoEntity> get(String id);
}