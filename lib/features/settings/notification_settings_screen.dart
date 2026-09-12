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

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen>
    with WidgetsBindingObserver {
  String _permission = 'unknown';
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadPermission();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _loadPermission();
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
            decoration: BoxDecoration(
              color: NafasColors.surfaceSoft,
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Text(
              'نسخه ۱.۰ فقط از یادآوری محلی و اختیاری استفاده می‌کند. اعلان تبلیغاتی یا اعلان سروری در این نسخه فعال نیست و یادآوری روزانه بعد از زمان‌بندی بدون اینترنت هم کار می‌کند.',
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
            ? 'اعلان‌ها فعال هستند'
            : 'اعلان‌ها خاموش هستند';
    final subtitle = !supported
        ? 'قابلیت یادآوری روزانه در نسخه اندروید فعال است.'
        : granted
            ? 'نفس فقط اعلان‌هایی را نمایش می‌دهد که خودت فعال کرده باشی.'
            : 'برای دریافت یادآوری، مجوز اعلان را از همین صفحه فعال کن. اگر قبلاً مجوز را رد کرده‌ای، می‌توانی مستقیم وارد تنظیمات اعلان گوشی شوی.';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0F6F5C), Color(0xFF0B4F43)],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22083B34),
            blurRadius: 24,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: .12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  granted
                      ? Icons.notifications_active_rounded
                      : Icons.notifications_off_outlined,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: .78),
                        fontSize: 12.5,
                        height: 1.55,
                      ),
                    ),
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
            if (!granted) ...[
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: NafasColors.primaryDark,
                  ),
                  onPressed: _requestPermission,
                  icon: const Icon(Icons.notifications_active_outlined),
                  label: const Text('فعال‌کردن اعلان‌ها'),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: TextButton.icon(
                  style: TextButton.styleFrom(foregroundColor: Colors.white),
                  onPressed: () async {
                    final opened = await NafasNotificationService.openNotificationSettings();
                    if (!opened && context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('بازکردن تنظیمات اعلان گوشی ممکن نشد.'),
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.settings_rounded),
                  label: const Text('تنظیمات اعلان گوشی'),
                ),
              ),
            ] else
              NafasSecondaryButton(
                label: 'ارسال اعلان آزمایشی',
                icon: Icons.send_rounded,
                onPressed: () async {
                  final ok = await NafasNotificationService.showTestNotification();
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        ok
                            ? 'اعلان آزمایشی ارسال شد.'
                            : 'نمایش اعلان ممکن نشد. مجوز اعلان را بررسی کن.',
                      ),
                    ),
                  );
                },
              ),
          ],
        ],
      ),
    );
  }

  Future<void> _requestPermission() async {
    final value = await NafasNotificationService.requestPermission();
    if (!mounted) return;
    setState(() => _permission = value);
    if (value != 'granted') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'مجوز اعلان فعال نشد. اگر قبلاً آن را رد کرده‌ای، «تنظیمات اعلان گوشی» را باز کن.',
          ),
        ),
      );
    }
  }

  Widget _reminderCard(BuildContext context, NafasAppState state) {
    final scheduling = NafasNotificationService.supportsScheduling;
    final timeLabel =
        '${faDigits(state.reminderHour.toString().padLeft(2, '0'))}:${faDigits(state.reminderMinute.toString().padLeft(2, '0'))}';

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: NafasColors.border),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: NafasColors.surfaceSoft,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.schedule_rounded,
                  color: NafasColors.primary,
                ),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'یادآوری حمایتی روزانه',
                      style: TextStyle(fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      scheduling
                          ? 'یک پیام کوتاه در ساعت دلخواه؛ بدون نیاز به اینترنت'
                          : 'زمان‌بندی روزانه در نسخه اندروید فعال است.',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              Switch(
                value: scheduling && state.remindersEnabled,
                onChanged: scheduling
                    ? (value) => _toggleReminder(context, state, value)
                    : null,
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
                    const Icon(
                      Icons.access_time_rounded,
                      color: NafasColors.primary,
                    ),
                    const SizedBox(width: 9),
                    const Expanded(
                      child: Text(
                        'ساعت یادآوری',
                        style: TextStyle(fontWeight: FontWeight.w800),
                      ),
                    ),
                    Text(
                      timeLabel,
                      textDirection: TextDirection.ltr,
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        color: NafasColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _toggleReminder(
    BuildContext context,
    NafasAppState state,
    bool value,
  ) async {
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
      await _showPermissionSheet(context);
      return;
    }

    final scheduled = await NafasNotificationService.scheduleDailySupportReminder(
      hour: state.reminderHour,
      minute: state.reminderMinute,
    );
    if (!context.mounted) return;
    if (scheduled) {
      state.toggleReminders(true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('یادآوری روزانه فعال شد.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('زمان‌بندی اعلان ممکن نشد.')),
      );
    }
  }

  Future<void> _showPermissionSheet(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'اجازه اعلان خاموش است',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 8),
            const Text(
              'برای فعال‌شدن یادآوری، اجازه اعلان نفس را در تنظیمات گوشی روشن کن.',
              style: TextStyle(height: 1.7),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () async {
                  Navigator.pop(sheetContext);
                  await NafasNotificationService.openNotificationSettings();
                },
                icon: const Icon(Icons.settings_rounded),
                label: const Text('باز کردن تنظیمات اعلان'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickTime(BuildContext context, NafasAppState state) async {
    final picked = await _showPersianTimePicker(
      context,
      initialHour: state.reminderHour,
      initialMinute: state.reminderMinute,
    );
    if (picked == null) return;

    state.updateReminderTime(hour: picked.$1, minute: picked.$2);
    if (state.remindersEnabled) {
      final scheduled = await NafasNotificationService.scheduleDailySupportReminder(
        hour: picked.$1,
        minute: picked.$2,
      );
      if (!scheduled && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('به‌روزرسانی ساعت یادآوری ممکن نشد.')),
        );
      }
    }
  }

  Future<(int, int)?> _showPersianTimePicker(
    BuildContext context, {
    required int initialHour,
    required int initialMinute,
  }) async {
    var hour = initialHour;
    var minute = initialMinute;
    final hourController = FixedExtentScrollController(initialItem: initialHour);
    final minuteController = FixedExtentScrollController(initialItem: initialMinute);

    return showModalBottomSheet<(int, int)>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'انتخاب ساعت یادآوری',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 6),
              const Text(
                'ساعت به‌صورت ۲۴ ساعته نمایش داده می‌شود.',
                style: TextStyle(color: NafasColors.textSecondary),
              ),
              const SizedBox(height: 18),
              Directionality(
                textDirection: TextDirection.ltr,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _TimeWheel(
                      controller: hourController,
                      count: 24,
                      onChanged: (value) => hour = value,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        ':',
                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
                      ),
                    ),
                    _TimeWheel(
                      controller: minuteController,
                      count: 60,
                      onChanged: (value) => minute = value,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(sheetContext),
                      child: const Text('لغو'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: FilledButton(
                      onPressed: () => Navigator.pop(sheetContext, (hour, minute)),
                      child: const Text('تأیید'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TimeWheel extends StatelessWidget {
  const _TimeWheel({
    required this.controller,
    required this.count,
    required this.onChanged,
  });

  final FixedExtentScrollController controller;
  final int count;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 92,
      height: 170,
      decoration: BoxDecoration(
        color: NafasColors.surfaceSoft,
        borderRadius: BorderRadius.circular(22),
      ),
      child: ListWheelScrollView.useDelegate(
        controller: controller,
        itemExtent: 48,
        physics: const FixedExtentScrollPhysics(),
        perspective: .003,
        onSelectedItemChanged: onChanged,
        childDelegate: ListWheelChildBuilderDelegate(
          childCount: count,
          builder: (context, index) => Center(
            child: Text(
              faDigits(index.toString().padLeft(2, '0')),
              textDirection: TextDirection.ltr,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
            ),
          ),
        ),
      ),
    );
  }
}
