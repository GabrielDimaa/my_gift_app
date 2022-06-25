import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/instance_manager.dart';

import '../../../../../i18n/resources.dart';
import '../../../presenters/friend/friends_presenter.dart';
import '../../../presenters/friend/getx_friends_presenter.dart';
import '../../../viewmodels/user_viewmodel.dart';
import '../../components/app_bar/app_bar_default.dart';
import '../../components/app_bar/button_action.dart';
import '../../components/circular_loading.dart';
import '../../components/dialogs/confirm_dialog.dart';
import '../../components/dialogs/error_dialog.dart';
import '../../components/dialogs/loading_dialog.dart';
import '../../components/images/image_loader_default.dart';
import '../../components/not_found.dart';
import '../../components/padding/padding_default.dart';
import '../../components/sized_box_default.dart';

class FriendsPage extends StatefulWidget {
  const FriendsPage({Key? key}) : super(key: key);

  @override
  State<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  final FriendsPresenter presenter = Get.find<GetxFriendsPresenter>();

  @override
  void initState() {
    presenter.initialize().catchError((e) => ErrorDialog.show(context: context, content: e.toString()));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarDefault(
        title: R.string.friends,
        actions: [
          ButtonAction(
            icon: Icons.person_search_outlined,
            iconSize: 22,
            label: R.string.searchFriend,
            onPressed: () {},
          )
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const PaddingDefault(),
          child: Column(
            children: [
              const SizedBoxDefault(2),
              Expanded(
                child: Obx(
                  () {
                    if (presenter.loading) {
                      return const CircularLoading();
                    } else {
                      if (presenter.viewModel.friends.isNotEmpty) {
                        return ListView.separated(
                          padding: EdgeInsets.zero,
                          separatorBuilder: (_, __) => const Divider(thickness: 1, height: 1),
                          itemCount: presenter.viewModel.friends.length,
                          itemBuilder: (_, index) {
                            final UserViewModel friend = presenter.viewModel.friends[index];
                            return ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: ImageLoaderDefault(
                                image: friend.photo!,
                                height: 50,
                                width: 50,
                                radius: 500,
                              ),
                              title: Text(friend.shortName),
                              trailing: IconButton(
                                icon: Icon(Icons.person_remove_outlined, color: Theme.of(context).colorScheme.primary),
                                tooltip: R.string.undoFriend,
                                onPressed: () async => await _undoFriend(friend.id),
                              ),
                            );
                          },
                        );
                      } else {
                        return NotFound(message: R.string.noneFriendAdd);
                      }
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

  Future<void> _undoFriend(String friendUserId) async {
    try {
      final bool confirmed = await ConfirmDialog.show(
            context: context,
            title: R.string.undoFriend,
            message: R.string.undoFriendConfirm,
          ) ??
          false;

      if (!confirmed) return;

      await LoadingDialog.show(context: context, message: "${R.string.undoingFriend}...", onAction: () async => await presenter.undoFriend(friendUserId));
    } catch (e) {
      ErrorDialog.show(context: context, content: e.toString());
    }
  }
}
