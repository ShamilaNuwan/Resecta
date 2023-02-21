import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:Resecta/models/project.dart';
import 'package:Resecta/views/widgets/fields/abstract_field.dart';

class TextFieldWidget extends AbstractFieldWidget {
  const TextFieldWidget(
      {Key? key, required int index, required ProjectField field})
      : super(key: key, index: index, field: field);

  @override
  Widget build(BuildContext context) {
    return FormBuilderTextField(
      name: fieldKey,
      minLines: 1,
      maxLines: 5,
      decoration: InputDecoration(
        label: Text(field.name),
        helperText: field.helperText,
        border: const OutlineInputBorder(),
      ),
      validator: buildValidators(context),
    );
  }
}
