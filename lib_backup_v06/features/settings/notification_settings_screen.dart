import 'package:flutter/material.dart';
import '../../core/services/notification_service.dart';
import '../../core/state/app_state.dart';
import '../../core/theme/nafas_colors.dart';
import '../../core/widgets/nafas_buttons.dart';
import '../../core/widgets/rtl_app_bar.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  String _permission = 'unknown';
  bool _loadingPermission = true;

  @override
  void initState() {
    super.initState();
    _loadPermission();
  }

  Future<void> _loadPermission() async {
    final value = await NafasNotificationService.permissionStatus();
    if (!mounted) return;
    setState(() {
      _permission = value;
      _loadingPermission = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = NafasScope.of(context);
    return Scaffold(
      appBar: const RtlAppBar(title: 'اعلان‌ها و یادآوری‌ها'),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 30),
        children: [
          _permissionCard(context),
          const SizedBox(height: 14),
          _toggle('یادآوری‌های حمایتی', 'پیام‌های کوتاه و غیرآزاردهنده برای ادامه مسیر', state.remindersEnabled, state.toggleReminders),
          _toggle('هشدار زمان‌های پرریسک', 'بعد از شناخت الگوها، قبل از زمان‌های حساس یادآوری می‌کنیم', state.riskyTimeRemindersEnabled, state.toggleRiskyTimeReminders),
          _toggle('فعالیت دیوار امید', 'فقط رویدادهای مهم؛ بدون اعلان‌های شلوغ', state.communityNotificationsEnabled, state.toggleCommunityNotifications),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(color: NafasColors.surfaceSoft, borderRadius: BorderRadius.circular(18)),
            child: const Text(
              'اصل اعلان در نفس: کم، مفید و قابل‌کنترل. در لحظه هوس هیچ اعلان تبلیغاتی نمایش داده نمی‌شود. زمان‌بندی واقعی اندروید بعد از تکمیل Android SDK به سرویس محلی سیستم متصل می‌شود.',
              style: TextStyle(height: 1.7, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _permissionCard(BuildContext context) {
    final supported = NafasNotificationService.supported;
    final granted = _permission == 'granted';
    final denied = _permission == 'denied';
    final title = !supported
        ? 'اعلان در این پیش‌نمایش در دسترس نیست'
        : granted
            ? 'مجوز اعلان فعاله'
            : denied
                ? 'مجوز اعلان غیرفعاله'
                : 'اجازه اعلان هنوز گرفته نشده';
    final subtitle = !supported
        ? 'روی Android/iOS با اتصال سرویس اعلان فعال می‌شود.'
        : granted
            ? 'می‌تونی یک اعلان آزمایشی بفرستی و مطمئن بشی مرورگر اجازه نمایش داره.'
            : denied
                ? 'از تنظیمات مرورگر باید اجازه اعلان برای این سایت را فعال کنی.'
                : 'اجازه را فقط وقتی می‌گیریم که خودت بخوای؛ نه در اولین ثانیه نصب.';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF0F6F5C), Color(0xFF0B4F43)]),
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [BoxShadow(color: Color(0x22083B34), blurRadius: 24, offset: Offset(0, 10))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(color: Colors.white.withValues(alpha: .12), borderRadius: BorderRadius.circular(14)),
                child: Icon(granted ? Icons.notifications_active_rounded : Icons.notifications_none_rounded, color: Colors.white),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16)),
                    const SizedBox(height: 3),
                    Text(subtitle, style: TextStyle(color: Colors.white.withValues(alpha: .73), fontSize: 12.5, height: 1.55)),
                  ],
                ),
              ),
            ],
          ),
          if (_loadingPermission) ...[
            const SizedBox(height: 14),
            const LinearProgressIndicator(minHeight: 4),
          ] else if (supported) ...[
            const SizedBox(height: 14),
            if (!granted)
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: NafasColors.primaryDark,
                    side: BorderSide.none,
                  ),
                  onPressed: () async {
                    final value = await NafasNotificationService.requestPermission();
                    if (!mounted) return;
                    setState(() => _permission = value);
                  },
                  child: const Text('درخواست مجوز اعلان'),
                ),
              )
            else
              NafasSecondaryButton(
                label: 'ارسال اعلان آزمایشی',
                icon: Icons.send_rounded,
                onPressed: () async {
                  final ok = await NafasNotificationService.showTestNotification();
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(ok ? 'اعلان آزمایشی ارسال شد.' : 'مرورگر اجازه نمایش اعلان را نداد.')),
                  );
                },
              ),
          ],
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
                const SizedBox(height: 2),
                Text(subtitle, style: const TextStyle(color: NafasColors.textSecondary, fontSize: 12.5, height: 1.55)),
              ],
            ),
          ),
          Switch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}
