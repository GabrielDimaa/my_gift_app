import '../../infra/models/desejo_model.dart';

abstract class IDesejoDataSource {
  Future<DesejoModel> getById(String id);
}