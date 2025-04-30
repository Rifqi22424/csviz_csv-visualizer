import 'package:csviz/blocs/chart/chart_bloc.dart';
import 'package:csviz/blocs/csv/csv_bloc.dart';
import 'package:csviz/blocs/export/export_bloc.dart';
import 'package:csviz/helper/platform_helper.dart';
import 'package:csviz/helper/responsive_helper.dart';
import 'package:csviz/models/chart_type.dart';
import 'package:csviz/widgets/chart/bar_chart_widget.dart';
import 'package:csviz/widgets/chart/line_chart_widget.dart';
import 'package:csviz/widgets/chart/pie_chart_widget.dart';
import 'package:csviz/widgets/chart/radar_chart_widget.dart';
import 'package:csviz/widgets/chart/scatter_chart_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class ChartDisplayScreen extends StatefulWidget {
  const ChartDisplayScreen({super.key});

  @override
  State<ChartDisplayScreen> createState() => _ChartDisplayScreenState();
}

class _ChartDisplayScreenState extends State<ChartDisplayScreen> {
  final ScreenshotController _screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    bool isPhone = ResponsiveHelper.isPhone(context);
    bool isSupportFileSharing =
        PlatformHelper.isWeb ||
        PlatformHelper.isWindows ||
        PlatformHelper.isMacOS ||
        PlatformHelper.isLinux;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chart Visualization'),
        actions: [
          IconButton(
            onPressed: () => _captureAndSaveChart(context),
            icon: Icon(Icons.save_alt),
            tooltip: 'Save chart as image',
          ),
          isSupportFileSharing
              ? SizedBox()
              : IconButton(
                onPressed: () => _captureAndShareChart(context),
                icon: Icon(Icons.share),
                tooltip: 'Share chart',
              ),
        ],
      ),
      body: BlocListener<ExportBloc, ExportState>(
        listener: (context, state) {
          if (state is ExportSuccessState) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Chart saved to gallery')));
          } else if (state is ExportErrorState) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: Padding(
          padding: isPhone ? EdgeInsets.zero : const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildChartTitle(),
              const SizedBox(height: 24),
              Expanded(
                child: Screenshot(
                  controller: _screenshotController,
                  child: Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: _buildChart(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChartTitle() {
    final chartState = context.read<ChartBloc>().state;

    if (chartState is ChartConfiguredState) {
      final chartType = chartState.chartType.name;
      final xAxis = chartState.xAxisColumn;
      final yAxis = chartState.yAxisColumn;

      return Column(
        children: [
          Text(
            chartType,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'X-Axis: $xAxis | Y-Axis: $yAxis',
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildChart() {
    final chartState = context.read<ChartBloc>().state;
    final csvState = context.read<CsvBloc>().state;

    if (chartState is ChartConfiguredState && csvState is CsvLoadedState) {
      switch (chartState.chartType) {
        case ChartType.line:
          return LineChartWidget(
            csvData: csvState.data,
            xAxisColumn: chartState.xAxisColumn,
            yAxisColumn: chartState.yAxisColumn,
            seriesColumns: chartState.seriesColumn,
          );
        case ChartType.bar:
          return BarChartWidget(
            csvData: csvState.data,
            xAxisColumn: chartState.xAxisColumn,
            yAxisColumn: chartState.yAxisColumn,
            seriesColumns: chartState.seriesColumn,
          );
        case ChartType.pie:
          return PieChartWidget(
            csvData: csvState.data,
            labelColumn: chartState.xAxisColumn,
            valueColumn: chartState.yAxisColumn,
            additionalConfig: chartState.additionalConfig,
          );
        case ChartType.scatter:
          return ScatterChartWidget(
            csvData: csvState.data,
            xAxisColumn: chartState.xAxisColumn,
            yAxisColumn: chartState.yAxisColumn,
          );
        case ChartType.radar:
          return RadarChartWidget(
            csvData: csvState.data,
            featureColumn: chartState.xAxisColumn,
            valueColumn: chartState.yAxisColumn,
            seriesColumns: chartState.seriesColumn,
          );
      }
    }

    return const Center(child: Text('Chart configuration not available'));
  }

  Future<void> _captureAndSaveChart(BuildContext context) async {
    final csvState = context.read<CsvBloc>().state;
    final chartState = context.read<ChartBloc>().state;

    if (csvState is CsvLoadedState && chartState is ChartConfiguredState) {
      try {
        final bytes = await _screenshotController.capture();
        if (bytes != null) {
          final fileName =
              '${chartState.chartType.name}_${csvState.fileName.split('.').first}';
          context.read<ExportBloc>().add(
            ExportChartEvent(imageBytes: bytes, fileName: fileName),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to capture chart: $e')));
      }
    }
  }

  Future<void> _captureAndShareChart(BuildContext context) async {
    final csvState = context.read<CsvBloc>().state;
    final chartState = context.read<ChartBloc>().state;

    if (csvState is CsvLoadedState && chartState is ChartConfiguredState) {
      try {
        final bytes = await _screenshotController.capture();
        if (bytes != null) {
          final fileName =
              '${chartState.chartType.name}_${csvState.fileName.split('.').first}';
          final tempDir = await context.read<ExportBloc>().saveChart(
            bytes,
            fileName,
          );
          await SharePlus.instance.share(
            ShareParams(
              text: 'Check out this chart created with CSV Visualizer',
              files: [XFile(tempDir)],
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to share chart: $e')));
      }
    }
  }
}
