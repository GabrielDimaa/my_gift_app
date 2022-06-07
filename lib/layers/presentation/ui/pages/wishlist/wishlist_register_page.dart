import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../i18n/resources.dart';
import '../../../presenters/wishlist/implements/getx_wishlist_register_presenter.dart';
import '../../../viewmodels/tag_viewmodel.dart';
import '../../../viewmodels/wishlist_viewmodel.dart';
import '../../components/app_bar/app_bar_default.dart';
import '../../components/bottom_sheet/bottom_sheet_default.dart';
import '../../components/circular_loading.dart';
import '../../components/dialogs/error_dialog.dart';
import '../../components/dialogs/loading_dialog.dart';
import '../../components/form/text_field_default.dart';
import '../../components/form/validators/input_validators.dart';
import '../../components/padding/padding_default.dart';
import '../../components/sized_box_default.dart';
import '../tag/components/tag_form.dart';

class WishlistRegisterPage extends StatefulWidget {
  final WishlistViewModel? wishlistViewModel;

  const WishlistRegisterPage({Key? key, this.wishlistViewModel}) : super(key: key);

  @override
  _WishlistRegisterPageState createState() => _WishlistRegisterPageState();
}

class _WishlistRegisterPageState extends State<WishlistRegisterPage> {
  final GetxWishlistRegisterPresenter presenter = Get.find<GetxWishlistRegisterPresenter>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameWishlistController = TextEditingController();

  double get radius => 100;

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
      body: Padding(
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
                              children: [
                                IntrinsicWidth(
                                  child: InkWell(
                                    onTap: () async => await _createTag(),
                                    borderRadius: BorderRadius.circular(radius),
                                    child: DottedBorder(
                                      color: Theme.of(context).colorScheme.onBackground,
                                      strokeWidth: 2,
                                      dashPattern: const [3, 3],
                                      borderType: BorderType.RRect,
                                      radius: Radius.circular(radius),
                                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 18),
                                      child: Row(
                                        children: [
                                          const Icon(Icons.add, size: 20),
                                          const SizedBoxDefault.horizontal(),
                                          Text(R.string.addTag, textAlign: TextAlign.center),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                ...presenter.tagsViewModel
                                    .map((tag) => _chipTag(
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
                            onPressed: () {},
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 6, top: 6),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(R.string.wishes.toLowerCase()),
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
    );
  }

  Widget _chipTag({
    required String label,
    required Color color,
    required bool selected,
    required void Function(bool)? onSelected,
    required Color backgroundColorDisable,
    required Color onBackgroundColorDisable,
  }) {
    return ChoiceChip(
      label: Text(
        label,
        style: TextStyle(color: selected ? color : onBackgroundColorDisable),
      ),
      selected: selected,
      onSelected: onSelected,
      selectedColor: color.withOpacity(0.1),
      side: BorderSide(color: selected ? color : const Color(0xFF464646)),
      backgroundColor: backgroundColorDisable,
      labelPadding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
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

                    await LoadingDialog.show(context: context, message: "${R.string.savingTag}...", onAction: () async {
                      await presenter.createTag(tag);
                    });

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
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();

        // TODO: implement save.
      }
    } catch (e) {
      ErrorDialog.show(context: context, content: e.toString());
    }
  }
}
