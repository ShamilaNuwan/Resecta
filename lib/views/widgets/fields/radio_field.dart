import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:z_collector_app/models/project.dart';
import 'package:z_collector_app/views/widgets/fields/abstract_field.dart';

class RadioFieldWidget extends AbstractFieldWidget {
  const RadioFieldWidget(
      {Key? key, required int index, required ProjectField field})
      : super(key: key, index: index, field: field);

  @override
  Widget build(BuildContext context) {
    return FormBuilderRadioGroup(
      name: fieldKey,
      decoration: InputDecoration(
        label: Text(field.name),
        helperText: field.helperText,
        border: const OutlineInputBorder(),
      ),
      validator: buildValidators(context),
      options: [
        for (int i = 0; i < (field.options?.length ?? 0); i++)
          FormBuilderFieldOption<int>(
            value: i,
            child: Text(field.options?[i] ?? 'Not provided'),
          )
      ],
    );
  }
}
