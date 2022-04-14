import 'package:desejando_app/layers/domain/helpers/domain_error.dart';
import 'package:desejando_app/layers/external/helpers/external_error.dart';

import '../../data/repositories/i_desejo_repository.dart';
import '../../domain/entities/desejo_entity.dart';
import '../datasources/i_desejo_datasource.dart';
import '../models/desejo_model.dart';

class DesejoRepository implements IDesejoRepository {
  final IDesejoDataSource desejoDataSource;

  DesejoRepository({required this.desejoDataSource});

  @override
  Future<DesejoEntity> getById(String id) async {
    try {
      final DesejoModel desejoModel = await desejoDataSource.getById(id);
      return desejoModel.toEntity();
    } on ConnectionExternalError catch (e) {
      throw e.toDomainError();
    } catch (e) {
      throw UnexpectedExternalError().toDomainError();
    }
  }
}