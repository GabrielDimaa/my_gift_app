import '../../helpers/interfaces/i_initialize.dart';
import '../../helpers/interfaces/i_loading.dart';
import '../../helpers/interfaces/i_view_model.dart';
import '../../viewmodels/tag_viewmodel.dart';

abstract class TagsFetchPresenter implements IInitialize, IViewModel<List<TagViewModel>>, ILoading {
  Future<void> save(TagViewModel viewModel);
  Future<void> delete(TagViewModel viewModel);
  void validate(TagViewModel viewModel);
}