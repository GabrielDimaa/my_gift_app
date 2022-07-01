import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../i18n/resources.dart';
import '../../../../viewmodels/tag_viewmodel.dart';
import '../../../components/form/text_field_default.dart';
import '../../../components/form/validators/input_validators.dart';
import '../../../components/sized_box_default.dart';

class TagForm extends StatelessWidget {
  final TagViewModel viewModel;
  final GlobalKey<FormState> formKeyTag;
  final TextEditingController _nameTagController = TextEditingController();

  TagForm({Key? key, required this.viewModel, required this.formKeyTag}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKeyTag,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFieldDefault(
            label: R.string.labelTag,
            hint: R.string.hintTag,
            controller: _nameTagController,
            onSaved: viewModel.setName,
            textInputAction: TextInputAction.done,
            keyboardType: TextInputType.text,
            validator: InputRequiredValidator().validate,
          ),
          const SizedBoxDefault(2),
          Padding(
            padding: const EdgeInsets.only(left: 6, bottom: 10),
            child: Text(R.string.colorTag),
          ),
          SizedBox(
            height: 120,
            child: GridView.builder(
              itemCount: colors.length,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 6,
                mainAxisSpacing: 10,
                crossAxisSpacing: 20,
              ),
              itemBuilder: (_, index) {
                return Obx(
                  () => RawMaterialButton(
                    shape: const CircleBorder(),
                    fillColor: Color(colors[index]),
                    child: colors[index] == viewModel.color ? const Icon(Icons.check, size: 28) : const SizedBox.shrink(),
                    onPressed: () => viewModel.setColor(colors[index]),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

const List<int> colors = [
  0xFF9800CD,
  0xFF04CBBC,
  0xFFF8C630,
  0xFFF85992,
  0xFF05299E,
  0xFFA0725F,
  0xFFFF4D00,
  0xFF099806,
  0xFFFFE600,
  0xFFE10252,
  0xFFFF2012,
  0xFF37FF16,
];
