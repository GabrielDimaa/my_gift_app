import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../app_theme.dart';
import '../../../../../i18n/resources.dart';
import '../../../../../monostates/user_global.dart';
import '../../../../../routes/routes.dart';
import '../../../../domain/entities/user_entity.dart';
import '../../../../domain/enums/theme_mode.dart' as enum_theme;
import '../../../presenters/config/config_presenter.dart';
import '../../../presenters/config/getx_config_presenter.dart';
import '../../components/bottom_sheet/confirm_bottom_sheet.dart';
import '../../components/dialogs/error_dialog.dart';
import '../../components/dialogs/loading_dialog.dart';
import '../../components/padding/padding_default.dart';
import '../../components/photo_profile.dart';
import '../../components/sized_box_default.dart';
import '../../components/switch_custom.dart';

class ConfigDrawer extends StatefulWidget {
  const ConfigDrawer({Key? key}) : super(key: key);

  @override
  State<ConfigDrawer> createState() => _ConfigDrawerState();
}

class _ConfigDrawerState extends State<ConfigDrawer> {
  final ConfigPresenter presenter = Get.find<GetxConfigPresenter>();

  UserEntity get _user => UserGlobal().getUser()!;

  TextTheme get textTheme => Theme.of(context).textTheme;

  ColorScheme get colorScheme => Theme.of(context).colorScheme;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Padding(
          padding: const PaddingDefault(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBoxDefault(),
              IconButton(
                padding: EdgeInsets.zero,
                iconSize: 38,
                splashRadius: 32,
                icon: const Icon(Icons.keyboard_backspace),
                onPressed: () => Navigator.pop(context),
                tooltip: R.string.back,
              ),
              const SizedBoxDefault(2),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  PhotoProfile(user: _user),
                  const SizedBoxDefault.horizontal(),
                  Expanded(
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        _user.name,
                        style: textTheme.headlineSmall?.copyWith(fontSize: 20),
                        overflow: TextOverflow.fade,
                        maxLines: 1,
                        softWrap: false,
                      ),
                      subtitle: Text(
                        _user.email,
                        style: textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
                        overflow: TextOverflow.fade,
                        maxLines: 1,
                        softWrap: false,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBoxDefault(3),
              Expanded(
                child: ListView(
                  children: [
                    const Divider(thickness: 1, height: 1),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(R.string.theme, style: textTheme.bodyLarge),
                          SwitchCustom(
                            activeColor: colorScheme.primary,
                            inactiveColor: colorScheme.secondary,
                            activeIcon: Icons.dark_mode,
                            inactiveIcon: Icons.light_mode,
                            active: AppTheme.theme.value == ThemeMode.dark,
                            onChanged: (value) {
                              final ThemeMode theme = value ? ThemeMode.dark : ThemeMode.light;
                              AppTheme.theme.value = theme;
                              presenter.saveTheme(enum_theme.ThemeModeParse.fromMaterial(theme));
                            },
                          ),
                        ],
                      ),
                    ),
                    const Divider(thickness: 1, height: 1),
                    _listTile(
                      label: R.string.editMyData,
                      onTap: () async => await Navigator.pushNamed(context, userEditProfileRoute),
                    ),
                    const Divider(thickness: 1, height: 1),
                    _listTile(
                      label: R.string.changePassword,
                      onTap: () async => await Navigator.pushNamed(context, emailResetPasswordRoute, arguments: true),
                    ),
                    const Divider(thickness: 1, height: 1),
                  ],
                ),
              ),
              const SizedBoxDefault(),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  label: Text(R.string.logout),
                  icon: const Icon(Icons.logout_outlined),
                  onPressed: () async => await _logout(),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.secondary, side: BorderSide(color: Theme.of(context).colorScheme.secondary, width: 2),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _listTile({required String label, required VoidCallback onTap}) {
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
      title: Text(label),
      trailing: const Icon(Icons.chevron_right, size: 32),
    );
  }

  Future<void> _logout() async {
    try {
      final bool confirmed = await ConfirmBottomSheet.show(
            context: context,
            title: R.string.logout,
            message: R.string.confirmLogout,
          );

      if (confirmed) {
        if (!mounted) return;
        await LoadingDialog.show(
            context: context,
            message: "${R.string.goingOut}...",
            onAction: () async {
              await presenter.logout();
              await Future.delayed(const Duration(milliseconds: 1500));
            });

        if (!mounted) return;
        await Navigator.pushNamedAndRemoveUntil(context, loginRoute, (Route route) => false);
      }
    } catch (e) {
      ErrorDialog.show(context: context, content: e.toString());
    }
  }
}
