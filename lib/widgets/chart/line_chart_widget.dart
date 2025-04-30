import 'package:csviz/models/csv_data.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineChartWidget extends StatelessWidget {
  final CsvData csvData;
  final String xAxisColumn;
  final String yAxisColumn;
  final List<String>? seriesColumns;
  const LineChartWidget({
    super.key,
    required this.csvData,
    required this.xAxisColumn,
    required this.yAxisColumn,
    this.seriesColumns,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, right: 16),
      child: Column(
        children: [
          Expanded(
            child: LineChart(
              LineChartData(
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((spot) {
                        return LineTooltipItem(
                          '${spot.y}',
                          const TextStyle(color: Colors.white),
                        );
                      }).toList();
                    },
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: true,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(color: Colors.grey.shade300, strokeWidth: 1);
                  },
                  getDrawingVerticalLine: (value) {
                    return FlLine(color: Colors.grey.shade300, strokeWidth: 1);
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
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
                minX: 0,
                maxX: xValues.length.toDouble() - 1,
                minY: minY,
                maxY: maxY,
                lineBarsData: getLineBarsData(),
              ),
              duration: const Duration(milliseconds: 500),
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

  List<FlSpot> _getSpots(String columnName) {
    final yData = csvData.getColumnData(columnName);
    final xData = xValues;
    final spots = <FlSpot>[];

    for (var i = 0; i < xData.length && i < yData.length; i++) {
      final yValue = num.tryParse(yData[i].toString());
      if (yValue != null) {
        spots.add(FlSpot(i.toDouble(), yValue.toDouble()));
      }
    }
    return spots;
  }

  List<LineChartBarData> getLineBarsData() {
    final List<LineChartBarData> lines = [];

    lines.add(
      LineChartBarData(
        spots: _getSpots(yAxisColumn),
        isCurved: true,
        color: Colors.blue,
        barWidth: 3,
        isStrokeCapRound: true,
        dotData: FlDotData(show: true),
        belowBarData: BarAreaData(show: true),
      ),
    );

    if (seriesColumns != null) {
      final colors = [
        Colors.red,
        Colors.green,
        Colors.purple,
        Colors.orange,
        Colors.teal,
      ];

      for (var i = 0; i < seriesColumns!.length; i++) {
        final seriesColumn = seriesColumns![i];
        final color = i < colors.length ? colors[i] : colors[i % colors.length];

        lines.add(
          LineChartBarData(
            spots: _getSpots(seriesColumn),
            isCurved: true,
            color: color,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(show: true),
            belowBarData: BarAreaData(show: true),
          ),
        );
      }
    }

    return lines;
  }

  double get minY {
    List<double> allValues =
        _getSpots(yAxisColumn).map((spot) => spot.y).toList();

    if (seriesColumns != null) {
      for (var column in seriesColumns!) {
        allValues.addAll(_getSpots(column).map((spot) => spot.y));
      }
    }

    return allValues.isEmpty
        ? 0
        : allValues.reduce((min, value) => min < value ? min : value) - 1;
  }

  double get maxY {
    List<double> allValues =
        _getSpots(yAxisColumn).map((spot) => spot.y).toList();

    if (seriesColumns != null) {
      for (var column in seriesColumns!) {
        allValues.addAll(_getSpots(column).map((spot) => spot.y));
      }
    }

    return allValues.isEmpty
        ? 10
        : allValues.reduce((max, value) => max > value ? max : value) + 1;
  }

  Widget _buildLegend(BuildContext context) {
    final colors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.purple,
      Colors.orange,
      Colors.teal,
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
