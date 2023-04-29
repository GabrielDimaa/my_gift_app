import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/instance_manager.dart';

import '../../../../../i18n/resources.dart';
import '../../../presenters/user/getx_reset_password_presenter.dart';
import '../../../presenters/user/reset_password_presenter.dart';
import '../../components/app_bar/app_bar_default.dart';
import '../../components/button/small_button.dart';
import '../../components/dialogs/error_dialog.dart';
import '../../components/padding/padding_default.dart';
import '../../components/sized_box_default.dart';

class CodeResetPasswordPage extends StatefulWidget {
  const CodeResetPasswordPage({Key? key}) : super(key: key);

  @override
  State<CodeResetPasswordPage> createState() => _CodeResetPasswordPageState();
}

class _CodeResetPasswordPageState extends State<CodeResetPasswordPage> {
  final ResetPasswordPresenter presenter = Get.find<GetxResetPasswordPresenter>();

  @override
  void initState() {
    presenter.sendCode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarDefault(title: R.string.resetPassword),
      body: SafeArea(
        child: Padding(
          padding: const PaddingDefault(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBoxDefault(2),
                      Text(R.string.explicationCodeResetPassword, style: Theme.of(context).textTheme.titleMedium),
                      const SizedBoxDefault(2),
                      Row(
                        children: [
                          Obx(
                            () => SmallButton(
                              icon: (presenter.timerTick ?? 0) <= 0 ? Icons.forward_to_inbox_rounded : Icons.hourglass_top_outlined,
                              label: (presenter.timerTick ?? 0) <= 0 ? R.string.resendCode : "${presenter.timerTick} ${R.string.seconds}",
                              onPressed: (presenter.timerTick ?? 0) <= 0
                                  ? () async {
                                      try {
                                        await presenter.resendCode();
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
                                    color: Theme.of(context).colorScheme.secondary,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    R.string.resent,
                                    style: TextStyle(color: Theme.of(context).colorScheme.secondary, fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBoxDefault(4),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
