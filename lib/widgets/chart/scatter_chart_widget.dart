import 'package:csviz/models/csv_data.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ScatterChartWidget extends StatelessWidget {
  final CsvData csvData;
  final String xAxisColumn;
  final String yAxisColumn;
  const ScatterChartWidget({
    super.key,
    required this.csvData,
    required this.xAxisColumn,
    required this.yAxisColumn,
  });

  @override
  Widget build(BuildContext context) {
    final spots = _getSpots();

    if (spots.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.scatter_plot, size: 48, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No data to display',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(top: 16.0, right: 16.0),
      child: ScatterChart(
        ScatterChartData(
          scatterSpots: spots,
          minX: minX,
          maxX: maxX,
          minY: minY,
          maxY: maxY,
          borderData: FlBorderData(
            show: true,
            border: Border.all(color: Colors.grey.shade400),
          ),
          gridData: FlGridData(
            show: true,
            getDrawingHorizontalLine:
                (value) => FlLine(color: Colors.grey.shade300, strokeWidth: 1),
            getDrawingVerticalLine:
                (value) => FlLine(color: Colors.grey.shade300, strokeWidth: 1),
          ),
          titlesData: FlTitlesData(
            show: true,
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              axisNameWidget: Text(
                xAxisColumn,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toStringAsFixed(1),
                    style: const TextStyle(fontSize: 10),
                  );
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
          scatterTouchData: ScatterTouchData(
            enabled: true,
            touchTooltipData: ScatterTouchTooltipData(
              getTooltipColor: (touchedSpot) => Colors.blueGrey.shade800,
              getTooltipItems: (touchedSpot) {
                return ScatterTooltipItem(
                  'X: ${touchedSpot.x.toStringAsFixed(2)}\nY: ${touchedSpot.y.toStringAsFixed(2)}',
                  textStyle: const TextStyle(color: Colors.white),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  List<ScatterSpot> _getSpots() {
    final xData = csvData.getColumnData(xAxisColumn);
    final yData = csvData.getColumnData(yAxisColumn);
    final spots = <ScatterSpot>[];

    for (var i = 0; i < xData.length && i < yData.length; i++) {
      final xValue = num.tryParse(xData[i].toString());
      final yValue = num.tryParse(yData[i].toString());

      if (xValue != null && yValue != null) {
        spots.add(
          ScatterSpot(
            xValue.toDouble(),
            yValue.toDouble(),
            dotPainter: FlDotCirclePainter(color: Colors.blue, radius: 8),
          ),
        );
      }
    }

    return spots;
  }

  double get minX {
    final xValues =
        csvData
            .getColumnData(xAxisColumn)
            .map((e) => num.tryParse(e.toString()))
            .where((e) => e != null)
            .map((e) => e!.toDouble())
            .toList();

    if (xValues.isEmpty) return 0;
    final min = xValues.reduce((a, b) => a < b ? a : b);
    return min - (min.abs() * 0.1);
  }

  double get maxX {
    final xValues =
        csvData
            .getColumnData(xAxisColumn)
            .map((e) => num.tryParse(e.toString()))
            .where((e) => e != null)
            .map((e) => e!.toDouble())
            .toList();

    if (xValues.isEmpty) return 10;
    final max = xValues.reduce((a, b) => a > b ? a : b);
    return max + (max.abs() * 0.1);
  }

  double get minY {
    final yValues =
        csvData
            .getColumnData(yAxisColumn)
            .map((e) => num.tryParse(e.toString()))
            .where((e) => e != null)
            .map((e) => e!.toDouble())
            .toList();

    if (yValues.isEmpty) return 0;
    final min = yValues.reduce((a, b) => a < b ? a : b);
    return min - (min.abs() * 0.1);
  }

  double get maxY {
    final yValues =
        csvData
            .getColumnData(yAxisColumn)
            .map((e) => num.tryParse(e.toString()))
            .where((e) => e != null)
            .map((e) => e!.toDouble())
            .toList();

    if (yValues.isEmpty) return 10;
    final max = yValues.reduce((a, b) => a > b ? a : b);
    return max + (max.abs() * 0.1);
  }
}
