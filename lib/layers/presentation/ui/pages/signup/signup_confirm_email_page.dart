import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../i18n/resources.dart';
import '../../../presenters/signup/getx_signup_presenter.dart';
import '../../../presenters/signup/signup_presenter.dart';
import '../../components/app_bar/app_bar_default.dart';
import '../../components/button/small_button.dart';
import '../../components/circular_loading.dart';
import '../../components/dialogs/error_dialog.dart';
import '../../components/dialogs/loading_dialog.dart';
import '../../components/padding/padding_default.dart';
import '../../components/sized_box_default.dart';

class SignupConfirmEmailPage extends StatefulWidget {
  final bool visibleToLogin;

  const SignupConfirmEmailPage({Key? key, this.visibleToLogin = false}) : super(key: key);

  @override
  State<SignupConfirmEmailPage> createState() => _SignupConfirmEmailPageState();
}

class _SignupConfirmEmailPageState extends State<SignupConfirmEmailPage> {
  final SignupPresenter presenter = Get.find<GetxSignupPresenter>();

  ColorScheme get colorScheme => Theme.of(context).colorScheme;

  @override
  void initState() {
    presenter.startTimerResendEmail();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarDefault(title: R.string.confirmEmail),
      body: SafeArea(
        child: Padding(
          padding: const PaddingDefault(),
          child: Obx(() {
            if (presenter.loading) {
              return const CircularLoading();
            } else {
              return Column(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBoxDefault(2),
                        Text(R.string.explicationConfirmEmail, style: Theme.of(context).textTheme.titleMedium),
                        const SizedBoxDefault(2),
                        Row(
                          children: [
                            Obx(
                              () => SmallButton(
                                icon: (presenter.timerTick ?? 0) <= 0 ? Icons.forward_to_inbox : Icons.hourglass_top_outlined,
                                label: (presenter.timerTick ?? 0) <= 0 ? R.string.resendEmail : "${presenter.timerTick} ${R.string.seconds}",
                                onPressed: (presenter.timerTick ?? 0) <= 0
                                    ? () async {
                                        try {
                                          await presenter.resendVerificationEmail();
                                        } catch (e) {
                                          ErrorDialog.show(context: context, content: e.toString());
                                        }
                                      }
                                    : null,
                              ),
                            ),
                            const SizedBoxDefault.horizontal(2),
                            Obx(
                              () => Visibility(
                                visible: presenter.loadingResendEmail,
                                child: const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(strokeWidth: 3),
                                ),
                              ),
                            ),
                            Obx(
                              () => Visibility(
                                visible: !presenter.loadingResendEmail && (presenter.timerTick ?? 0) > 0 && presenter.resendEmail,
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.check,
                                      color: colorScheme.secondary,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      R.string.resent,
                                      style: TextStyle(color: colorScheme.secondary, fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBoxDefault(5),
                        Text(R.string.explicationConfirmedEmail, style: Theme.of(context).textTheme.titleMedium),
                        const SizedBoxDefault(5),
                        ElevatedButton(
                          child: Text(R.string.completeAccount),
                          onPressed: () async {
                            try {
                              await LoadingDialog.show(
                                  context: context,
                                  message: "${R.string.completingRegistration}...",
                                  onAction: () async {
                                    await presenter.completeAccount();
                                  });
                            } catch (e) {
                              ErrorDialog.show(context: context, content: e.toString());
                            }
                          },
                        ),
                        const SizedBoxDefault(),
                        Visibility(
                          visible: widget.visibleToLogin,
                          child: OutlinedButton(
                            child: Text(R.string.makeLogin),
                            onPressed: () async => presenter.navigateToLogin(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }
          }),
        ),
      ),
    );
  }
}
