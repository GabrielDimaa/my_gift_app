import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../../app_theme.dart';
import '../../../../../i18n/resources.dart';
import '../../../../../monostates/user_global.dart';
import '../../../../domain/entities/user_entity.dart';
import '../../components/padding/padding_default.dart';
import '../../components/sized_box_default.dart';
import '../../components/switch_custom.dart';

class ConfigDrawer extends StatefulWidget {
  const ConfigDrawer({Key? key}) : super(key: key);

  @override
  State<ConfigDrawer> createState() => _ConfigDrawerState();
}

class _ConfigDrawerState extends State<ConfigDrawer> {
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
                  CachedNetworkImage(
                    imageUrl: _user.photo ?? "",
                    imageBuilder: (_, image) => CircleAvatar(backgroundImage: image, radius: 35),
                    placeholder: (context, url) => const CircularProgressIndicator(),
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                  ),
                  const SizedBoxDefault.horizontal(),
                  Expanded(
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        _user.name,
                        style: textTheme.headline5?.copyWith(fontSize: 20),
                        overflow: TextOverflow.fade,
                        maxLines: 1,
                        softWrap: false,
                      ),
                      subtitle: Text(
                        _user.email,
                        style: textTheme.caption?.copyWith(fontWeight: FontWeight.w600),
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
                          Text("Tema", style: textTheme.bodyText1),
                          SwitchCustom(
                            activeColor: colorScheme.primary,
                            inactiveColor: colorScheme.secondary,
                            activeIcon: Icons.dark_mode,
                            inactiveIcon: Icons.light_mode,
                            active: AppTheme.theme.value == ThemeMode.dark,
                            onChanged: (value) {
                              AppTheme.theme.value = value ? ThemeMode.dark : ThemeMode.light;
                            },
                          ),
                        ],
                      ),
                    ),
                    const Divider(thickness: 1, height: 1),
                    _listTile(
                      label: R.string.editMyData,
                      onTap: () {},
                    ),
                    const Divider(thickness: 1, height: 1),
                    _listTile(
                      label: R.string.changePassword,
                      onTap: () {},
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
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    primary: Theme.of(context).colorScheme.secondary,
                    side: BorderSide(color: Theme.of(context).colorScheme.secondary, width: 2),
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
}
