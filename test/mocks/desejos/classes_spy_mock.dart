import 'package:desejando_app/layers/data/repositories/i_desejo_repository.dart';
import 'package:desejando_app/layers/infra/datasources/i_desejo_datasource.dart';
import 'package:mocktail/mocktail.dart';

class DesejoRepositorySpy extends Mock implements IDesejoRepository {}

class DesejoDataSourceSpy extends Mock implements IDesejoDataSource {}
