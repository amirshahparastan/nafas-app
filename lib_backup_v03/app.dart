import 'package:flutter/material.dart';
import 'core/state/app_state.dart';
import 'core/theme/nafas_theme.dart';
import 'features/achievements/achievements_screen.dart';
import 'features/craving/craving_screen.dart';
import 'features/home/main_shell.dart';
import 'features/onboarding/onboarding_screen.dart';
import 'features/settings/settings_screen.dart';
import 'features/slip/slip_screen.dart';

class NafasBootstrap extends StatefulWidget {
  const NafasBootstrap({super.key});
  @override
  State<NafasBootstrap> createState() => _NafasBootstrapState();
}

class _NafasBootstrapState extends State<NafasBootstrap> {
  final state = NafasAppState();
  @override
  void dispose() { state.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) => NafasScope(state: state, child: const NafasApp());
}

class NafasApp extends StatelessWidget {
  const NafasApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'نفس',
      theme: NafasTheme.light,
      locale: const Locale('fa'),
      builder: (context, child) => Directionality(textDirection: TextDirection.rtl, child: child ?? const SizedBox.shrink()),
      home: const _Gate(),
      routes: {
        '/craving': (_) => const CravingScreen(),
        '/settings': (_) => const SettingsScreen(),
        '/achievements': (_) => const AchievementsScreen(),
        '/slip': (_) => const SlipScreen(),
      },
    );
  }
}

class _Gate extends StatelessWidget {
  const _Gate();
  @override
  Widget build(BuildContext context) {
    final state = NafasScope.of(context);
    return state.onboardingComplete ? const MainShell() : const OnboardingScreen();
  }
}
