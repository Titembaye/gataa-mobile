import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';

void main() {
  runApp(const GataaApp());
}

class GataaApp extends StatelessWidget {
  const GataaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gataa',
      debugShowCheckedModeBanner: false,
      theme: GataaTheme.light,
      home: const Scaffold(
        body: Center(
          child: Text(
            'Gataa',
            style: TextStyle(
              fontFamily: 'DM Sans',
              fontSize: 26,
              fontWeight: FontWeight.w500,
              color: Color(0xFF0F2540),
            ),
          ),
        ),
      ),
    );
  }
}