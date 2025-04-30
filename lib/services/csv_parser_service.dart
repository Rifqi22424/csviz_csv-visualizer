import 'dart:convert';
import 'package:csv/csv.dart';
import '../models/csv_data.dart';

class CsvParserService {
  Future<CsvData> parserCsvFromBytes(List<int> bytes) async {
    try {
      final csvString = utf8.decode(bytes);
      final csvConverter = const CsvToListConverter();
      final List<List<dynamic>> parsedData = csvConverter.convert(csvString);

      if (parsedData.isEmpty) {
        return CsvData(headers: [], rows: []);
      }

      final headers = List<String>.from(parsedData[0].map((e) => e.toString()));
      final rows = parsedData.sublist(1);

      return CsvData(headers: headers, rows: rows);
    } catch (e) {
      throw Exception('Error parsing CSV: ${e.toString()}');
    }
  }
}
