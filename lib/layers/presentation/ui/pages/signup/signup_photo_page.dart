import 'dart:ffi';
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../i18n/resources.dart';
import '../../../presenters/signup/getx_signup_presenter.dart';
import '../../components/app_bar/app_bar_default.dart';
import '../../components/bottom_sheet/bottom_sheet_image_picker.dart';
import '../../components/dialogs/error_dialog.dart';
import '../../components/dialogs/loading_dialog.dart';
import '../../components/padding/padding_default.dart';
import '../../components/sized_box_default.dart';

class SignupPhotoPage extends StatefulWidget {
  const SignupPhotoPage({Key? key}) : super(key: key);

  @override
  _SignupPhotoPageState createState() => _SignupPhotoPageState();
}

class _SignupPhotoPageState extends State<SignupPhotoPage> {
  final GetxSignupPresenter presenter = Get.find<GetxSignupPresenter>();

  double get radius => 18;

  @override
  void initState() {
    super.initState();
    presenter.viewModel.setPhoto(null);
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorSchema = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBarDefault(title: R.string.photo),
      body: SafeArea(
        child: Padding(
          padding: const PaddingDefault(),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBoxDefault(3),
                      Column(
                        children: [
                          Stack(
                            alignment: AlignmentDirectional.center,
                            children: [
                              InkWell(
                                onTap: () async {
                                  await BottomSheetImagePicker.show(
                                    context: context,
                                    title: R.string.photoProfile,
                                    onPressedCamera: () async {
                                      try {
                                        await presenter.getFromCameraOrGallery(isGallery: false);
                                        Navigator.of(context).pop();
                                      } catch (e) {
                                        ErrorDialog.show(context: context, content: e.toString());
                                      }
                                    },
                                    onPressedGallery: () async {
                                      try {
                                        await presenter.getFromCameraOrGallery(isGallery: true);
                                        Navigator.of(context).pop();
                                      } catch (e) {
                                        ErrorDialog.show(context: context, content: e.toString());
                                      }
                                    },
                                  );
                                },
                                borderRadius: BorderRadius.circular(radius),
                                child: Ink(
                                  width: 200,
                                  height: 200,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(radius),
                                    color: colorSchema.surface,
                                  ),
                                  child: Obx(
                                    () => Visibility(
                                      visible: presenter.viewModel.photo.value == null,
                                      child: DottedBorder(
                                        color: colorSchema.onBackground,
                                        strokeWidth: 2,
                                        dashPattern: const [6, 5],
                                        borderType: BorderType.RRect,
                                        radius: Radius.circular(radius),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.stretch,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            const Icon(Icons.person_pin_outlined, size: 60),
                                            const SizedBoxDefault(2),
                                            Text(R.string.addPhotoProfile, textAlign: TextAlign.center),
                                          ],
                                        ),
                                      ),
                                      replacement: ClipRRect(
                                        borderRadius: BorderRadius.circular(radius),
                                        child: Image.file(presenter.viewModel.photo.value ?? File("")),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Obx(
                                () => Visibility(
                                  visible: presenter.viewModel.photo.value != null,
                                  child: Positioned(
                                    top: 0,
                                    right: 0,
                                    child: Material(
                                      borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(10)),
                                      color: colorSchema.background,
                                      child: SizedBox(
                                        width: 40,
                                        height: 40,
                                        child: IconButton(
                                          iconSize: 22,
                                          color: colorSchema.secondary,
                                          padding: EdgeInsets.zero,
                                          icon: const Icon(Icons.delete),
                                          onPressed: () => presenter.viewModel.setPhoto(null),
                                          splashRadius: 20,
                                          tooltip: R.string.removePhoto,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBoxDefault(5),
                      ElevatedButton(
                        child: Text(R.string.advance),
                        onPressed: () async {
                          try {
                            await LoadingDialog.show(context: context, message: "${R.string.signingUp}...", onAction: () async {
                              await presenter.signup();
                            });
                          } catch (e) {
                            ErrorDialog.show(context: context, content: e.toString());
                          }
                        },
                      ),
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
