import '../../../domain/enums/theme_mode.dart';
import '../../../domain/helpers/errors/domain_error.dart';
import '../../../domain/usecases/abstracts/config/i_get_theme.dart';
import '../../../domain/usecases/abstracts/config/i_save_theme.dart';
import '../../../domain/usecases/abstracts/logout/i_logout.dart';
import 'config_presenter.dart';

class GetxConfigPresenter implements ConfigPresenter {
  final ILogout _logout;
  final ISaveTheme _saveTheme;

  GetxConfigPresenter({
    required ILogout logout,
    required IGetTheme getTheme,
    required ISaveTheme saveTheme,
  })  : _logout = logout,
        _saveTheme = saveTheme;

  @override
  Future<void> logout() async {
    try {
      await _logout.logout();
    } on DomainError catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Future<void> saveTheme(ThemeMode themeMode) async {
    await _saveTheme.save(themeMode);
  }
}
