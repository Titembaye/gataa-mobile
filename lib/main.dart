import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
//import 'features/prices/prices_screen.dart';
//import 'shared/widgets/main_navigation.dart';
import 'features/splash/splash_screen.dart';

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
      home: const SplashScreen(),
    );
  }
}