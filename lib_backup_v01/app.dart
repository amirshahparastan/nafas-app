import 'package:flutter/material.dart';
import 'core/theme/nafas_theme.dart';
import 'features/craving/craving_screen.dart';
import 'features/home/main_shell.dart';
import 'features/settings/settings_screen.dart';

class NafasApp extends StatelessWidget {
  const NafasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'نفس',
      theme: NafasTheme.light,
      locale: const Locale('fa'),
      builder: (context, child) => Directionality(
        textDirection: TextDirection.rtl,
        child: child ?? const SizedBox.shrink(),
      ),
      initialRoute: '/',
      routes: {
        '/': (_) => const MainShell(),
        '/craving': (_) => const CravingScreen(),
        '/settings': (_) => const SettingsScreen(),
      },
    );
  }
}
