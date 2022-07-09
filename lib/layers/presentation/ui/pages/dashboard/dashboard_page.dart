import 'package:flutter/material.dart';

import '../../../../../i18n/resources.dart';
import '../../../../../monostates/user_global.dart';
import '../../../../../routes/routes.dart';
import '../../../../domain/entities/user_entity.dart';
import '../../components/app_bar/app_bar_default.dart';
import '../../components/app_bar/photo_profile_action.dart';
import '../../components/bottom_sheet/exit_app_bottom_sheet.dart';
import '../../components/padding/padding_default.dart';
import '../../components/sized_box_default.dart';
import '../config/config_drawer.dart';
import 'components/card_button.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late UserEntity _user;

  @override
  void initState() {
    _user = UserGlobal().getUser()!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => await ExitAppBottomSheet.show(context),
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBarDefault(
          title: R.string.dashboard,
          visibleBackButton: false,
          actions: [PhotoProfileAction(scaffoldKey: _scaffoldKey)],
        ),
        endDrawer: const ConfigDrawer(),
        body: SafeArea(
          child: Padding(
            padding: const PaddingDefault(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBoxDefault(2),
                Text("${R.string.hello}, ${_user.name.split(" ").first} 👋", style: Theme.of(context).textTheme.headline5?.copyWith(fontSize: 26)),
                const SizedBoxDefault(2),
                Expanded(
                  child: ListView(
                    children: [
                      CardButton(
                        text: R.string.wishes,
                        icon: Icons.card_giftcard_outlined,
                        color: const Color(0xFF3BC189),
                        onTap: () async => await _navigateToWishlist(),
                      ),
                      const SizedBoxDefault(),
                      CardButton(
                        text: R.string.friends,
                        icon: Icons.people_alt_outlined,
                        color: const Color(0xFF8830F8),
                        onTap: () async => await _navigateToFriends(),
                      ),
                      const SizedBoxDefault(),
                      CardButton(
                        text: R.string.tags,
                        icon: Icons.label_important_outline,
                        color: const Color(0xFFCE4163),
                        onTap: () async => await _navigateToTags(),
                      ),
                      const SizedBoxDefault(),
                      CardButton(
                        text: R.string.config,
                        icon: Icons.settings_outlined,
                        color: const Color(0xFF535353),
                        onTap: () => _scaffoldKey.currentState?.openEndDrawer(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _navigateToWishlist() async {
    await Navigator.pushNamed(context, wishlistsFetchRoute);
  }

  Future<void> _navigateToFriends() async {
    await Navigator.pushNamed(context, friendsRoute);
  }

  Future<void> _navigateToTags() async {
    await Navigator.pushNamed(context, tagsFetchRoute);
  }
}
