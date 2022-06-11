import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../i18n/resources.dart';
import '../../../presenters/wishlist/abstracts/wishlist_register_presenter.dart';
import '../../../presenters/wishlist/implements/getx_wishlist_register_presenter.dart';
import '../../../viewmodels/tag_viewmodel.dart';
import '../../../viewmodels/wishlist_viewmodel.dart';
import '../../components/app_bar/app_bar_default.dart';
import '../../components/bottom_sheet/bottom_sheet_default.dart';
import '../../components/circular_loading.dart';
import '../../components/dialogs/confirm_dialog.dart';
import '../../components/dialogs/error_dialog.dart';
import '../../components/dialogs/loading_dialog.dart';
import '../../components/form/text_field_default.dart';
import '../../components/form/validators/input_validators.dart';
import '../../components/padding/padding_default.dart';
import '../../components/sized_box_default.dart';
import '../tag/components/chip_add_tag.dart';
import '../tag/components/chip_tag.dart';
import '../tag/components/tag_form.dart';

class WishlistRegisterPage extends StatefulWidget {
  final WishlistViewModel? wishlistViewModel;

  const WishlistRegisterPage({Key? key, this.wishlistViewModel}) : super(key: key);

  @override
  _WishlistRegisterPageState createState() => _WishlistRegisterPageState();
}

class _WishlistRegisterPageState extends State<WishlistRegisterPage> {
  final WishlistRegisterPresenter presenter = Get.find<GetxWishlistRegisterPresenter>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameWishlistController = TextEditingController();

  @override
  void initState() {
    if (widget.wishlistViewModel != null) presenter.setViewModel(widget.wishlistViewModel!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBarDefault(title: R.string.wishlists),
      body: SafeArea(
        child: Padding(
          padding: const PaddingDefault(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBoxDefault(3),
              Expanded(
                child: Obx(() {
                  if (presenter.loading) {
                    return const CircularLoading();
                  } else {
                    return SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TextFieldDefault(
                              label: R.string.labelWishlist,
                              hint: R.string.hintWishlist,
                              controller: _nameWishlistController,
                              onSaved: presenter.viewModel.setDescription,
                              textInputAction: TextInputAction.done,
                              keyboardType: TextInputType.text,
                              validator: InputRequiredValidator().validate,
                            ),
                            const SizedBoxDefault(2),
                            Padding(
                              padding: const EdgeInsets.only(left: 6, bottom: 10),
                              child: Text(R.string.tag),
                            ),
                            Obx(
                              () => Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                spacing: 10,
                                children: [
                                  ChipAddTag(onTap: () async => await _createTag()),
                                  ...presenter.tagsViewModel
                                      .map((tag) => ChipTag(
                                            label: tag.name!,
                                            color: Color(tag.color!),
                                            selected: tag.id == presenter.viewModel.tag?.id,
                                            onSelected: (bool value) => presenter.viewModel.setTag(tag),
                                            backgroundColorDisable: colorScheme.surface,
                                            onBackgroundColorDisable: colorScheme.onSurface,
                                          ))
                                      .toList(),
                                ],
                              ),
                            ),
                            const SizedBoxDefault(2),
                            Padding(
                              padding: const EdgeInsets.only(left: 6, bottom: 10),
                              child: Text(R.string.wishes),
                            ),
                            OutlinedButton.icon(
                              icon: const Icon(Icons.add),
                              label: Text(R.string.wishes),
                              style: OutlinedButton.styleFrom(
                                primary: colorScheme.secondary,
                                side: BorderSide(color: colorScheme.secondary),
                              ),
                              onPressed: () async => await _navigateToWish(),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 6, top: 6),
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Obx(
                                  () {
                                    final int count = presenter.viewModel.wishes.length;
                                    return Text(count == 0
                                        ? R.string.noneWishSelected
                                        : count > 1
                                            ? "$count ${R.string.wishesSelected.toLowerCase()}"
                                            : "$count ${R.string.wishSelected.toLowerCase()}");
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                }),
              ),
              const SizedBoxDefault(),
              ElevatedButton.icon(
                label: Text(R.string.save),
                icon: const Icon(Icons.check),
                onPressed: () async => await _save(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _createTag() async {
    final GlobalKey<FormState> formKeyTag = GlobalKey<FormState>();
    final TagViewModel tag = TagViewModel();
    try {
      await BottomSheetDefault.show(
        context: context,
        isScrollControlled: true,
        title: R.string.createTag,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TagForm(viewModel: tag, formKeyTag: formKeyTag),
            const SizedBoxDefault(3),
            ElevatedButton.icon(
              label: Text(R.string.save),
              icon: const Icon(Icons.check),
              onPressed: () async {
                try {
                  if (!presenter.loading && formKeyTag.currentState!.validate()) {
                    formKeyTag.currentState!.save();

                    await LoadingDialog.show(
                      context: context,
                      message: "${R.string.savingTag}...",
                      onAction: () async => await presenter.createTag(tag),
                    );
                    Navigator.pop(context);
                  }
                } catch (e) {
                  ErrorDialog.show(context: context, content: e.toString());
                }
              },
            ),
          ],
        ),
      );
    } catch (e) {
      ErrorDialog.show(context: context, content: e.toString());
    }
  }

  Future<void> _save() async {
    try {
      if (!presenter.loading && _formKey.currentState!.validate()) {
        _formKey.currentState!.save();

        if (presenter.viewModel.wishes.isEmpty) {
          final bool? confirmed = await ConfirmDialog.show(
            context: context,
            title: R.string.titleNoneWish,
            message: R.string.messageNoneWish,
          );

          if (!(confirmed ?? false)) return;
        }

        await LoadingDialog.show(
          context: context,
          message: "${R.string.savingWishlist}...",
          onAction: () async => await presenter.save(),
        );
      }
    } catch (e) {
      ErrorDialog.show(context: context, content: e.toString());
    }
  }

  Future<void> _navigateToWish() async {
    await Navigator.pushNamed(context, "wish_register");
  }
}
