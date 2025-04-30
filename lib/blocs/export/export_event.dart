part of 'export_bloc.dart';

@immutable
sealed class ExportEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class ExportChartEvent extends ExportEvent {
  final Uint8List imageBytes;
  final String fileName;

  ExportChartEvent({required this.imageBytes, required this.fileName});
}
