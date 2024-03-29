import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../i18n/resources.dart';
import '../../../../../routes/routes.dart';
import '../../../presenters/wishlist/abstracts/wishlist_details_presenter.dart';
import '../../../presenters/wishlist/implements/getx_wishlist_details_presenter.dart';
import '../../../viewmodels/wish_viewmodel.dart';
import '../../../viewmodels/wishlist_viewmodel.dart';
import '../../components/app_bar/app_bar_default.dart';
import '../../components/app_bar/button_action.dart';
import '../../components/circular_loading.dart';
import '../../components/dialogs/error_dialog.dart';
import '../../components/not_found.dart';
import '../../components/padding/padding_default.dart';
import '../../components/sized_box_default.dart';
import '../wish/widgets/list_tile_wish.dart';

class WishlistDetailsPage extends StatefulWidget {
  final WishlistViewModel viewModel;

  const WishlistDetailsPage({Key? key, required this.viewModel}) : super(key: key);

  @override
  State<WishlistDetailsPage> createState() => _WishlistDetailsPageState();
}

class _WishlistDetailsPageState extends State<WishlistDetailsPage> {
  final WishlistDetailsPresenter presenter = Get.find<GetxWishlistDetailsPresenter>();

  TextTheme get textTheme => Theme.of(context).textTheme;

  @override
  void initState() {
    presenter.initialize(widget.viewModel).catchError((e) => ErrorDialog.show(context: context, content: e.toString()));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, presenter.viewModel);
        return true;
      },
      child: Scaffold(
        appBar: AppBarDefault(
          title: R.string.wishlist,
          actions: [
            ButtonAction(
              visible: presenter.canEdit,
              label: R.string.edit,
              icon: Icons.edit_outlined,
              onPressed: () async => await _edit(),
            ),
          ],
          onBackPressed: () => Navigator.pop(context, presenter.viewModel),
        ),
        body: SafeArea(
          child: Padding(
            padding: const PaddingDefault(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Obx(
                    () {
                      if (presenter.loading) {
                        return const CircularLoading();
                      } else {
                        return SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBoxDefault(2),
                              ButtonBar(
                                buttonPadding: EdgeInsets.zero,
                                alignment: MainAxisAlignment.spaceBetween,
                                overflowButtonSpacing: 8,
                                children: [
                                  Obx(
                                    () => Text(
                                      presenter.viewModel.description!,
                                      style: textTheme.titleLarge,
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Obx(
                                      () => Chip(
                                        label: Text(
                                          presenter.viewModel.tag!.name!,
                                          style: textTheme.bodySmall?.copyWith(
                                            color: Color(presenter.viewModel.tag!.color!),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        visualDensity: const VisualDensity(vertical: -3),
                                        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                                        backgroundColor: Color(presenter.viewModel.tag!.color!).withOpacity(0.1),
                                        side: BorderSide(color: Color(presenter.viewModel.tag!.color!)),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBoxDefault(),
                              Obx(
                                () {
                                  if (presenter.viewModel.wishes.isNotEmpty) {
                                    return ListView.separated(
                                      physics: const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: presenter.viewModel.wishes.length,
                                      separatorBuilder: (_, __) => const Divider(thickness: 1, height: 1),
                                      itemBuilder: (_, index) {
                                        final WishViewModel wish = presenter.viewModel.wishes[index];
                                        return ListTileWish(
                                          contentPadding: const EdgeInsets.all(6),
                                          viewModel: wish,
                                          onTap: () async => await _navigateToWish(wish, index),
                                        );
                                      },
                                    );
                                  } else {
                                    return Column(
                                      children: [
                                        const SizedBoxDefault(6),
                                        NotFound(message: R.string.noneWishes),
                                      ],
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _edit() async {
    if (!presenter.canEdit) return await ErrorDialog.show(context: context, content: R.string.noAccessError);

    final WishlistViewModel? wishlistViewModel = await Navigator.pushNamed(context, wishlistRegisterRoute, arguments: widget.viewModel.clone()) as WishlistViewModel?;
    if (wishlistViewModel != null) {
      if (wishlistViewModel.deleted ?? false) {
        if (!mounted) return;
        Navigator.pop(context, wishlistViewModel);
      } else {
        presenter.setViewModel(wishlistViewModel);
      }
    }
  }

  Future<void> _navigateToWish(WishViewModel wish, int index) async {
    final WishViewModel? wishViewModel = await Navigator.pushNamed(context, wishDetailsRoute, arguments: wish.clone()) as WishViewModel?;
    if (wishViewModel != null) {
      if (wishViewModel.deleted ?? false) {
        presenter.viewModel.wishes.removeAt(index);
      } else {
        presenter.viewModel.wishes[index] = wishViewModel;
      }
    }
  }
}
