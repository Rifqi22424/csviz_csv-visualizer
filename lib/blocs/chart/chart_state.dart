part of 'chart_bloc.dart';

@immutable
sealed class ChartState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ChartInitialState extends ChartState {}

class ChartTypeSelectedState extends ChartState {
  final ChartType chartType;

  ChartTypeSelectedState({required this.chartType});

  @override
  List<Object?> get props => [chartType];
}

class ChartConfiguredState extends ChartState {
  final ChartType chartType;
  final String xAxisColumn;
  final String yAxisColumn;
  final List<String>? seriesColumn;
  final Map<String, dynamic>? additionalConfig;

  ChartConfiguredState({
    required this.chartType,
    required this.xAxisColumn,
    required this.yAxisColumn,
    required this.seriesColumn,
    required this.additionalConfig,
  });

  @override
  List<Object?> get props => [
    chartType,
    xAxisColumn,
    yAxisColumn,
    seriesColumn,
    additionalConfig,
  ];
}
