import 'package:csviz/blocs/chart/chart_bloc.dart';
import 'package:csviz/models/chart_type.dart';
import 'package:csviz/models/csv_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChartConfigDialog extends StatefulWidget {
  final ChartType chartType;
  final CsvData csvData;
  const ChartConfigDialog({
    super.key,
    required this.chartType,
    required this.csvData,
  });

  @override
  State<ChartConfigDialog> createState() => _ChartConfigDialogState();
}

class _ChartConfigDialogState extends State<ChartConfigDialog> {
  String? xAxisColumn;
  String? yAxisColumn;
  List<String> selectedSeriesColumns = [];
  Map<String, dynamic> additionalConfig = {};

  @override
  void initState() {
    super.initState();
    if (widget.csvData.categoricalColumns.isNotEmpty) {
      xAxisColumn = widget.csvData.categoricalColumns.first;
    } else if (widget.csvData.headers.isNotEmpty) {
      xAxisColumn = widget.csvData.headers.first;
    }

    if (widget.csvData.numericColumns.isNotEmpty) {
      yAxisColumn = widget.csvData.numericColumns.first;
    } else if (widget.csvData.headers.length > 1) {
      yAxisColumn = widget.csvData.headers[1];
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Configure ${widget.chartType.name}'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDropdown(
              label: 'X-Axis Column: ',
              value: xAxisColumn,
              items: widget.csvData.headers,
              onChanged: (value) {
                setState(() => xAxisColumn = value);
              },
            ),
            const SizedBox(height: 16),
            _buildDropdown(
              label: 'Y-Axis Column: ',
              value: yAxisColumn,
              items:
                  widget.csvData.numericColumns.isEmpty
                      ? widget.csvData.headers
                      : widget.csvData.numericColumns,
              onChanged: (value) {
                setState(() => yAxisColumn = value);
              },
            ),
            if (widget.chartType == ChartType.line ||
                widget.chartType == ChartType.bar)
              _buildMultiSelect(),
            if (widget.chartType == ChartType.pie) _buildColorSelection(),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed:
              xAxisColumn != null && yAxisColumn != null
                  ? () {
                    context.read<ChartBloc>().add(
                      ChartConfigureEvent(
                        xAxisColumn: xAxisColumn!,
                        yAxisColumn: yAxisColumn!,
                        seriesColumn:
                            selectedSeriesColumns.isNotEmpty
                                ? selectedSeriesColumns
                                : null,
                        additionalConfig:
                            additionalConfig.isNotEmpty
                                ? additionalConfig
                                : null,
                      ),
                    );
                    Navigator.of(context).pop();
                  }
                  : null,
          child: const Text('Create Chart'),
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        DropdownButton<String>(
          value: value,
          isExpanded: true,
          items:
              items.map((item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item, overflow: TextOverflow.ellipsis),
                );
              }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildMultiSelect() {
    final availableColumns =
        widget.csvData.numericColumns
            .where((col) => col != yAxisColumn)
            .toList();

    if (availableColumns.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        const Text(
          'Additional Data Series (Optional):',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...availableColumns.map((column) {
          final isSelected = selectedSeriesColumns.contains(column);
          return CheckboxListTile(
            title: Text(column, overflow: TextOverflow.ellipsis),
            value: isSelected,
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
            dense: true,
            onChanged: (checked) {
              setState(() {
                if (checked == true) {
                  selectedSeriesColumns.add(column);
                } else {
                  selectedSeriesColumns.remove(column);
                }
              });
            },
          );
        }),
      ],
    );
  }

  Widget _buildColorSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        const Text(
          'Display Options:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        SwitchListTile(
          title: const Text('Show Values'),
          contentPadding: EdgeInsets.zero,
          value: additionalConfig['showValues'] ?? true,
          onChanged: (value) {
            setState(() {
              additionalConfig['showValues'] = value;
            });
          },
        ),
        SwitchListTile(
          title: const Text('Show Legend'),
          contentPadding: EdgeInsets.zero,
          value: additionalConfig['showLegend'] ?? true,
          onChanged: (value) {
            setState(() {
              additionalConfig['showLegend'] = value;
            });
          },
        ),
      ],
    );
  }
}
