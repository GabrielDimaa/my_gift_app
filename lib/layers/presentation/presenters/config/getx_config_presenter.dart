import '../../../domain/helpers/errors/domain_error.dart';
import '../../../domain/usecases/abstracts/logout/i_logout.dart';
import 'config_presenter.dart';

class GetxConfigPresenter implements ConfigPresenter {
  final ILogout _logout;

  GetxConfigPresenter({required ILogout logout}) : _logout = logout;

  @override
  Future<void> logout() async {
    try {
      await _logout.logout();
    } on DomainError catch (e) {
      throw Exception(e.message);
    }
  }
}