import 'package:flutter/material.dart';
import '../../core/theme/nafas_colors.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تنظیمات')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _Item(icon: Icons.smoke_free_outlined, title: 'اطلاعات مصرف سیگار'),
          _Item(icon: Icons.savings_outlined, title: 'هدف مالی'),
          _Item(icon: Icons.notifications_none_rounded, title: 'اعلان‌ها و یادآوری‌ها'),
          _Item(icon: Icons.palette_outlined, title: 'ظاهر برنامه'),
          _Item(icon: Icons.lock_outline_rounded, title: 'حریم خصوصی'),
          _Item(icon: Icons.info_outline_rounded, title: 'درباره نفس'),
        ],
      ),
    );
  }
}

class _Item extends StatelessWidget {
  const _Item({required this.icon, required this.title});
  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: NafasColors.surfaceSoft,
          foregroundColor: NafasColors.primary,
          child: Icon(icon),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
        trailing: const Icon(Icons.chevron_left_rounded),
      ),
    );
  }
}
