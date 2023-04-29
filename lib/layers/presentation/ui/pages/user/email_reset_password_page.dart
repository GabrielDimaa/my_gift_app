import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/instance_manager.dart';

import '../../../../../i18n/resources.dart';
import '../../../presenters/user/getx_reset_password_presenter.dart';
import '../../../presenters/user/reset_password_presenter.dart';
import '../../components/app_bar/app_bar_default.dart';
import '../../components/bottom_sheet/bottom_sheet_default.dart';
import '../../components/circular_loading.dart';
import '../../components/dialogs/error_dialog.dart';
import '../../components/dialogs/loading_dialog.dart';
import '../../components/form/text_field_default.dart';
import '../../components/form/validators/input_validators.dart';
import '../../components/padding/padding_default.dart';
import '../../components/sized_box_default.dart';

class EmailResetPasswordPage extends StatefulWidget {
  final bool logged;

  const EmailResetPasswordPage({Key? key, this.logged = false}) : super(key: key);

  @override
  State<EmailResetPasswordPage> createState() => _EmailResetPasswordPageState();
}

class _EmailResetPasswordPageState extends State<EmailResetPasswordPage> {
  final ResetPasswordPresenter presenter = Get.find<GetxResetPasswordPresenter>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    presenter.setLogged(widget.logged);
    presenter.initialize().whenComplete(() => _emailController.text = presenter.viewModel.email ?? "");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarDefault(title: R.string.resetPassword),
      body: SafeArea(
        child: Padding(
          padding: const PaddingDefault(),
          child: Obx(() {
            if (presenter.loading) {
              return const CircularLoading();
            } else {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBoxDefault(2),
                          Text(R.string.explicationEmailResetPassword, style: Theme.of(context).textTheme.titleMedium),
                          const SizedBoxDefault(2),
                          Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                TextFieldDefault(
                                  label: R.string.email,
                                  hint: R.string.emailHint,
                                  controller: _emailController,
                                  textInputAction: TextInputAction.done,
                                  keyboardType: TextInputType.emailAddress,
                                  onSaved: presenter.viewModel.setEmail,
                                  validator: InputEmailValidator().validate,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.forward_to_inbox_rounded),
                    label: Text(R.string.send),
                    onPressed: () async => await _send(),
                  ),
                ],
              );
            }
          }),
        ),
      ),
    );
  }

  Future<void> _send() async {
    try {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();

        await LoadingDialog.show(context: context, message: "${R.string.sending}...", onAction: () async => await presenter.sendCode());

        if (!mounted) return;
        final double width = MediaQuery.of(context).size.width;

        await BottomSheetDefault.show(
          context: context,
          title: R.string.sent,
          isScrollControlled: true,
          enableDrag: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SvgPicture.asset("assets/images/concluded.svg", width: width / 2),
              const SizedBoxDefault(2),
              Text(R.string.explicationSendResetPassword),
              const SizedBoxDefault(3),
              OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: Text(R.string.back),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      ErrorDialog.show(context: context, content: e.toString());
    }
  }
}
