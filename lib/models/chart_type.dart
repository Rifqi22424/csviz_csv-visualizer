import 'package:flutter/material.dart';

enum ChartType { line, bar, pie, scatter, radar }

extension ChartTypeExtension on ChartType {
  String get name {
    switch (this) {
      case ChartType.line:
        return "Line Chart";
      case ChartType.bar:
        return "Bar Chart";
      case ChartType.pie:
        return "Pie Chart";
      case ChartType.scatter:
        return "Scatter Chart";
      case ChartType.radar:
        return "Radar Chart";
    }
  }

  IconData get icon {
    switch (this) {
      case ChartType.line:
        return Icons.show_chart;
      case ChartType.bar:
        return Icons.bar_chart;
      case ChartType.pie:
        return Icons.pie_chart;
      case ChartType.scatter:
        return Icons.scatter_plot;
      case ChartType.radar:
        return Icons.radar;
    }
  }
}
