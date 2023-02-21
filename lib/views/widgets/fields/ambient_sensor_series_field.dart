import 'package:flutter/material.dart';
import 'package:z_collector_app/models/project.dart';
import 'package:z_collector_app/providers/sensor_provider.dart';
import 'package:z_collector_app/views/widgets/fields/abstract_series_field.dart';

class AmbientSensorSeriesFieldWidget
    extends AbstractSeriesFieldWidget<AmbientSensorData> {
  const AmbientSensorSeriesFieldWidget(
      {Key? key, required int index, required ProjectField field})
      : super(key: key, index: index, field: field);

  @override
  Future<AmbientSensorData?> collect() {
    return SensorProvider.getAmbientSensorData();
  }
}
