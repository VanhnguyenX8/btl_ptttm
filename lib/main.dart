import 'package:btl_ptttm/app/bloc/bloc.dart';
import 'package:btl_ptttm/app/screen/Traffic.widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Provider<TrafficBloc>(
      create: (context) => TrafficBloc(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Nhan dien bien bao giao thong',
        theme: ThemeData(
          useMaterial3: true,
        ),
        home: const TrafficWidget(),
      ),
    );
  }
}
