import 'package:flutter/material.dart';
import '../../core/state/app_state.dart';
import '../../core/theme/nafas_colors.dart';
import '../../core/widgets/rtl_app_bar.dart';

class NotificationSettingsScreen extends StatelessWidget {
  const NotificationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = NafasScope.of(context);
    return Scaffold(
      appBar: const RtlAppBar(title: 'اعلان‌ها و یادآوری‌ها'),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 30),
        children: [
          _toggle('یادآوری‌های حمایتی', 'پیام‌های کوتاه و غیرآزاردهنده برای ادامه مسیر', state.remindersEnabled, state.toggleReminders),
          _toggle('هشدار زمان‌های پرریسک', 'بعد از شناخت الگوها، قبل از زمان‌های حساس یادآوری می‌کنیم', state.riskyTimeRemindersEnabled, state.toggleRiskyTimeReminders),
          _toggle('فعالیت دیوار امید', 'فقط رویدادهای مهم؛ بدون اعلان‌های شلوغ', state.communityNotificationsEnabled, state.toggleCommunityNotifications),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(color: NafasColors.surfaceSoft, borderRadius: BorderRadius.circular(18)),
            child: const Text('برای لانچ، Quiet Hours، زمان‌بندی جلالی و کنترل کامل نوع اعلان‌ها اضافه می‌شود. هیچ اعلان تبلیغاتی در لحظه هوس نمایش داده نمی‌شود.', style: TextStyle(height: 1.7, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  Widget _toggle(String title, String subtitle, bool value, ValueChanged<bool> onChanged) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(19), border: Border.all(color: NafasColors.border)),
      child: Row(
        children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.w900)), const SizedBox(height: 2), Text(subtitle, style: const TextStyle(color: NafasColors.textSecondary, fontSize: 12.5, height: 1.55))])),
          Switch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}
