import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/instance_manager.dart';

import '../../../../../i18n/resources.dart';
import '../../../../../routes/routes.dart';
import '../../../presenters/friend/getx_profile_presenter.dart';
import '../../../presenters/friend/profile_presenter.dart';
import '../../../viewmodels/user_viewmodel.dart';
import '../../../viewmodels/wishlist_viewmodel.dart';
import '../../components/app_bar/app_bar_default.dart';
import '../../components/app_bar/button_action.dart';
import '../../components/circular_loading.dart';
import '../../components/dialogs/confirm_dialog.dart';
import '../../components/dialogs/error_dialog.dart';
import '../../components/dialogs/loading_dialog.dart';
import '../../components/images/image_loader_default.dart';
import '../../components/padding/padding_default.dart';
import '../../components/sized_box_default.dart';
import '../wishlist/components/wishlist_list_tile.dart';

class ProfilePage extends StatefulWidget {
  final UserViewModel viewModel;

  const ProfilePage({Key? key, required this.viewModel}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ProfilePresenter presenter = Get.find<GetxProfilePresenter>();

  TextTheme get textTheme => Theme.of(context).textTheme;

  @override
  void initState() {
    presenter.initialize(widget.viewModel).catchError((e) => ErrorDialog.show(context: context, content: e.toString()));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarDefault(
        title: R.string.profile,
        onBackPressed: () => Navigator.pop(context, presenter.verifyIsFriend),
        actions: [
          Obx(
            () => ButtonAction(
              visible: !presenter.loading && !presenter.verifyIsFriend,
              label: R.string.add,
              icon: Icons.person_add_outlined,
              iconSize: 22,
              onPressed: () async => await _addFriend(),
            ),
          ),
          Obx(
            () => ButtonAction(
              visible: !presenter.loading && presenter.verifyIsFriend,
              label: R.string.undo,
              icon: Icons.person_remove_outlined,
              iconSize: 22,
              onPressed: () async => await _undoFriend(),
            ),
          ),
        ],
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
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBoxDefault(1),
                            _photoProfile(),
                            const SizedBoxDefault(2),
                            Text(
                              widget.viewModel.name,
                              style: textTheme.headline5,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 5),
                            Text(
                              widget.viewModel.email,
                              style: textTheme.subtitle1?.copyWith(color: Colors.grey),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBoxDefault(3),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                R.string.wishlists,
                                style: textTheme.subtitle1?.copyWith(fontSize: 24),
                              ),
                            ),
                            const SizedBoxDefault(),
                            Obx(
                              () {
                                if (presenter.wishlists.isNotEmpty) {
                                  return ListView.separated(
                                    physics: const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: presenter.wishlists.length,
                                    separatorBuilder: (_, __) => const Divider(thickness: 1, height: 1),
                                    itemBuilder: (_, index) {
                                      final WishlistViewModel viewModel = presenter.wishlists[index];
                                      return WishlistListTile(
                                        viewModel: viewModel,
                                        onTap: () async => await _navigateWishlistDetails(viewModel),
                                      );
                                    },
                                  );
                                } else {
                                  return Column(
                                    children: [
                                      const SizedBoxDefault(2),
                                      const Icon(Icons.search_off_outlined, size: 36),
                                      const SizedBox(height: 5),
                                      Text(R.string.noneWishlists),
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
    );
  }

  //region Widgets

  Widget _photoProfile() {
    if (widget.viewModel.photo == null) {
      return CircleAvatar(
        radius: 70,
        backgroundColor: Theme.of(context).colorScheme.secondary,
        child: Text(
          widget.viewModel.name.characters.first,
          style: const TextStyle(fontSize: 70, color: Colors.white),
        ),
      );
    } else {
      return ImageLoaderDefault(
        image: widget.viewModel.photo!,
        height: 100,
        width: 100,
        radius: 500,
      );
    }
  }

  //endregion

  //region Eventos

  Future<void> _addFriend() async {
    try {
      await LoadingDialog.show(
        context: context,
        message: "${R.string.addingFriend}...",
        onAction: () async {
          await presenter.addFriend();
        },
      );
    } catch (e) {
      ErrorDialog.show(context: context, content: e.toString());
    }
  }

  Future<void> _undoFriend() async {
    try {
      final bool confirmed = await ConfirmDialog.show(
            context: context,
            title: R.string.undoFriend,
            message: R.string.undoFriendConfirm,
          ) ??
          false;

      if (!confirmed) return;

      await LoadingDialog.show(
        context: context,
        message: "${R.string.undoingFriend}...",
        onAction: () async {
          await presenter.undoFriend();
        },
      );
    } catch (e) {
      ErrorDialog.show(context: context, content: e.toString());
    }
  }

  Future<void> _navigateWishlistDetails(WishlistViewModel viewModel) async {
    await Navigator.pushNamed(context, wishlistDetailsRoute, arguments: viewModel.clone());
  }

//endregion
}
