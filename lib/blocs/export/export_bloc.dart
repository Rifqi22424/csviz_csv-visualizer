import 'dart:typed_data';

import 'package:csviz/services/chart_export_service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'export_event.dart';
part 'export_state.dart';

class ExportBloc extends Bloc<ExportEvent, ExportState> {
  final ChartExportService _exportService = ChartExportService();

  ExportBloc() : super(ExportInitialState()) {
    on<ExportChartEvent>(_onExportChart);
  }

  Future<String> saveChart(Uint8List bytes, String fileName) async {
    return await _exportService.saveChartImage(bytes, fileName);
  }

  Future<void> _onExportChart(
    ExportChartEvent event,
    Emitter<ExportState> emit,
  ) async {
    emit(ExportLoadingState());
    try {
      final path = await _exportService.saveChartImage(
        event.imageBytes,
        event.fileName,
      );
      emit(ExportSuccessState(filePath: path));
    } catch (e) {
      emit(
        ExportErrorState(message: 'Failed to export chart: ${e.toString()}'),
      );
    }
  }
}
