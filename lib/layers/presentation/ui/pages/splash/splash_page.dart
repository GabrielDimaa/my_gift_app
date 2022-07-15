import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rive/rive.dart';

import '../../../../../app_theme.dart';
import '../../../presenters/splash/getx_splash_presenter.dart';
import '../../../presenters/splash/splash_presenter.dart';
import '../../components/dialogs/error_dialog.dart';
import '../../components/padding/padding_default.dart';
import '../../components/sized_box_default.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final SplashPresenter presenter = Get.find<GetxSplashPresenter>();

  StateMachineController? stateMachine;

  void _onRiveInit(Artboard artboard) {
    stateMachine = StateMachineController.fromArtboard(artboard, 'State Machine');
    artboard.addController(stateMachine!);
    stateMachine!.isActiveChanged.addListener(() async {
      presenter.initialize().catchError((e) async {
        await ErrorDialog.show(context: context, content: e.toString());
        await presenter.navigateToLogin();
      });
    });
  }

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
              AspectRatio(
                aspectRatio: 3,
                child: RiveAnimation.asset(
                  "assets/animations/my_gif_logo.riv",
                  onInit: _onRiveInit,
                ),
              ),
              const SizedBoxDefault(3),
            ],
          ),
        ),
      ),
    );
  }
}
