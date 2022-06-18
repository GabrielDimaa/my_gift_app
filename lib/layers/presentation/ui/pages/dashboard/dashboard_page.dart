import 'package:flutter/material.dart';

import '../../../../../i18n/resources.dart';
import '../../../../../routes/routes.dart';
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
  @override
  Widget build(BuildContext context) {
    final double widthTotal = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBarDefault(
        title: R.string.dashboard,
        actions: [],
      ),
      body: SafeArea(
        child: Padding(
          padding: const PaddingDefault(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBoxDefault(5),
              Expanded(
                child: GridView(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: (widthTotal - 36) ~/ 130.0,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  children: [
                    CardButton(
                      text: R.string.wishes,
                      icon: Icons.card_giftcard_outlined,
                      color: const Color(0xFF3BC189),
                      onTap: () async => await _navigateToWishlist(),
                    ),
                    CardButton(
                      text: R.string.friends,
                      icon: Icons.people_alt_outlined,
                      color: const Color(0xFF8830F8),
                      onTap: () {},
                    ),
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
