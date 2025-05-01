import 'package:csviz/blocs/csv/csv_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CsvUploadWidget extends StatelessWidget {
  const CsvUploadWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () => _pickCsvFile(context),
              label: const Text('Select CSV File'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                foregroundColor: Theme.of(context).colorScheme.primary,
                // backgroundColor: Colors.white
              ),
              icon: const Icon(Icons.upload_file),
            ),
            const SizedBox(width: 4),
            ElevatedButton.icon(
              onPressed: () => _playDemo(context),
              label: const Text('Try A Demo!'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                iconColor: Colors.white,
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white
              ),
              icon: const Icon(Icons.play_circle_fill),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Text(
          'Supported format: CSV files with headers in the first row',
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }

  Future<void> _pickCsvFile(BuildContext context) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
        withData: true,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        if (file.bytes != null && file.name.isNotEmpty) {
          context.read<CsvBloc>().add(
            CsvUploadEvent(fileBytes: file.bytes!, fileName: file.name),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error selecting file: $e')));
    }
  }

  Future<void> _playDemo(BuildContext context) async {
    try {
      final byteData = await rootBundle.load('assets/example.csv');
      final fileBytes = byteData.buffer.asUint8List();

      context.read<CsvBloc>().add(
        CsvUploadEvent(fileBytes: fileBytes, fileName: 'example.csv'),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error loading file assets: $e')));
    }
  }
}
