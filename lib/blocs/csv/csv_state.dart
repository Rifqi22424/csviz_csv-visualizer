part of 'csv_bloc.dart';

@immutable
sealed class CsvState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CsvInitialState extends CsvState {}

class CsvLoadingState extends CsvState {}

class CsvLoadedState extends CsvState {
  final CsvData data;
  final String fileName;

  CsvLoadedState({required this.data, required this.fileName});

  @override
  List<Object?> get props => [data, fileName];
}

class CsvErrorState extends CsvState {
  final String message;

  CsvErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}
