import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/chart_type.dart';

part 'chart_event.dart';
part 'chart_state.dart';

class ChartBloc extends Bloc<ChartEvent, ChartState> {
  ChartBloc() : super(ChartInitialState()) {
    on<ChartTypeSelectedEvent>(_onChartTypeSelected);
    on<ChartConfigureEvent>(_onChartConfigure);
    on<ChartResetEvent>(_onChartReset);
  }

  void _onChartTypeSelected(
    ChartTypeSelectedEvent event,
    Emitter<ChartState> emit,
  ) {
    emit(ChartTypeSelectedState(chartType: event.chartType));
  }

  void _onChartConfigure(ChartConfigureEvent event, Emitter<ChartState> emit) {
    if (state is ChartTypeSelectedState) {
      final chartType = (state as ChartTypeSelectedState).chartType;
      emit(
        ChartConfiguredState(
          chartType: chartType,
          xAxisColumn: event.xAxisColumn,
          yAxisColumn: event.yAxisColumn,
          seriesColumn: event.seriesColumn,
          additionalConfig: event.additionalConfig,
        ),
      );
    }
  }

  void _onChartReset(ChartResetEvent event, Emitter<ChartState> emit) {
    emit(ChartInitialState());
  }
}