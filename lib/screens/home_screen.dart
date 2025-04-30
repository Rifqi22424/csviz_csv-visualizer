import 'package:csviz/blocs/csv/csv_bloc.dart';
import 'package:csviz/screens/chart_selection_screen.dart';
import 'package:csviz/widgets/csv_upload_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CSVIZ - CSV Visualizer'), elevation: 2),
      body: BlocConsumer<CsvBloc, CsvState>(
        listener: (context, state) {
          if (state is CsvErrorState) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          } else if (state is CsvLoadedState) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const ChartSelectionScreen(),
              ),
            );
          }
        },
        builder: (context, state) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.insert_chart_outlined,
                    size: 100,
                    color: Colors.blue,
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'CSVIZ - CSV Visualizer',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Upload a CSV file to visualize your data with different chart types',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 40),
                  if (state is CsvLoadingState)
                    const CircularProgressIndicator()
                  else
                    const CsvUploadWidget(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
