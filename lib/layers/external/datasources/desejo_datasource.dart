import 'package:desejando_app/layers/infra/models/desejo_model.dart';

import '../../infra/datasources/i_desejo_datasource.dart';

class DesejoDataSource implements IDesejoDataSource {
  @override
  Future<DesejoModel> getById(String id) {
    throw UnimplementedError();
  }
}