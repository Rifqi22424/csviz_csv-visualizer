import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../models/csv_data.dart';

class PieChartWidget extends StatelessWidget {
  final CsvData csvData;
  final String labelColumn;
  final String valueColumn;
  final Map<String, dynamic>? additionalConfig;
  const PieChartWidget({
    super.key,
    required this.csvData,
    required this.labelColumn,
    required this.valueColumn,
    this.additionalConfig,
  });

  @override
  Widget build(BuildContext context) {
    // final bool showValues = additionalConfig?['showValues'] ?? true;
    final bool showLegend = additionalConfig?['showLegend'] ?? true;

    final sections = _getSections();

    return Column(
      children: [
        Expanded(
          child: PieChart(
            PieChartData(
              sections: sections,
              centerSpaceRadius: 40,
              sectionsSpace: 2,
              pieTouchData: PieTouchData(),
              borderData: FlBorderData(show: false),
            ),
            duration: const Duration(milliseconds: 500),
          ),
        ),
        if (showLegend && sections.isNotEmpty)
          SizedBox(
            height: 120,
            child: ListView(
              scrollDirection: Axis.vertical,
              children: _buildLegendItems(context),
            ),
          ),
      ],
    );
  }

  List<PieChartSectionData> _getSections() {
    final labels = csvData.getColumnData(labelColumn);
    final values = csvData.getColumnData(valueColumn);

    final pieData = <String, double>{};
    final bool showValues = additionalConfig?['showValues'] ?? true;

    for (var i = 0; i < labels.length && i < values.length; i++) {
      final label = labels[i].toString();
      final value = num.tryParse(values[i].toString());

      if (value != null && value > 0) {
        if (pieData.containsKey(label)) {
          pieData[label] = pieData[label]! + value.toDouble();
        } else {
          pieData[label] = value.toDouble();
        }
      }
    }

    final colors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.purple,
      Colors.orange,
      Colors.teal,
      Colors.pink,
      Colors.amber,
      Colors.cyan,
      Colors.indigo,
    ];

    final sections = <PieChartSectionData>[];
    int colorIndex = 0;

    pieData.forEach((label, value) {
      final color = colors[colorIndex % colors.length];
      colorIndex++;

      sections.add(
        PieChartSectionData(
          value: value,
          title: showValues ? value.toStringAsFixed(1) : '',
          color: color,
          radius: 100,
          titleStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 12,
          ),
        ),
      );
    });

    return sections;
  }

  List<Widget> _buildLegendItems(BuildContext context) {
    final labels = csvData.getColumnData(labelColumn);
    final values = csvData.getColumnData(valueColumn);

    final legendData = <String, dynamic>{};

    for (var i = 0; i < labels.length && i < values.length; i++) {
      final label = labels[i].toString();
      final value = num.tryParse(values[i].toString());

      if (value != null && value > 0) {
        if (legendData.containsKey(label)) {
          legendData[label] = legendData[label]! + value.toDouble();
        } else {
          legendData[label] + value.toDouble();
        }
      }
    }

    final total = legendData.values.fold(0.0, (sum, value) => sum + value);

    final colors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.purple,
      Colors.orange,
      Colors.teal,
      Colors.pink,
      Colors.amber,
      Colors.cyan,
      Colors.indigo,
    ];

    final items = <Widget>[];
    int colorIndex = 0;

    legendData.forEach((label, value) {
      final color = colors[colorIndex % colors.length];
      colorIndex++;

      final percentage =
          total > 0 ? (value / total * 100).toStringAsFixed(1) : '0.0';

      items.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),

          child: Row(
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                '$percentage% (${value.toStringAsFixed(1)})',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
              ),
            ],
          ),
        ),
      );
    });

    return items;
  }
}
