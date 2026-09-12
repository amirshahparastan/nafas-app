import 'package:flutter/material.dart';

import '../../core/services/notification_service.dart';
import '../../core/state/app_state.dart';
import '../../core/theme/nafas_colors.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/nafas_buttons.dart';
import '../../core/widgets/rtl_app_bar.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  String _permission = 'unknown';
  bool _loading = true;

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
      _loading = false;
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
          _reminderCard(context, state),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(color: NafasColors.surfaceSoft, borderRadius: BorderRadius.circular(18)),
            child: const Text(
              'نسخه ۱.۰ فقط از یادآوری محلی و اختیاری استفاده می‌کند. اعلان تبلیغاتی یا Push سروری در این نسخه فعال نیست و یادآوری روزانه بعد از زمان‌بندی بدون اینترنت هم کار می‌کند.',
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
    final title = !supported
        ? 'اعلان در این پلتفرم در دسترس نیست'
        : granted
            ? 'مجوز اعلان فعاله'
            : 'برای یادآوری باید اجازه اعلان بدی';
    final subtitle = !supported
        ? 'قابلیت یادآوری روزانه در نسخه Android فعال است.'
        : granted
            ? 'نفس فقط اعلان‌هایی را نمایش می‌دهد که خودت فعال کرده باشی.'
            : 'اجازه فقط با انتخاب خودت درخواست می‌شود و هر زمان بخواهی می‌توانی از تنظیمات گوشی خاموشش کنی.';

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
                    Text(subtitle, style: TextStyle(color: Colors.white.withValues(alpha: .75), fontSize: 12.5, height: 1.55)),
                  ],
                ),
              ),
            ],
          ),
          if (_loading) ...[
            const SizedBox(height: 14),
            const LinearProgressIndicator(minHeight: 4),
          ] else if (supported) ...[
            const SizedBox(height: 14),
            if (!granted)
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: NafasColors.primaryDark, side: BorderSide.none),
                  onPressed: () async {
                    final value = await NafasNotificationService.requestPermission();
                    if (!mounted) return;
                    setState(() => _permission = value);
                  },
                  child: const Text('اجازه اعلان'),
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
                    SnackBar(content: Text(ok ? 'اعلان آزمایشی ارسال شد.' : 'نمایش اعلان ممکن نشد. مجوز اعلان را بررسی کن.')),
                  );
                },
              ),
          ],
        ],
      ),
    );
  }

  Widget _reminderCard(BuildContext context, NafasAppState state) {
    final scheduling = NafasNotificationService.supportsScheduling;
    final timeLabel = '${faDigits(state.reminderHour.toString().padLeft(2, '0'))}:${faDigits(state.reminderMinute.toString().padLeft(2, '0'))}';

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: NafasColors.border)),
      child: Column(
        children: [
          Row(
            children: [
              Container(width: 44, height: 44, decoration: BoxDecoration(color: NafasColors.surfaceSoft, borderRadius: BorderRadius.circular(14)), child: const Icon(Icons.schedule_rounded, color: NafasColors.primary)),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('یادآوری حمایتی روزانه', style: TextStyle(fontWeight: FontWeight.w900)),
                    const SizedBox(height: 2),
                    Text(scheduling ? 'یک پیام کوتاه در ساعت دلخواه؛ بدون نیاز به اینترنت' : 'زمان‌بندی روزانه در نسخه Android فعال است.', style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
              Switch(
                value: scheduling && state.remindersEnabled,
                onChanged: scheduling ? (value) => _toggleReminder(context, state, value) : null,
              ),
            ],
          ),
          if (scheduling) ...[
            const Divider(height: 24),
            InkWell(
              onTap: () => _pickTime(context, state),
              borderRadius: BorderRadius.circular(14),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 7),
                child: Row(
                  children: [
                    const Icon(Icons.access_time_rounded, color: NafasColors.primary),
                    const SizedBox(width: 9),
                    const Expanded(child: Text('ساعت یادآوری', style: TextStyle(fontWeight: FontWeight.w800))),
                    Text(timeLabel, textDirection: TextDirection.ltr, style: const TextStyle(fontWeight: FontWeight.w900, color: NafasColors.primary)),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _toggleReminder(BuildContext context, NafasAppState state, bool value) async {
    if (!value) {
      await NafasNotificationService.cancelDailySupportReminder();
      state.toggleReminders(false);
      return;
    }

    var permission = await NafasNotificationService.permissionStatus();
    if (permission != 'granted') {
      permission = await NafasNotificationService.requestPermission();
      if (mounted) setState(() => _permission = permission);
    }
    if (permission != 'granted') {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('برای فعال‌شدن یادآوری باید اجازه اعلان داده شود.')));
      return;
    }

    final scheduled = await NafasNotificationService.scheduleDailySupportReminder(hour: state.reminderHour, minute: state.reminderMinute);
    if (!context.mounted) return;
    if (scheduled) {
      state.toggleReminders(true);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('یادآوری روزانه فعال شد.')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('زمان‌بندی اعلان ممکن نشد.')));
    }
  }

  Future<void> _pickTime(BuildContext context, NafasAppState state) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: state.reminderHour, minute: state.reminderMinute),
    );
    if (picked == null) return;
    state.updateReminderTime(hour: picked.hour, minute: picked.minute);
    if (state.remindersEnabled) {
      await NafasNotificationService.scheduleDailySupportReminder(hour: picked.hour, minute: picked.minute);
    }
  }
}
