import 'package:csviz/blocs/chart/chart_bloc.dart';
import 'package:csviz/blocs/csv/csv_bloc.dart';
import 'package:csviz/blocs/export/export_bloc.dart';
import 'package:csviz/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CsvBloc>(create: (context) => CsvBloc()),
        BlocProvider<ExportBloc>(create: (context) => ExportBloc()),
        BlocProvider<ChartBloc>(create: (context) => ChartBloc()),
      ],
      child: MaterialApp(
        title: 'CSV Visualizer',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: HomeScreen(),
      ),
    );
  }
}
