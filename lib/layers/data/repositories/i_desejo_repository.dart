import '../../domain/entities/desejo_entity.dart';

abstract class IDesejoRepository {
  Future<DesejoEntity> getById(String id);
}