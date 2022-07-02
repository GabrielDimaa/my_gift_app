import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/instance_manager.dart';

import '../../../../../i18n/resources.dart';
import '../../../../../routes/routes.dart';
import '../../../presenters/user/getx_user_edit_profile_presenter.dart';
import '../../../presenters/user/user_edit_profile_presenter.dart';
import '../../components/app_bar/app_bar_default.dart';
import '../../components/bottom_sheet/image_picker_bottom_sheet.dart';
import '../../components/button/save_button.dart';
import '../../components/circular_loading.dart';
import '../../components/dialogs/error_dialog.dart';
import '../../components/dialogs/loading_dialog.dart';
import '../../components/form/text_field_default.dart';
import '../../components/form/validators/input_validators.dart';
import '../../components/images/image_loader_default.dart';
import '../../components/padding/padding_default.dart';
import '../../components/sized_box_default.dart';

class UserEditProfilePage extends StatefulWidget {
  const UserEditProfilePage({Key? key}) : super(key: key);

  @override
  State<UserEditProfilePage> createState() => _UserEditProfilePageState();
}

class _UserEditProfilePageState extends State<UserEditProfilePage> {
  final UserEditProfilePresenter presenter = Get.find<GetxUserEditProfilePresenter>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    presenter.initialize().catchError((e) => ErrorDialog.show(context: context, content: e.toString())).whenComplete(() => _updateTextEditingController());
    super.initState();
  }

  void _updateTextEditingController() {
    _nameController.text = presenter.viewModel.name;
    _emailController.text = presenter.viewModel.email;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarDefault(title: R.string.editData),
      body: SafeArea(
        child: Padding(
          padding: const PaddingDefault(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
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
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBoxDefault(2),
                                Stack(
                                  children: [
                                    GestureDetector(
                                      onTap: () async => await _alterPhoto(),
                                      child: Obx(() => _photoProfile()),
                                    ),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: SizedBox(
                                        height: 160,
                                        width: 160,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.only(bottom: 20),
                                              height: 20,
                                              width: 160,
                                              color: Colors.black54,
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    R.string.alterPhoto,
                                                    style: Theme.of(context).textTheme.caption,
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  const SizedBoxDefault.horizontal(),
                                                  const Icon(
                                                    Icons.edit,
                                                    size: 14,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBoxDefault(2),
                                Form(
                                  key: _formKey,
                                  child: Column(
                                    children: [
                                      TextFieldDefault(
                                        label: R.string.name,
                                        hint: R.string.nameHint,
                                        controller: _nameController,
                                        textInputAction: TextInputAction.done,
                                        keyboardType: TextInputType.text,
                                        onSaved: presenter.viewModel.setName,
                                        validator: InputRequiredValidator().validate,
                                        textCapitalization: TextCapitalization.sentences,
                                      ),
                                      const SizedBoxDefault(2),
                                      TextFieldDefault(
                                        label: R.string.email,
                                        hint: _emailController.text,
                                        controller: _emailController,
                                        textInputAction: TextInputAction.done,
                                        keyboardType: TextInputType.emailAddress,
                                        onSaved: presenter.viewModel.setEmail,
                                        validator: InputEmailValidator().validate,
                                        enabled: false,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBoxDefault(),
                        SaveButton(onPressed: () async => await _save()),
                      ],
                    );
                  }
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _photoProfile() {
    if (presenter.viewModel.photo == null) {
      return CircleAvatar(
        radius: 80,
        backgroundColor: Theme.of(context).colorScheme.secondary,
        child: Text(
          presenter.viewModel.name.characters.first,
          style: const TextStyle(fontSize: 80, color: Colors.white),
        ),
      );
    } else {
      return ImageLoaderDefault(
        image: presenter.viewModel.photo!,
        height: 160,
        width: 160,
        radius: 500,
      );
    }
  }

  Future<void> _alterPhoto() async {
    await ImagePickerBottomSheet.show(
      context: context,
      title: R.string.photoProfile,
      onPressedCamera: () async {
        try {
          await presenter.getFromCameraOrGallery(isGallery: false);

          if (!mounted) return;
          Navigator.pop(context);
        } catch (e) {
          ErrorDialog.show(context: context, content: e.toString());
        }
      },
      onPressedGallery: () async {
        try {
          await presenter.getFromCameraOrGallery(isGallery: true);

          if (!mounted) return;
          Navigator.pop(context);
        } catch (e) {
          ErrorDialog.show(context: context, content: e.toString());
        }
      },
    );
  }

  Future<void> _save() async {
    try {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();

        await LoadingDialog.show(
            context: context,
            message: "${R.string.savingData}...",
            onAction: () async {
              await presenter.save();
            });

        if (!mounted) return;

        //Faz um RemoveUntil para forçar a atualização da dashboard.
        await Navigator.pushNamedAndRemoveUntil(
          context,
          dashboardRoute,
          (Route<dynamic> route) => false,
        );
      }
    } catch (e) {
      ErrorDialog.show(context: context, content: e.toString());
    }
  }
}
