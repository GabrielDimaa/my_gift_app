import '../../helpers/interfaces/i_initialize.dart';
import '../../helpers/interfaces/i_loading.dart';
import '../../helpers/interfaces/i_view_model.dart';
import '../../viewmodels/user_viewmodel.dart';

abstract class UserEditProfilePresenter implements IViewModel<UserViewModel>, IInitialize<UserViewModel>, ILoading {
  Future<void> getFromCameraOrGallery({bool isGallery = true});
  Future<void> save();
  void validate();
}