import 'package:flutter/material.dart';
import 'package:Resecta/models/project.dart';
import 'package:Resecta/providers/sensor_provider.dart';
import 'package:Resecta/views/widgets/fields/abstract_series_field.dart';

class MotionSensorSeriesFieldWidget
    extends AbstractSeriesFieldWidget<MotionSensorData> {
  const MotionSensorSeriesFieldWidget(
      {Key? key, required int index, required ProjectField field})
      : super(key: key, index: index, field: field);

  @override
  Future<MotionSensorData?> collect() {
    return SensorProvider.getMotionSensorData();
  }
}
