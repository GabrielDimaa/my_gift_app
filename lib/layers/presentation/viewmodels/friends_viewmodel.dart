import 'package:get/get_rx/src/rx_types/rx_types.dart';

import '../../domain/entities/friends_entity.dart';
import 'user_viewmodel.dart';

class FriendsViewModel {
  final RxList<UserViewModel> _friends = RxList<UserViewModel>();

  List<UserViewModel> get friends => _friends;

  void setFriends(List<UserViewModel> value) => _friends.value = value;

  FriendsViewModel({required List<UserViewModel> friends}) {
    _friends.value = friends;
  }

  factory FriendsViewModel.fromEntity(FriendsEntity entity) {
    return FriendsViewModel(friends: entity.friends.map((e) => UserViewModel.fromEntity(e)).toList());
  }
}
