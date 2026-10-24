import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_theme.dart';
import 'providers/expense_provider.dart';
import 'screens/home_screen.dart';
import 'services/storage_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final provider = ExpenseProvider(StorageService());
  await provider.load();

  runApp(
    ChangeNotifierProvider.value(
      value: provider,
      child: const PennyPilotApp(),
    ),
  );
}

class PennyPilotApp extends StatelessWidget {
  const PennyPilotApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PennyPilot',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const HomeScreen(),
    );
  }
}