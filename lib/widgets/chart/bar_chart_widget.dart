import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../models/csv_data.dart';

class BarChartWidget extends StatelessWidget {
  final CsvData csvData;
  final String xAxisColumn;
  final String yAxisColumn;
  final List<String>? seriesColumns;
  const BarChartWidget({
    super.key,
    required this.csvData,
    required this.xAxisColumn,
    required this.yAxisColumn,
    this.seriesColumns,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Expanded(
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: maxY,
                minY: 0,
                groupsSpace: 20,
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (group) => Colors.grey.shade800,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      String xValue = xValues[groupIndex].toString();
                      String yValue = rod.toY.toStringAsFixed(2);
                      String seriesName =
                          rodIndex == 0
                              ? yAxisColumn
                              : seriesColumns![rodIndex - 1];
                      return BarTooltipItem(
                        '$seriesName\n$xValue: $yValue',
                        const TextStyle(color: Colors.white),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: true),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: true),
                  ),
                  bottomTitles: AxisTitles(
                    axisNameWidget: Text(
                      xAxisColumn,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index >= 0 && index < xValues.length) {
                          return Padding(
                            padding: EdgeInsets.only(top: 8.0),
                            child: Text(
                              xValues[index].toString(),
                              style: const TextStyle(fontSize: 10),
                            ),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    axisNameWidget: Text(
                      yAxisColumn,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toStringAsFixed(1),
                          style: const TextStyle(fontSize: 10),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(color: Colors.grey.shade400),
                ),
                gridData: FlGridData(
                  show: true,
                  getDrawingHorizontalLine:
                      (value) =>
                          FlLine(color: Colors.grey.shade400, strokeWidth: 1),
                ),
                barGroups: getBarGroups(),
              ),
              duration: const Duration(microseconds: 500),
            ),
          ),
          if (seriesColumns != null && seriesColumns!.isNotEmpty)
            _buildLegend(context),
        ],
      ),
    );
  }

  List<dynamic> get xValues {
    return csvData.getColumnData(xAxisColumn);
  }

  List<double> _getDataValues(String columnName) {
    final data = csvData.getColumnData(columnName);
    return List.generate(
      data.length,
      (index) => num.tryParse(data[index].toString())?.toDouble() ?? 0.0,
    );
  }

  List<BarChartGroupData> getBarGroups() {
    final yValues = _getDataValues(yAxisColumn);
    final colors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.purple,
      Colors.orange,
    ];

    final hasMultipleSeries =
        seriesColumns != null && seriesColumns!.isNotEmpty;

    return List.generate(xValues.length, (index) {
      final List<BarChartRodData> bars = [];

      if (index < yValues.length) {
        bars.add(
          BarChartRodData(
            toY: yValues[index],
            color: colors[0],
            width: hasMultipleSeries ? 8 : 16,
          ),
        );
      }

      if (hasMultipleSeries) {
        for (var i = 0; i < seriesColumns!.length; i++) {
          final seriesData = _getDataValues(seriesColumns![i]);
          if (index < seriesData.length) {
            bars.add(
              BarChartRodData(
                toY: seriesData[index],
                color:
                    colors[i + 1 < colors.length
                        ? i + 1
                        : (i + 1) % colors.length],
              ),
            );
          }
        }
      }

      return BarChartGroupData(
        x: index,
        groupVertically: !hasMultipleSeries,
        barRods: bars,
      );
    });
  }

  double get maxY {
    List<double> allValues = _getDataValues(yAxisColumn);

    if (seriesColumns != null) {
      for (var column in seriesColumns!) {
        allValues.addAll(_getDataValues(column));
      }
    }

    final max =
        allValues.isEmpty ? 10.0 : allValues.reduce((a, b) => a > b ? a : b);

    return max + (max * 0.1);
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
          _buildLegendItem(context, yAxisColumn, colors[0]),
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

  Widget _buildLegendItem(BuildContext context, String label, color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
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
