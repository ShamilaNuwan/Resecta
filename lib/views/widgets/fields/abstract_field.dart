import 'package:flutter/material.dart';
import 'package:Resecta/models/project.dart';
import 'package:Resecta/views/widgets/fields/base_field_utils.dart';

abstract class AbstractFieldWidget extends StatelessWidget {
  final int index;
  final ProjectField field;

  const AbstractFieldWidget(
      {Key? key, required this.index, required this.field})
      : super(key: key);

  FormFieldValidator<T>? buildValidators<T>(BuildContext context) {
    return BaseFieldUtils.buildValidators(context, field);
  }

  String get fieldKey => index.toString();
}
