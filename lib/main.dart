import 'package:flutter/material.dart';

import 'pages/home_page.dart';

void main() {
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Diu Bus Tracker',
      theme: ThemeData(
        useMaterial3: false,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          titleTextStyle: TextStyle(
            fontSize: 24,
            color: Colors.black,
          ),
        ),
      ),
      home: const HomePage(),
    );
  }
}
