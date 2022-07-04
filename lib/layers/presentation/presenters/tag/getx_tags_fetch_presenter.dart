import 'package:get/get.dart';

import '../../../../i18n/resources.dart';
import '../../../../monostates/user_global.dart';
import '../../../domain/entities/tag_entity.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../domain/helpers/errors/domain_error.dart';
import '../../../domain/usecases/abstracts/tag/i_delete_tag.dart';
import '../../../domain/usecases/abstracts/tag/i_get_tags.dart';
import '../../../domain/usecases/abstracts/tag/i_save_tag.dart';
import '../../helpers/mixins/loading_manager.dart';
import '../../viewmodels/tag_viewmodel.dart';
import 'tags_fetch_presenter.dart';

class GetxTagsFetchPresenter extends GetxController with LoadingManager implements TagsFetchPresenter {
  final IGetTags _getTags;
  final ISaveTag _saveTag;
  final IDeleteTag _deleteTag;

  GetxTagsFetchPresenter({
    required IGetTags getTags,
    required ISaveTag saveTag,
    required IDeleteTag deleteTag,
  })  : _getTags = getTags,
        _saveTag = saveTag,
        _deleteTag = deleteTag;

  final RxList<TagViewModel> _viewModel = RxList<TagViewModel>();
  late UserEntity _user;

  @override
  List<TagViewModel> get viewModel => _viewModel;

  @override
  void setViewModel(List<TagViewModel> value) => _viewModel.value = value;

  @override
  Future<void> initialize([_]) async {
    try {
      setLoading(true);

      _user = UserGlobal().getUser()!;

      List<TagEntity> tags = await _getTags.get(_user.id!);
      setViewModel(tags.map((e) => TagViewModel.fromEntity(e)).toList());

      _sort();
    } on DomainError catch (e) {
      throw Exception(e.message);
    } finally {
      setLoading(false);
    }
  }

  @override
  Future<void> save(TagViewModel viewModel) async {
    try {
      validate(viewModel);

      final TagEntity tagEntitySaved = await _saveTag.save(viewModel.toEntity(_user));
      final TagViewModel viewModelSaved = TagViewModel.fromEntity(tagEntitySaved);

      if (viewModel.id != null) {
        int index = _viewModel.indexWhere((e) => e.id == viewModel.id);
        _viewModel[index] = viewModelSaved;
      } else {
        _viewModel.add(viewModelSaved);
      }

      _sort();
    } on DomainError catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Future<void> delete(TagViewModel viewModel) async {
    try {
      if (viewModel.id == null) return;

      await _deleteTag.delete(viewModel.id!);
      _viewModel.removeWhere((e) => e.id == viewModel.id);
    } on DomainError catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  void validate(TagViewModel viewModel) {
    if (viewModel.name?.isEmpty ?? true) throw Exception(R.string.nameTagNotInformedError);
    if (viewModel.color == null) throw Exception(R.string.colorTagNotInformedError);
  }

  void _sort() => _viewModel.sort((a, b) => a.name.toString().toLowerCase().compareTo(b.name.toString().toLowerCase()));
}
