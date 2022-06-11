import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../../app_theme.dart';
import '../../../presenters/splash/getx_splash_presenter.dart';
import '../../../presenters/splash/splash_presenter.dart';
import '../../components/padding/padding_default.dart';
import '../../components/sized_box_default.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final SplashPresenter presenter = Get.find<GetxSplashPresenter>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const AppTheme().dark,
      body: SafeArea(
        child: Padding(
          padding: const PaddingDefault(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              SvgPicture.asset(
                "assets/images/my_gift_logo.svg",
                width: 55,
                height: 55,
                color: Colors.white,
              ),
              const SizedBoxDefault(3),
              LinearProgressIndicator(backgroundColor: const AppTheme().dark),
            ],
          ),
        ),
      ),
    );
  }
}
