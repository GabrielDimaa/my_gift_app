import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../i18n/resources.dart';
import '../../../../../routes/routes.dart';
import '../../../presenters/wishlist/abstracts/wishlist_register_presenter.dart';
import '../../../presenters/wishlist/implements/getx_wishlist_register_presenter.dart';
import '../../../viewmodels/tag_viewmodel.dart';
import '../../../viewmodels/wish_viewmodel.dart';
import '../../../viewmodels/wishlist_viewmodel.dart';
import '../../components/app_bar/app_bar_default.dart';
import '../../components/app_bar/button_action.dart';
import '../../components/bottom_sheet/bottom_sheet_default.dart';
import '../../components/bottom_sheet/confirm_bottom_sheet.dart';
import '../../components/bottom_sheet/discard_changes_bottom_sheet.dart';
import '../../components/button/save_button.dart';
import '../../components/circular_loading.dart';
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
import '../wish/widgets/list_tile_wish.dart';

class WishlistRegisterPage extends StatefulWidget {
  final WishlistViewModel? viewModel;

  const WishlistRegisterPage({Key? key, this.viewModel}) : super(key: key);

  @override
  State<WishlistRegisterPage> createState() => _WishlistRegisterPageState();
}

class _WishlistRegisterPageState extends State<WishlistRegisterPage> {
  final WishlistRegisterPresenter presenter = Get.find<GetxWishlistRegisterPresenter>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameWishlistController = TextEditingController();

  @override
  void initState() {
    presenter.initialize(widget.viewModel)
        .catchError((e) => ErrorDialog.show(context: context, content: e.toString()))
        .whenComplete(() => _updateTextEditingController());
    super.initState();
  }

  void _updateTextEditingController() {
    _nameWishlistController.text = presenter.viewModel.description ?? "";
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return WillPopScope(
      onWillPop: () async {
        if (presenter.hasChanged) return await DiscardChangesBottomSheet.show(context);
        return true;
      },
      child: Scaffold(
        appBar: AppBarDefault(
          title: widget.viewModel?.id == null ? R.string.newList : R.string.editList,
          actions: [
            ButtonAction(
              visible: widget.viewModel?.id != null,
              label: R.string.delete,
              icon: Icons.delete_outline,
              onPressed: () async => await _delete(),
            ),
          ],
        ),
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
                          onChanged: () => presenter.setHasChanged(true),
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
                                  foregroundColor: colorScheme.secondary, side: BorderSide(color: colorScheme.secondary, width: 2),
                                ),
                                onPressed: () async => await _navigateToWishCreate(),
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
                                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
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
                SaveButton(onPressed: () async => await _save()),
              ],
            ),
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
            const SizedBoxDefault(),
            TagForm(viewModel: tag, formKeyTag: formKeyTag),
            const SizedBoxDefault(3),
            SaveButton(
              onPressed: () async {
                try {
                  if (!presenter.loading && formKeyTag.currentState!.validate()) {
                    formKeyTag.currentState!.save();

                    await LoadingDialog.show(
                      context: context,
                      message: "${R.string.savingTag}...",
                      onAction: () async => await presenter.createTag(tag),
                    );

                    if (!mounted) return;
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
          final bool confirmed = await ConfirmBottomSheet.show(
            context: context,
            title: R.string.titleNoneWish,
            message: R.string.messageNoneWish,
          );

          if (!confirmed) return;
        }

        if (!mounted) return;
        await LoadingDialog.show(
          context: context,
          message: "${R.string.savingWishlist}...",
          onAction: () async => await presenter.save(),
        );

        if (!mounted) return;
        Navigator.pop(context, presenter.viewModel);
      }
    } catch (e) {
      ErrorDialog.show(context: context, content: e.toString());
    }
  }

  Future<void> _delete() async {
    try {
      final bool confirmed = await ConfirmBottomSheet.show(
            context: context,
            title: R.string.delete,
            message: R.string.confirmDeleteWishlist,
          );
      if (!confirmed) return;

      if (!mounted) return;
      await LoadingDialog.show(
        context: context,
        message: "${R.string.deletingWishlist}...",
        onAction: () async => await presenter.delete(),
      );

      presenter.viewModel.deleted = true;
      if (!mounted) return;
      Navigator.pop(context, presenter.viewModel);
    } catch (e) {
      ErrorDialog.show(context: context, content: e.toString());
    }
  }

  Future<void> _navigateToWishCreate() async {
    final WishViewModel? wishViewModel = await Navigator.pushNamed(context, wishRegisterRoute, arguments: {
      'wishlistViewModel': presenter.viewModel.id != null ? presenter.viewModel : null,
    }) as WishViewModel?;

    if (wishViewModel != null) {
      presenter.viewModel.wishes.add(wishViewModel);
      presenter.setHasChanged(true);
    }
  }

  Future<WishViewModel?> _navigateToWishEdit(WishViewModel wish) async {
    return await Navigator.pushNamed(context, wishRegisterRoute, arguments: {
      'viewModel': wish.clone(),
    }) as WishViewModel?;
  }

  Future<void> _seeWishes() async {
    final double heightModal = MediaQuery.of(context).size.height * 0.6;

    await BottomSheetDefault.show(
      context: context,
      isScrollControlled: true,
      title: R.string.wishes,
      contentPadding: EdgeInsets.zero,
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
                        return ListTileWish(
                          viewModel: wish,
                          onTap: () async {
                            final WishViewModel? wishUpdated = await _navigateToWishEdit(wish);
                            if (wishUpdated != null) {
                              if (wishUpdated.deleted ?? false) {
                                presenter.viewModel.wishes.removeAt(index);
                              } else {
                                presenter.viewModel.wishes[index] = wishUpdated;
                              }
                            }
                          },
                          onDismissed: (_) async => presenter.viewModel.wishes.removeAt(index),
                          confirmDismiss: (_) async {
                            try {
                              if (wish.id == null) return true;

                              final bool confirmed = await ConfirmBottomSheet.show(context: context, title: R.string.delete, message: R.string.confirmDeleteWish);
                              if (confirmed && mounted) {
                                await LoadingDialog.show(
                                  context: context,
                                  message: "${R.string.deletingWish}...",
                                  onAction: () async => await presenter.deleteWish(wish),
                                );
                              }

                              return confirmed;
                            } catch (e) {
                              ErrorDialog.show(context: context, content: e.toString());
                              return false;
                            }
                          },
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
}
