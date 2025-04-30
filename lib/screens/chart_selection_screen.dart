import 'package:csviz/blocs/chart/chart_bloc.dart';
import 'package:csviz/blocs/csv/csv_bloc.dart';
import 'package:csviz/helpers/responsive_helper.dart';
import 'package:csviz/models/chart_type.dart';
import 'package:csviz/screens/chart_display_screen.dart';
import 'package:csviz/widgets/chart_config_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChartSelectionScreen extends StatelessWidget {
  const ChartSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Chart Type')),
      body: BlocConsumer<ChartBloc, ChartState>(
        listener: (context, state) {
          if (state is ChartTypeSelectedState) {
            _showChartConfigDialog(context, state.chartType);
          } else if (state is ChartConfiguredState) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const ChartDisplayScreen(),
              ),
            );
          }
        },
        builder: (context, state) {
          return Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildFileInfo(context),
                const SizedBox(height: 24),
                const Text(
                  'Select a chart type:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: ResponsiveHelper.responsiveAxisCountGrid(
                      context,
                    ),
                    childAspectRatio: 1.2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    children:
                        ChartType.values
                            .map((type) => _buildChartTypeCard(context, type))
                            .toList(),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFileInfo(BuildContext context) {
    final csvState = context.read<CsvBloc>().state;

    if (csvState is CsvLoadedState) {
      return Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'File: ${csvState.fileName}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text('Rows: ${csvState.data.rowCount}'),
              Text('Columns: ${csvState.data.columnCount}'),
              const SizedBox(height: 8),
              Text(
                'Headers: ${csvState.data.headers.join(", ")}',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildChartTypeCard(BuildContext context, ChartType chartType) {
    return Card(
      elevation: 3,
      child: InkWell(
        onTap: () {
          context.read<ChartBloc>().add(
            ChartTypeSelectedEvent(chartType: chartType),
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              chartType.icon,
              size: 48,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(height: 12),
            Text(
              chartType.name,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  void _showChartConfigDialog(BuildContext context, ChartType chartType) {
    final csvState = context.read<CsvBloc>().state;

    if (csvState is CsvLoadedState) {
      showDialog(
        context: context,
        builder:
            (context) =>
                ChartConfigDialog(chartType: chartType, csvData: csvState.data),
      );
    }
  }
}
