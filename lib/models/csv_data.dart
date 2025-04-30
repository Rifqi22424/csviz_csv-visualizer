class CsvData {
  final List<String> headers;
  final List<List<dynamic>> rows;

  CsvData({required this.headers, required this.rows});

  bool get isEmpty => headers.isEmpty || rows.isEmpty;
  int get rowCount => rows.length;
  int get columnCount => headers.length;

  List<dynamic> getColumnData(String header) {
    final index = headers.indexOf(header);
    if (index == -1) return [];
    return rows.map((row) => row.length > index ? row[index] : null).toList();
  }

  List<String> get numericColumns {
    return headers.where((header) {
      final data = getColumnData(header);
      return data.isNotEmpty &&
          data
              .where((value) => value != null)
              .every((value) => num.tryParse(value.toString()) != null);
    }).toList();
  }

  List<String> get categoricalColumns {
    return headers.where((header) => !numericColumns.contains(header)).toList();
  }
}
