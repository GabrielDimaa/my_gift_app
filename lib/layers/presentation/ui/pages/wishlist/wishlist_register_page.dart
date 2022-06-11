import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../extensions/double_extension.dart';
import '../../../../../i18n/resources.dart';
import '../../../presenters/wishlist/abstracts/wishlist_register_presenter.dart';
import '../../../presenters/wishlist/implements/getx_wishlist_register_presenter.dart';
import '../../../viewmodels/tag_viewmodel.dart';
import '../../../viewmodels/wish_viewmodel.dart';
import '../../../viewmodels/wishlist_viewmodel.dart';
import '../../components/app_bar/app_bar_default.dart';
import '../../components/bottom_sheet/bottom_sheet_default.dart';
import '../../components/circular_loading.dart';
import '../../components/dialogs/confirm_dialog.dart';
import '../../components/dialogs/error_dialog.dart';
import '../../components/dialogs/loading_dialog.dart';
import '../../components/form/text_field_default.dart';
import '../../components/form/validators/input_validators.dart';
import '../../components/not_found.dart';
import '../../components/padding/padding_default.dart';
import '../../components/sized_box_default.dart';
import '../tag/components/chip_add_tag.dart';
import '../tag/components/chip_tag.dart';
import '../tag/components/tag_form.dart';
import '../wish/components/wish_without_image.dart';

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
                              label: Text(R.string.addWishes),
                              style: OutlinedButton.styleFrom(
                                primary: colorScheme.secondary,
                                side: BorderSide(color: colorScheme.secondary),
                              ),
                              onPressed: () async => await _navigateToWish(),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 6, top: 6),
                              child: Wrap(
                                alignment: WrapAlignment.spaceBetween,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Obx(
                                    () {
                                      final int count = presenter.viewModel.wishes.length;
                                      return Text(count == 0
                                          ? R.string.noneWishSelected
                                          : count > 1
                                              ? "$count ${R.string.wishesSelected.toLowerCase()}"
                                              : "$count ${R.string.wishSelected.toLowerCase()}");
                                    },
                                  ),
                                  TextButton(
                                    child: Text(
                                      R.string.seeWishes,
                                      style: Theme.of(context).textTheme.subtitle2?.copyWith(
                                            fontSize: 16,
                                            color: Theme.of(context).colorScheme.secondary,
                                          ),
                                    ),
                                    onPressed: () async => await _seeWishes(),
                                  ),
                                ],
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

  Future<WishViewModel?> _navigateToWish({WishViewModel? wish}) async {
    final WishViewModel? wishViewModel = await Navigator.pushNamed(context, "wish_register", arguments: {
      //Controle para não enviar os dois parâmetros ao mesmo tempo, pois WishRegister possui um assert validando isto.
      'viewModel': wish?.clone(),
      'wishlistViewModel': presenter.viewModel.id != null && wish != null ? presenter.viewModel : null,
    }) as WishViewModel?;

    if (wishViewModel != null && wish == null) presenter.viewModel.wishes.add(wishViewModel);

    return wishViewModel;
  }

  Future<void> _seeWishes() async {
    final double heightModal = MediaQuery.of(context).size.height * 0.6;

    await BottomSheetDefault.show(
      context: context,
      isScrollControlled: true,
      title: R.string.wishes,
      child: SizedBox(
        height: heightModal,
        child: Column(
          children: [
            Expanded(
              child: Obx(
                () {
                  if (presenter.viewModel.wishes.isNotEmpty) {
                    return ListView.separated(
                      itemCount: presenter.viewModel.wishes.length,
                      separatorBuilder: (_, __) => const Divider(thickness: 1, height: 1),
                      itemBuilder: (_, index) {
                        final WishViewModel wish = presenter.viewModel.wishes[index];
                        return ListTile(
                          contentPadding: const EdgeInsets.all(4),
                          onTap: () async {
                            final WishViewModel? wishUpdated = await _navigateToWish(wish: wish);
                            if (wishUpdated != null) presenter.viewModel.wishes[index] = wishUpdated;
                          },
                          title: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              _imageWish(wish.image),
                              const SizedBoxDefault.horizontal(),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(wish.description ?? ""),
                                    Text(
                                      "${wish.priceRangeInitial!.money} - ${wish.priceRangeFinal!.money}",
                                      style: Theme.of(context).textTheme.caption?.copyWith(fontWeight: FontWeight.w500, color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBoxDefault.horizontal(),
                              const Icon(Icons.arrow_forward_ios, size: 18),
                            ],
                          ),
                        );
                      },
                    );
                  } else {
                    return NotFound(message: R.string.notFoundWishes);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _imageWish(String? image) {
    if (image == null) {
      return const WishWithoutImage();
    } else {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: (Uri.tryParse(image)?.isAbsolute ?? false)
            ? Image.network(
                image,
                height: 70,
                width: 70,
              )
            : Image.file(
                File(image),
                height: 70,
                width: 70,
              ),
      );
    }
  }
}
