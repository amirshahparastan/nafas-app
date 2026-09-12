import 'package:flutter/material.dart';
import 'core/state/app_state.dart';
import 'core/theme/nafas_colors.dart';
import 'core/theme/nafas_theme.dart';
import 'core/widgets/nafas_logo.dart';
import 'features/achievements/achievements_screen.dart';
import 'features/calendar/quit_calendar_screen.dart';
import 'features/craving/craving_screen.dart';
import 'features/help/help_safety_screen.dart';
import 'features/home/main_shell.dart';
import 'features/journal/journal_screen.dart';
import 'features/onboarding/onboarding_screen.dart';
import 'features/settings/about_screen.dart';
import 'features/settings/account_screen.dart';
import 'features/settings/feedback_screen.dart';
import 'features/settings/notification_settings_screen.dart';
import 'features/settings/privacy_policy_screen.dart';
import 'features/settings/privacy_settings_screen.dart';
import 'features/settings/settings_screen.dart';
import 'features/settings/smoking_settings_screen.dart';
import 'features/settings/support_screen.dart';
import 'features/settings/terms_screen.dart';
import 'features/slip/slip_screen.dart';

class NafasBootstrap extends StatefulWidget {
  const NafasBootstrap({super.key});

  @override
  State<NafasBootstrap> createState() => _NafasBootstrapState();
}

class _NafasBootstrapState extends State<NafasBootstrap> {
  final state = NafasAppState();

  @override
  void initState() {
    super.initState();
    state.hydrate();
  }

  @override
  void dispose() {
    state.dispose();
    super.dispose();
  }

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
      locale: const Locale('fa', 'IR'),
      builder: (context, child) => Directionality(
        textDirection: TextDirection.rtl,
        child: child ?? const SizedBox.shrink(),
      ),
      home: const _Gate(),
      routes: {
        '/craving': (_) => const CravingScreen(),
        '/settings': (_) => const SettingsScreen(),
        '/account': (_) => const AccountScreen(),
        '/smoking-settings': (_) => const SmokingSettingsScreen(),
        '/notification-settings': (_) => const NotificationSettingsScreen(),
        '/privacy-settings': (_) => const PrivacySettingsScreen(),
        '/feedback': (_) => const FeedbackScreen(),
        '/support': (_) => const SupportScreen(),
        '/about': (_) => const AboutScreen(),
        '/privacy-policy': (_) => const PrivacyPolicyScreen(),
        '/terms': (_) => const TermsScreen(),
        '/achievements': (_) => const AchievementsScreen(),
        '/slip': (_) => const SlipScreen(),
        '/calendar': (_) => const QuitCalendarScreen(),
        '/journal': (_) => const JournalScreen(),
        '/help': (_) => const HelpSafetyScreen(),
      },
    );
  }
}

class _Gate extends StatelessWidget {
  const _Gate();

  @override
  Widget build(BuildContext context) {
    final state = NafasScope.of(context);
    if (!state.hydrated) return const _StartupScreen();
    return state.onboardingComplete ? const MainShell() : const OnboardingScreen();
  }
}

class _StartupScreen extends StatelessWidget {
  const _StartupScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Color(0xFFFFFAF1), Color(0xFFF1F8F5), Color(0xFFF1F4FF)],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 82,
                height: 82,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: const [BoxShadow(color: Color(0x18083B34), blurRadius: 30, offset: Offset(0, 14))],
                ),
                clipBehavior: Clip.antiAlias,
                child: Image.asset('assets/branding/nafas_app_icon_1024.png', fit: BoxFit.cover),
              ),
              const SizedBox(height: 18),
              const NafasLogo(),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                decoration: BoxDecoration(color: NafasColors.sunSoft, borderRadius: BorderRadius.circular(99)),
                child: const Text('آرام، شخصی، بدون قضاوت', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w800, color: NafasColors.money)),
              ),
              const SizedBox(height: 10),
              Text('در حال آماده‌کردن مسیرت...', style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 22),
              const SizedBox(width: 150, child: LinearProgressIndicator(minHeight: 5)),
            ],
          ),
        ),
      ),
    );
  }
}
