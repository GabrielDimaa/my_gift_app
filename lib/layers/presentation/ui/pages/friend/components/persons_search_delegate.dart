import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../../../../../i18n/resources.dart';
import '../../../../../../routes/routes.dart';
import '../../../../presenters/friend/friends_presenter.dart';
import '../../../../viewmodels/user_viewmodel.dart';
import '../../../components/bottom_sheet/confirm_bottom_sheet.dart';
import '../../../components/circular_loading.dart';
import '../../../components/dialogs/error_dialog.dart';
import '../../../components/dialogs/loading_dialog.dart';
import '../../../components/sized_box_default.dart';
import 'person_list_tile.dart';

class PersonsSearchDelegate extends SearchDelegate {
  final FriendsPresenter presenter;

  PersonsSearchDelegate({required this.presenter});

  static Future<void> search({required BuildContext context, required FriendsPresenter presenter}) async {
    await showSearch(context: context, delegate: PersonsSearchDelegate(presenter: presenter));
  }

  @override
  String? get searchFieldLabel => "${R.string.search}...";

  @override
  ThemeData appBarTheme(BuildContext context) {
    var theme = Theme.of(context);
    var colorScheme = theme.colorScheme;

    return theme.copyWith(
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.background,
        iconTheme: theme.primaryIconTheme.copyWith(color: colorScheme.onBackground),
        toolbarHeight: 70,
      ),
      textTheme: TextTheme(titleLarge: TextStyle(color: colorScheme.onBackground, fontSize: 18)),
      inputDecorationTheme: InputDecorationTheme(
        isDense: true,
        hintStyle: theme.inputDecorationTheme.hintStyle?.copyWith(fontSize: 18, color: Colors.grey),
        border: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: colorScheme.onBackground)),
        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: colorScheme.onBackground)),
      ),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        padding: EdgeInsets.zero,
        splashRadius: 30,
        icon: const Icon(Icons.clear, color: Colors.grey),
        tooltip: R.string.clear,
        onPressed: () {
          query = "";
          showSuggestions(context);
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      padding: EdgeInsets.zero,
      iconSize: 30,
      splashRadius: 30,
      icon: const Icon(Icons.keyboard_backspace),
      onPressed: () => close(context, null),
      tooltip: R.string.back,
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<List<UserViewModel>>(
      future: presenter.fetchSearchPersons(query),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const CircularLoading();
          default:
            if (snapshot.hasError || snapshot.data == null || snapshot.data!.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Visibility(
                      visible: query.isNotEmpty,
                      replacement: buildSuggestions(context),
                      child: Column(
                        children: [
                          const Icon(Icons.warning_amber_outlined, size: 38),
                          const SizedBoxDefault(),
                          Text("${R.string.messageNotFoundSearchDelegate} \"$query\"."),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            } else {
              final List<UserViewModel> persons = snapshot.data!;
              return ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 10),
                separatorBuilder: (_, __) => const Divider(thickness: 1, height: 1),
                itemCount: persons.length,
                itemBuilder: (_, index) {
                  final UserViewModel person = persons[index];
                  return Obx(
                    () => PersonListTile(
                      person: person,
                      isAddFriend: !presenter.viewModel.personIsFriend(person),
                      onPressedTrailing: () async {
                        if (presenter.viewModel.personIsFriend(person)) {
                          await _undoFriend(context: context, friendUserId: person.id);
                        } else {
                          await _addFriend(context: context, person: person);
                        }
                      },
                      onTapTile: () async => await _navigateProfile(context, person),
                    ),
                  );
                },
              );
            }
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          R.string.findPeople,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 4),
        Text(
          R.string.messageSearchDelegate,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 16, color: Colors.grey[400]),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Future<void> _addFriend({required BuildContext context, required UserViewModel person}) async {
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

  Future<void> _undoFriend({required BuildContext context, required String friendUserId}) async {
    try {
      final mounted = context.mounted;

      final bool confirmed = await ConfirmBottomSheet.show(
        context: context,
        title: R.string.undoFriend,
        message: R.string.undoFriendConfirm,
      );

      if (!confirmed || !mounted) return;

      await LoadingDialog.show(
        context: context,
        message: "${R.string.undoingFriend}...",
        onAction: () async => await presenter.undoFriend(friendUserId),
      );
    } catch (e) {
      ErrorDialog.show(context: context, content: e.toString());
    }
  }

  Future<void> _navigateProfile(BuildContext context, UserViewModel person) async {
    //Retorna alguma ação na tela de perfil. (add/undo)
    final bool? add = await Navigator.pushNamed(context, profileRoute, arguments: person) as bool?;

    if (add != null) {
      if (add) {
        presenter.viewModel.friends.addAllIf(!presenter.viewModel.personIsFriend(person), [person]);
      } else {
        presenter.viewModel.friends.removeWhere((e) => e.id == person.id);
      }
    }
  }
}
