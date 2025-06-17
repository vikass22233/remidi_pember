import 'package:flutter/material.dart';
import 'screens/home.dart';
import 'screens/input_data.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      initialRoute: '/',
      routes: {
        '/': (context) =>  HomePage(),
        '/input_data': (context) =>  TambahDataPage(),
      },
    );
  }
}
