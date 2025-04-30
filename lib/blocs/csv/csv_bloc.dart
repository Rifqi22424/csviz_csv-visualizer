import 'package:csviz/services/csv_parser_service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/csv_data.dart';

part 'csv_event.dart';
part 'csv_state.dart';

class CsvBloc extends Bloc<CsvEvent, CsvState> {
  final CsvParserService _parserService = CsvParserService();

  CsvBloc() : super(CsvInitialState()) {
    on<CsvUploadEvent>(_onCsvUpload);
    on<CsvClearEvent>(_onCsvClear);
  }
  Future<void> _onCsvUpload(
    CsvUploadEvent event,
    Emitter<CsvState> emit,
  ) async {
    emit(CsvLoadingState());

    try {
      final csvData = await _parserService.parserCsvFromBytes(event.fileBytes);
      if (csvData.isEmpty) {
        emit(
          CsvErrorState(message: 'The CSV file appears to be empty or invalid'),
        );
      } else {
        emit(CsvLoadedState(data: csvData, fileName: event.fileName));
      }
    } catch (e) {
      emit(CsvErrorState(message: 'Failed to parse CSV: ${e.toString()}'));
    }
  }

  void _onCsvClear(CsvClearEvent event, Emitter<CsvState> emit) {
    emit(CsvInitialState());
  }
}
