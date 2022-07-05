import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/instance_manager.dart';

import '../../../../../i18n/resources.dart';
import '../../../presenters/tag/getx_tags_fetch_presenter.dart';
import '../../../presenters/tag/tags_fetch_presenter.dart';
import '../../../viewmodels/tag_viewmodel.dart';
import '../../components/app_bar/app_bar_default.dart';
import '../../components/bottom_sheet/bottom_sheet_default.dart';
import '../../components/bottom_sheet/confirm_bottom_sheet.dart';
import '../../components/button/fab_default.dart';
import '../../components/button/save_button.dart';
import '../../components/circular_loading.dart';
import '../../components/dialogs/error_dialog.dart';
import '../../components/dialogs/loading_dialog.dart';
import '../../components/dismissible_default.dart';
import '../../components/not_found.dart';
import '../../components/padding/padding_default.dart';
import '../../components/sized_box_default.dart';
import 'components/tag_form.dart';

class TagsFetchPage extends StatefulWidget {
  const TagsFetchPage({Key? key}) : super(key: key);

  @override
  State<TagsFetchPage> createState() => _TagsFetchPageState();
}

class _TagsFetchPageState extends State<TagsFetchPage> {
  final TagsFetchPresenter presenter = Get.find<GetxTagsFetchPresenter>();

  @override
  void initState() {
    presenter.initialize().catchError((e) => ErrorDialog.show(context: context, content: e.toString()));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarDefault(title: R.string.tags),
      floatingActionButton: FABDefault(
        icon: Icons.add,
        onPressed: () async => await _saveTag(null),
        tooltip: R.string.createTag,
      ),
      body: SafeArea(
        child: Padding(
          padding: const PaddingDefault(),
          child: Obx(
            () {
              if (presenter.loading) {
                return const CircularLoading();
              } else {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBoxDefault(2),
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: presenter.fetch,
                        child: Obx(
                          () {
                            if (presenter.viewModel.isNotEmpty) {
                              return ListView.separated(
                                separatorBuilder: (_, __) => const Divider(thickness: 1, height: 1),
                                itemCount: presenter.viewModel.length,
                                itemBuilder: (_, index) {
                                  final TagViewModel tag = presenter.viewModel[index];
                                  return DismissibleDefault<TagViewModel>(
                                    valueKey: tag,
                                    onDismissed: (_) {},
                                    confirmDismiss: (_) async => await _delete(tag),
                                    child: Obx(
                                          () => ListTile(
                                        onTap: () async => await _saveTag(tag),
                                        contentPadding: EdgeInsets.zero,
                                        minLeadingWidth: 0,
                                        leading: Icon(Icons.label_important_outline, color: Color(tag.color!)),
                                        title: Text(tag.name!),
                                        trailing: IconButton(
                                          onPressed: () async => await _delete(tag),
                                          icon: const Icon(Icons.delete_outline),
                                          color: Colors.redAccent,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            } else {
                              return NotFound(message: R.string.noneTagRegister);
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Future<void> _saveTag(TagViewModel? tag) async {
    final GlobalKey<FormState> formKeyTag = GlobalKey<FormState>();
    final TagViewModel clone = tag?.clone() ?? TagViewModel();

    try {
      await BottomSheetDefault.show(
        context: context,
        isScrollControlled: true,
        title: clone.id == null ? R.string.createTag : R.string.editTag,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBoxDefault(),
            TagForm(viewModel: clone, formKeyTag: formKeyTag),
            const SizedBoxDefault(3),
            SaveButton(
              onPressed: () async {
                try {
                  if (!presenter.loading && formKeyTag.currentState!.validate()) {
                    formKeyTag.currentState!.save();

                    await LoadingDialog.show(
                      context: context,
                      message: "${R.string.savingTag}...",
                      onAction: () async => await presenter.save(clone),
                    );

                    if (!mounted) return;
                    Navigator.pop(context);
                  }
                } catch (e) {
                  ErrorDialog.show(context: context, content: e.toString());
                }
              },
            ),
          ],
        ),
      );
    } catch (e) {
      ErrorDialog.show(context: context, content: e.toString());
    }
  }

  Future<bool> _delete(TagViewModel tag) async {
    try {
      final bool confirmed = await ConfirmBottomSheet.show(context: context, title: R.string.delete, message: R.string.confirmDeleteTag);
      if (confirmed) {
        await LoadingDialog.show(
          context: context,
          message: "${R.string.deletingTag}...",
          onAction: () async => await presenter.delete(tag),
        );
      }

      return confirmed;
    } catch (e) {
      ErrorDialog.show(context: context, content: e.toString());
      return false;
    }
  }
}
