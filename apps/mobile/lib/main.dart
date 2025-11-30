import 'package:flutter/material.dart';
import 'design/app_theme.dart';
import 'features/demo/demo_screen.dart';

void main() {
  runApp(const RepGoApp());
}

class RepGoApp extends StatelessWidget {
  const RepGoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RepGo',
      theme: AppTheme.light(),
      home: const DemoScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
