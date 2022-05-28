import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../i18n/resources.dart';
import '../../../presenters/signup/getx_signup_presenter.dart';
import '../../components/app_bar/app_bar_default.dart';
import '../../components/button/small_button.dart';
import '../../components/circular_loading.dart';
import '../../components/dialogs/error_dialog.dart';
import '../../components/padding/padding_default.dart';
import '../../components/sized_box_default.dart';

class SignupConfirmEmailPage extends StatefulWidget {
  const SignupConfirmEmailPage({Key? key}) : super(key: key);

  @override
  _SignupConfirmEmailPageState createState() => _SignupConfirmEmailPageState();
}

class _SignupConfirmEmailPageState extends State<SignupConfirmEmailPage> {
  final GetxSignupPresenter presenter = Get.find<GetxSignupPresenter>();

  @override
  void initState() {
    super.initState();
    presenter.startTimerResendEmail();
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBarDefault(title: R.string.confirmEmail),
      body: SafeArea(
        child: Padding(
          padding: const PaddingDefault(),
          child: Obx(
            () {
              if (presenter.loading) {
                return const CircularLoading();
              } else {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBoxDefault(2),
                          Text(R.string.explicationConfirmEmail, style: Theme.of(context).textTheme.subtitle1),
                          const SizedBoxDefault(2),
                          Row(
                            children: [
                              Obx(
                                    () => SmallButton(
                                  icon: (presenter.timerTick.value ?? 0) <= 0 ? Icons.edit_outlined : null,
                                  label: (presenter.timerTick.value ?? 0) <= 0 ? R.string.resendEmail : "${presenter.timerTick.value} seg",
                                  onPressed: (presenter.timerTick.value ?? 0) <= 0
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
                                  visible: presenter.loadingResendEmail.value,
                                  child: const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(strokeWidth: 3),
                                  ),
                                ),
                              ),
                              Obx(
                                    () => Visibility(
                                  visible: !presenter.loadingResendEmail.value && (presenter.timerTick.value ?? 0) > 0 && presenter.resendEmail.value,
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.check,
                                        color: colorScheme.secondary,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        "Reenviado",
                                        style: TextStyle(color: colorScheme.secondary, fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBoxDefault(5),
                          Text(R.string.explicationConfirmedEmail, style: Theme.of(context).textTheme.subtitle1),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      child: Text(R.string.completeAccount),
                      onPressed: () async {
                        try {
                          await presenter.signup();
                        } catch (e) {
                          ErrorDialog.show(context: context, content: e.toString());
                        }
                      },
                    ),
                  ],
                );
              }
            }
          ),
        ),
      ),
    );
  }
}
