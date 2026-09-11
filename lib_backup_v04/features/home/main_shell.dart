import 'package:flutter/material.dart';
import '../../core/state/app_state.dart';
import '../../core/theme/nafas_colors.dart';
import '../community/community_screen.dart';
import '../goal/goal_screen.dart';
import '../health/health_screen.dart';
import '../stats/stats_screen.dart';
import 'dashboard_screen.dart';

class MainShell extends StatelessWidget {
  const MainShell({super.key});

  static const screens = [
    DashboardScreen(),
    HealthScreen(),
    CommunityScreen(),
    GoalScreen(),
    StatsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final state = NafasScope.of(context);
    return Scaffold(
      body: IndexedStack(index: state.selectedMainTab, children: screens),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          margin: const EdgeInsets.fromLTRB(12, 0, 12, 9),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: .98),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: Colors.white),
            boxShadow: const [
              BoxShadow(color: Color(0x1A083B34), blurRadius: 34, offset: Offset(0, 13)),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: NavigationBar(
              selectedIndex: state.selectedMainTab,
              onDestinationSelected: state.setTab,
              destinations: const [
                NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home_rounded), label: 'خانه'),
                NavigationDestination(icon: Icon(Icons.favorite_border_rounded), selectedIcon: Icon(Icons.favorite_rounded), label: 'سلامت'),
                NavigationDestination(icon: Icon(Icons.volunteer_activism_outlined), selectedIcon: Icon(Icons.volunteer_activism_rounded), label: 'امید'),
                NavigationDestination(icon: Icon(Icons.flag_outlined), selectedIcon: Icon(Icons.flag_rounded), label: 'هدف'),
                NavigationDestination(icon: Icon(Icons.bar_chart_rounded), selectedIcon: Icon(Icons.analytics_rounded), label: 'آمار'),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: state.selectedMainTab != 0 && state.selectedMainTab != 2
          ? FloatingActionButton.extended(
              onPressed: () => Navigator.pushNamed(context, '/craving'),
              backgroundColor: NafasColors.accent,
              foregroundColor: Colors.white,
              elevation: 5,
              icon: const Icon(Icons.air_rounded),
              label: const Text('هوس کردم', style: TextStyle(fontWeight: FontWeight.w900)),
            )
          : null,
    );
  }
}
