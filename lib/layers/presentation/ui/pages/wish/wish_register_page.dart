import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../extensions/double_extension.dart';
import '../../../../../i18n/resources.dart';
import '../../../helpers/enums/price_range.dart';
import '../../../presenters/wish/abstracts/wish_register_presenter.dart';
import '../../../presenters/wish/implements/getx_wish_register_presenter.dart';
import '../../../viewmodels/wish_viewmodel.dart';
import '../../../viewmodels/wishlist_viewmodel.dart';
import '../../components/app_bar/app_bar_default.dart';
import '../../components/app_bar/button_action.dart';
import '../../components/bottom_sheet/bottom_sheet_image_picker.dart';
import '../../components/button/save_button.dart';
import '../../components/dialogs/confirm_dialog.dart';
import '../../components/dialogs/error_dialog.dart';
import '../../components/dialogs/loading_dialog.dart';
import '../../components/form/text_field_default.dart';
import '../../components/form/validators/input_validators.dart';
import '../../components/padding/padding_default.dart';
import '../../components/sized_box_default.dart';
import 'widgets/dropdown_price_range.dart';
import 'widgets/range_slider_price.dart';

class WishRegisterPage extends StatefulWidget {
  final WishViewModel? viewModel;
  final WishlistViewModel? wishlistViewModel;

  const WishRegisterPage({
    Key? key,
    this.viewModel,
    this.wishlistViewModel,
  })  : assert(viewModel == null || wishlistViewModel == null),
        super(key: key);

  @override
  State<WishRegisterPage> createState() => _WishRegisterPageState();
}

class _WishRegisterPageState extends State<WishRegisterPage> {
  final WishRegisterPresenter presenter = Get.find<GetxWishRegisterPresenter>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _linkController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final FocusNode _descriptionFocus = FocusNode();
  final FocusNode _linkFocus = FocusNode();
  final FocusNode _noteFocus = FocusNode();

  double get startRangeSliderDefault => presenter.priceRangeSelected.min + 20;

  double get endRangeSliderDefault => presenter.priceRangeSelected.max - 20;

  @override
  void initState() {
    if (widget.viewModel != null) {
      presenter.setViewModel(widget.viewModel!);

      presenter.setPriceRange(PriceRangeExtension.getPriceRange(presenter.viewModel.priceRangeInitial!, presenter.viewModel.priceRangeFinal!), calculate: false);
      _updateTextEditingController();
    } else {
      if (presenter.viewModel.id == null) {
        presenter.viewModel.setPriceRangeInitial(startRangeSliderDefault);
        presenter.viewModel.setPriceRangeFinal(endRangeSliderDefault);
      }
      //Gabriel: Caso seja passado um wishlistViewModel será para adicionar o id da wishlist no viewmodel.
      if (widget.wishlistViewModel != null) presenter.viewModel.setWishlistId(widget.wishlistViewModel?.id);
    }
    super.initState();
  }

  void _updateTextEditingController() {
    _descriptionController.text = presenter.viewModel.description ?? "";
    _linkController.text = presenter.viewModel.link ?? "";
    _noteController.text = presenter.viewModel.note ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarDefault(
        title: widget.viewModel == null ? R.string.newWish : R.string.editWish,
        actions: [
          ButtonAction(
            visible: widget.viewModel != null,
            label: "Excluir",
            icon: Icons.delete_outlined,
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
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 6, bottom: 10),
                        child: Text(R.string.image),
                      ),
                      Stack(
                        children: [
                          InkWell(
                            onTap: () async => await _addImage(),
                            borderRadius: BorderRadius.circular(18),
                            child: Obx(
                              () => Visibility(
                                visible: presenter.viewModel.image == null,
                                replacement: ClipRRect(
                                  borderRadius: BorderRadius.circular(18),
                                  child: (Uri.tryParse(presenter.viewModel.image ?? "")?.isAbsolute ?? false)
                                      ? Image.network(
                                          presenter.viewModel.image ?? "",
                                          width: 150,
                                          height: 150,
                                        )
                                      : Image.file(
                                          File(presenter.viewModel.image ?? ""),
                                          width: 150,
                                          height: 150,
                                        ),
                                ),
                                child: Ink(
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.surface,
                                    border: Border.all(color: const Color(0xFF464646), width: 2),
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  height: 150,
                                  width: 150,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.photo_size_select_large, size: 50),
                                      const SizedBoxDefault(),
                                      Text(R.string.addImage, style: Theme.of(context).textTheme.subtitle2?.copyWith(fontSize: 14)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Obx(
                            () => Visibility(
                              visible: presenter.viewModel.image != null,
                              child: Positioned(
                                top: 0,
                                right: 0,
                                child: Material(
                                  borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(10)),
                                  color: Theme.of(context).colorScheme.background,
                                  child: SizedBox(
                                    width: 32,
                                    height: 32,
                                    child: IconButton(
                                      iconSize: 20,
                                      color: Theme.of(context).colorScheme.secondary,
                                      padding: EdgeInsets.zero,
                                      icon: const Icon(Icons.delete),
                                      onPressed: () => presenter.viewModel.setImage(null),
                                      splashRadius: 16,
                                      tooltip: R.string.removeImage,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBoxDefault(2),
                      Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFieldDefault(
                              label: R.string.labelDescription,
                              hint: R.string.hintDescriptionWish,
                              controller: _descriptionController,
                              focusNode: _descriptionFocus,
                              onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_linkFocus),
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.text,
                              onSaved: presenter.viewModel.setDescription,
                              validator: InputRequiredValidator().validate,
                              textCapitalization: TextCapitalization.sentences,
                            ),
                            const SizedBoxDefault(2),
                            TextFieldDefault(
                              label: R.string.labelLinkWish,
                              hint: R.string.hintLinkWish,
                              controller: _linkController,
                              focusNode: _linkFocus,
                              onFieldSubmitted: (_) => FocusScope.of(context).unfocus(),
                              textInputAction: TextInputAction.done,
                              keyboardType: TextInputType.url,
                              onSaved: presenter.viewModel.setLink,
                              textCapitalization: TextCapitalization.none,
                            ),
                            const SizedBoxDefault(2),
                            Padding(
                              padding: const EdgeInsets.only(left: 6, bottom: 10),
                              child: Text(R.string.labelPriceRangeWish),
                            ),
                            const SizedBoxDefault(2),
                            RangeSliderPrice(presenter: presenter),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 6),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Obx(
                                    () {
                                      if (presenter.viewModel.priceRangeInitial == PriceRange.pr500.max && presenter.viewModel.priceRangeFinal == PriceRange.pr500.max) {
                                        return Text("${R.string.greaterThan} ${PriceRange.pr500.max.money}");
                                      } else {
                                        final double start = presenter.viewModel.priceRangeInitial ?? startRangeSliderDefault;
                                        final double end = presenter.viewModel.priceRangeFinal ?? endRangeSliderDefault;
                                        return Text("${start.money} - ${end.money}");
                                      }
                                    },
                                  ),
                                  DropdownPriceRange(presenter: presenter),
                                ],
                              ),
                            ),
                            const SizedBoxDefault(2),
                            TextFieldDefault(
                              label: R.string.labelNoteWish,
                              hint: R.string.hintNoteWish,
                              controller: _noteController,
                              focusNode: _noteFocus,
                              onFieldSubmitted: (_) => FocusScope.of(context).unfocus(),
                              textInputAction: TextInputAction.done,
                              keyboardType: TextInputType.text,
                              onSaved: presenter.viewModel.setNote,
                              textCapitalization: TextCapitalization.sentences,
                              minLines: 2,
                              maxLines: 4,
                            ),
                            const SizedBoxDefault(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBoxDefault(2),
              SaveButton(onPressed: () async => await _save()),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _save() async {
    try {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();

        //Caso a wishlist seja null e o view model não possui wishlist id, significa que deve retornar pra salvar junto com a wishlist.
        if (widget.wishlistViewModel == null && presenter.viewModel.wishlistId == null) {
          presenter.validate(ignoreWishlistId: true);
          Navigator.pop(context, presenter.viewModel);
        } else {
          await LoadingDialog.show(context: context, message: "${R.string.savingWish}...", onAction: () async => await presenter.save());

          if (!mounted) return;
          Navigator.pop(context, presenter.viewModel);
        }
      }
    } catch (e) {
      ErrorDialog.show(context: context, content: e.toString());
    }
  }

  Future<void> _delete() async {
    try {
      final bool? confirmed = await ConfirmDialog.show(
        context: context,
        title: R.string.delete,
        message: R.string.confirmDeleteWish,
      );

      if (confirmed ?? false) {
        if (presenter.viewModel.id != null) {
          await LoadingDialog.show(
            context: context,
            message: "${R.string.deletingWish}...",
            onAction: () async => await presenter.delete(),
          );
        }

        presenter.viewModel.deleted = true;
        if (!mounted) return;
        Navigator.pop(context, presenter.viewModel);
      }
    } catch (e) {
      ErrorDialog.show(context: context, content: e.toString());
    }
  }

  Future<void> _addImage() async {
    await BottomSheetImagePicker.show(
      context: context,
      title: R.string.imageWish,
      onPressedCamera: () async {
        try {
          await LoadingDialog.show(
              context: context,
              message: "${R.string.opening} ${R.string.camera}...",
              onAction: () async {
                await presenter.getFromCameraOrGallery(isGallery: false);
              });

          if (!mounted) return;
          Navigator.of(context).pop();
        } catch (e) {
          ErrorDialog.show(context: context, content: e.toString());
        }
      },
      onPressedGallery: () async {
        try {
          await LoadingDialog.show(
              context: context,
              message: "${R.string.opening} ${R.string.gallery}...",
              onAction: () async {
                await presenter.getFromCameraOrGallery(isGallery: true);
              });

          if (!mounted) return;
          Navigator.of(context).pop();
        } catch (e) {
          ErrorDialog.show(context: context, content: e.toString());
        }
      },
    );
  }
}
