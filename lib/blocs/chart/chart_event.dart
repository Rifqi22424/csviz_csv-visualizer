part of 'chart_bloc.dart';

@immutable
sealed class ChartEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class ChartTypeSelectedEvent extends ChartEvent {
  final ChartType chartType;

  ChartTypeSelectedEvent({required this.chartType});

  @override
  List<Object?> get props => [chartType];
}

class ChartConfigureEvent extends ChartEvent {
  final String xAxisColumn;
  final String yAxisColumn;
  final List<String>? seriesColumn;
  final Map<String, dynamic>? additionalConfig;

  ChartConfigureEvent({
    required this.xAxisColumn,
    required this.yAxisColumn,
    this.seriesColumn,
    this.additionalConfig,
  });

  @override
  List<Object?> get props => [
    xAxisColumn,
    yAxisColumn,
    seriesColumn,
    additionalConfig,
  ];
}

class ChartResetEvent extends ChartEvent {

}
