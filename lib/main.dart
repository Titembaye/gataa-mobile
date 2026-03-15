import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/auth_service.dart';
import 'features/splash/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final authService = AuthService();
  await authService.init();
  
  runApp(
    ChangeNotifierProvider.value(
      value: authService,
      child: const GataaApp(),
    ),
  );
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