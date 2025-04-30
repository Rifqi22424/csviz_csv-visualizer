part of 'export_bloc.dart';

@immutable
sealed class ExportState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ExportInitialState extends ExportState {}

class ExportLoadingState extends ExportState {}

class ExportSuccessState extends ExportState {
  final String filePath;

  ExportSuccessState({required this.filePath});

  @override
  List<Object?> get props => [filePath];
}

class ExportErrorState extends ExportState {
  final String message;

  ExportErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}
