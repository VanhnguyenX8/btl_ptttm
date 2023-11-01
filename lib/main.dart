import 'package:btl_ptttm/app/database/database.dart';
import 'package:btl_ptttm/app/screen/traffic_widget.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final sqfliteDatabase = SqfliteDatabase();
  await sqfliteDatabase.initDb();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Nhan dien bien bao giao thong',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const TrafficWidget(),
    );
  }
}
