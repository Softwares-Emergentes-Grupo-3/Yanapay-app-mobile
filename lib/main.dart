import 'package:flutter/material.dart';
import 'package:yanapay_app_mobile/config/theme/app_theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme().theme(),
      home: const Scaffold(
        // appBar: AppBar(
        //   title: const Text('Flutter App'),
        // ),
        body: Center(
          child: Text('Hello, Flutter!'),
        ),
      ),
    );
  }
}
