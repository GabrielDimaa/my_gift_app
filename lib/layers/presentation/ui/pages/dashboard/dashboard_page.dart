import 'package:flutter/material.dart';

import '../../../../../i18n/resources.dart';
import '../../../../../monostates/user_global.dart';
import '../../../../../routes/routes.dart';
import '../../../../domain/entities/user_entity.dart';
import '../../components/app_bar/app_bar_default.dart';
import '../../components/padding/padding_default.dart';
import '../../components/sized_box_default.dart';
import 'components/card_button.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late UserEntity _user;

  @override
  void initState() {
    _user = UserGlobal().getUser()!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarDefault(
        title: R.string.dashboard,
        actions: [
          Visibility(
            visible: _user.photo != null,
            replacement: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.secondary,
              child: Text(
                _user.name.characters.first,
                style: const TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
            child: CircleAvatar(backgroundImage: NetworkImage(_user.photo ?? "")),
          ),
        ],
      ),
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
                      onTap: () {},
                    ),
                    const SizedBoxDefault(),
                    CardButton(
                      text: R.string.config,
                      icon: Icons.settings_outlined,
                      color: const Color(0xFF535353),
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _navigateToWishlist() async {
    await Navigator.pushNamed(context, wishlistsFetchRoute);
  }
}
