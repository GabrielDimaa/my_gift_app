import '../../../../../exceptions/errors.dart';
import '../../../../../i18n/resources.dart';
import '../../../repositories/i_config_repository.dart';
import '../../abstracts/config/i_delete_configs.dart';

class DeleteConfigs implements IDeleteConfigs {
  final IConfigRepository configRepository;

  DeleteConfigs({required this.configRepository});

  @override
  Future<void> delete() async {
    try {
      return await configRepository.deleteConfigs();
    } on UnexpectedError {
      throw StandardError(R.string.deleteError);
    }
  }
}
