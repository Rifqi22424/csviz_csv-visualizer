import 'package:csviz/models/csv_data.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class RadarChartWidget extends StatelessWidget {
  final CsvData csvData;
  final String featureColumn;
  final String valueColumn;
  final List<String>? seriesColumns;

  const RadarChartWidget({
    super.key,
    required this.csvData,
    required this.featureColumn,
    required this.valueColumn,
    this.seriesColumns,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: RadarChart(
              RadarChartData(
                radarBorderData: const BorderSide(color: Colors.transparent),
                tickBorderData: const BorderSide(color: Colors.grey),
                gridBorderData: BorderSide(
                  color: Colors.grey.shade300,
                  width: 1,
                ),
                radarBackgroundColor: Colors.transparent,
                ticksTextStyle: const TextStyle(
                  color: Colors.black,
                  fontSize: 10,
                ),
                titleTextStyle: const TextStyle(
                  color: Colors.black,
                  fontSize: 10,
                ),
                dataSets: _getDataSets(),
                tickCount: 5,
                radarShape: RadarShape.polygon,
                titlePositionPercentageOffset: 0.1,
                borderData: FlBorderData(show: true),
                getTitle: (index, angle) {
                  return RadarChartTitle(text: features[index] , angle: angle);
                },
              ),
            ),
          ),
        ),
        if (seriesColumns != null && seriesColumns!.isNotEmpty)
          _buildLegend(context),
      ],
    );
  }

  List<String> get features {
    return csvData
        .getColumnData(featureColumn)
        .map((e) => e.toString())
        .toList();
  }

  List<RadarDataSet> _getDataSets() {
    final List<RadarDataSet> dataSets = [];
    final colors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.purple,
      Colors.orange,
    ];
    dataSets.add(_createDataSet(valueColumn, colors[0]));

    if (seriesColumns != null) {
      for (var i = 0; i < seriesColumns!.length; i++) {
        final color =
            i + 1 < colors.length
                ? colors[i + 1]
                : colors[(i + 1) % colors.length];
        dataSets.add(_createDataSet(seriesColumns![i], color));
      }
    }

    return dataSets;
  }

  RadarDataSet _createDataSet(String column, Color color) {
    final values = csvData.getColumnData(column);
    final dataPoints = <RadarEntry>[];

    for (var i = 0; i < values.length && i < features.length; i++) {
      final value = num.tryParse(values[i].toString());
      if (value != null) {
        dataPoints.add(RadarEntry(value: value.toDouble()));
      } else {
        dataPoints.add(const RadarEntry(value: 0));
      }
    }

    return RadarDataSet(
      dataEntries: dataPoints,
      fillColor: color.withAlpha((0.2 * 255).round()),
      borderColor: color,
      borderWidth: 2,
    );
  }

  Widget _buildLegend(BuildContext context) {
    final colors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.purple,
      Colors.orange,
    ];

    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Wrap(
        spacing: 16,
        runSpacing: 8,
        alignment: WrapAlignment.center,
        children: [
          _buildLegendItem(context, valueColumn, colors[0]),
          if (seriesColumns != null)
            ...List.generate(seriesColumns!.length, (index) {
              final color =
                  index + 1 < colors.length
                      ? colors[index + 1]
                      : colors[(index + 1) % colors.length];
              return _buildLegendItem(context, seriesColumns![index], color);
            }),
        ],
      ),
    );
  }

  Widget _buildLegendItem(BuildContext context, String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).textTheme.bodyMedium?.color,
          ),
        ),
      ],
    );
  }
}
