part of 'csv_bloc.dart';

@immutable
sealed class CsvEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class CsvUploadEvent extends CsvEvent {
  final List<int> fileBytes;
  final String fileName;

  CsvUploadEvent({required this.fileBytes, required this.fileName});

  @override
  List<Object> get props => [fileBytes, fileName];
}

class CsvClearEvent extends CsvEvent {}
