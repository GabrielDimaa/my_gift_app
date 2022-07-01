import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../i18n/resources.dart';
import '../../../../../routes/routes.dart';
import '../../../presenters/friend/friends_presenter.dart';
import '../../../presenters/friend/getx_friends_presenter.dart';
import '../../../viewmodels/user_viewmodel.dart';
import '../../components/app_bar/app_bar_default.dart';
import '../../components/app_bar/button_action.dart';
import '../../components/bottom_sheet/confirm_bottom_sheet.dart';
import '../../components/circular_loading.dart';
import '../../components/dialogs/error_dialog.dart';
import '../../components/dialogs/loading_dialog.dart';
import '../../components/not_found.dart';
import '../../components/sized_box_default.dart';
import 'components/person_list_tile.dart';
import 'components/persons_search_delegate.dart';

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
            onPressed: () async => PersonsSearchDelegate.search(context: context, presenter: presenter),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBoxDefault(2),
            Expanded(
              child: Obx(
                () {
                  if (presenter.loading) {
                    return const CircularLoading();
                  } else {
                    return RefreshIndicator(
                      onRefresh: presenter.getFriends,
                      child: Obx(
                        () {
                          if (presenter.viewModel.friends.isNotEmpty) {
                            return ListView.separated(
                              padding: EdgeInsets.zero,
                              separatorBuilder: (_, __) => const Divider(thickness: 1, height: 1),
                              itemCount: presenter.viewModel.friends.length,
                              itemBuilder: (_, index) {
                                final UserViewModel friend = presenter.viewModel.friends[index];
                                return PersonListTile(
                                  person: friend,
                                  isAddFriend: !presenter.viewModel.personIsFriend(friend),
                                  onPressedTrailing: () async {
                                    if (presenter.viewModel.personIsFriend(friend)) {
                                      await _undoFriend(friend.id);
                                    } else {
                                      await _addFriend(friend);
                                    }
                                  },
                                  onTapTile: () async => await _navigateProfile(friend),
                                );
                              },
                            );
                          } else {
                            return NotFound(message: R.string.noneFriendAdd);
                          }
                        }
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addFriend(UserViewModel person) async {
    try {
      await LoadingDialog.show(
        context: context,
        message: "${R.string.addingFriend}...",
        onAction: () async => await presenter.addFriend(person),
      );
    } catch (e) {
      ErrorDialog.show(context: context, content: e.toString());
    }
  }

  Future<void> _undoFriend(String friendUserId) async {
    try {
      final bool confirmed = await ConfirmBottomSheet.show(
            context: context,
            title: R.string.undoFriend,
            message: R.string.undoFriendConfirm,
          );

      if (!confirmed) return;

      await LoadingDialog.show(
        context: context,
        message: "${R.string.undoingFriend}...",
        onAction: () async => await presenter.undoFriend(friendUserId),
      );
    } catch (e) {
      ErrorDialog.show(context: context, content: e.toString());
    }
  }

  Future<void> _navigateProfile(UserViewModel person) async {
    try {
      await Navigator.pushNamed(context, profileRoute, arguments: person);

      presenter.setLoading(true);
      await presenter.getFriends();
    } catch (e) {
      ErrorDialog.show(context: context, content: e.toString());
    } finally {
      presenter.setLoading(false);
    }
  }
}
