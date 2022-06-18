import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../../../extensions/double_extension.dart';
import '../../../../../i18n/resources.dart';
import '../../../../../routes/routes.dart';
import '../../../viewmodels/wish_viewmodel.dart';
import '../../components/app_bar/app_bar_default.dart';
import '../../components/app_bar/button_action.dart';
import '../../components/dialogs/confirm_dialog.dart';
import '../../components/padding/padding_default.dart';
import '../../components/sized_box_default.dart';
import 'widgets/wish_without_image.dart';

class WishDetailsPage extends StatefulWidget {
  final WishViewModel viewModel;

  const WishDetailsPage({Key? key, required this.viewModel}) : super(key: key);

  @override
  State<WishDetailsPage> createState() => _WishDetailsPageState();
}

class _WishDetailsPageState extends State<WishDetailsPage> {
  ColorScheme get colorScheme => Theme.of(context).colorScheme;

  TextTheme get textTheme => Theme.of(context).textTheme;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarDefault(
        title: R.string.wish,
        actions: [
          ButtonAction(
            onPressed: () async => await _edit(),
            label: R.string.edit,
            icon: Icons.edit_outlined,
          ),
        ],
        onBackPressed: () => Navigator.pop(context, widget.viewModel),
      ),
      body: SafeArea(
        child: Padding(
          padding: const PaddingDefault(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBoxDefault(3),
                      Align(
                        alignment: Alignment.center,
                        child: Visibility(
                          visible: widget.viewModel.image != null,
                          replacement: const WishWithoutImage(size: 200, iconSize: 90),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              widget.viewModel.image ?? "",
                              height: 200,
                              width: 200,
                            ),
                          ),
                        ),
                      ),
                      const SizedBoxDefault(2),
                      _label(text: R.string.labelDescription),
                      _content(text: widget.viewModel.description!),
                      const SizedBoxDefault(2),
                      _label(text: R.string.labelPriceRangeWish),
                      _content(text: "${widget.viewModel.priceRangeInitial!.money} - ${widget.viewModel.priceRangeFinal!.money}"),
                      Visibility(
                        visible: widget.viewModel.link != null,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBoxDefault(2),
                            _label(text: R.string.linkSite),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () async => await _goToSite(),
                                    child: Text(
                                      widget.viewModel.link ?? "",
                                      style: textTheme.bodyText1?.copyWith(fontWeight: FontWeight.w700, decoration: TextDecoration.underline),
                                    ),
                                  ),
                                ),
                                const SizedBoxDefault.horizontal(),
                                IconButton(
                                  onPressed: () async => await _copyLink(),
                                  tooltip: R.string.copyLink,
                                  color: colorScheme.secondary,
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  icon: const Icon(Icons.copy_outlined),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: widget.viewModel.note != null,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBoxDefault(2),
                            _label(text: R.string.labelNoteWish),
                            _content(text: widget.viewModel.note ?? ""),
                          ],
                        ),
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

  //region Events

  Future<void> _edit() async {
    final WishViewModel? viewModel = await Navigator.pushNamed(context, wishRegisterRoute, arguments: {'viewModel': widget.viewModel.clone()}) as WishViewModel?;
    if (viewModel != null) setState(() => widget.viewModel.updateViewModel(viewModel));
  }

  Future<void> _goToSite() async {
    final bool confirmed = await ConfirmDialog.show(context: context, title: R.string.gotToLink, message: R.string.messageConfirmGoToLink) ?? false;
    if (confirmed) await launchUrl(Uri.parse(widget.viewModel.link!));
  }

  Future<void> _copyLink() async {
    Clipboard.setData(ClipboardData(text: widget.viewModel.link!)).then((_) {
      final snackBar = SnackBar(
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(Icons.content_paste_go_rounded, color: colorScheme.secondary),
            const SizedBoxDefault.horizontal(),
            Expanded(
              child: Text(
                R.string.copiedLink,
                style: textTheme.bodyText2?.copyWith(fontWeight: FontWeight.w500, color: colorScheme.background),
              ),
            ),
            const SizedBoxDefault.horizontal(),
            IconButton(
              constraints: const BoxConstraints(),
              padding: EdgeInsets.zero,
              onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
              icon: Icon(Icons.close, color: colorScheme.background),
            ),
          ],
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
  }

  //endregion

  //region Widgets

  Widget _label({required String text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: textTheme.bodyText2?.copyWith(color: Colors.grey),
      ),
    );
  }

  Widget _content({required String text}) {
    return Text(
      text,
      style: textTheme.bodyText1?.copyWith(fontWeight: FontWeight.w700),
    );
  }

  //endregion
}