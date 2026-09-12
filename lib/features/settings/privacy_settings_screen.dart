import 'package:flutter/material.dart';

import '../../core/services/notification_service.dart';
import '../../core/state/app_state.dart';
import '../../core/theme/nafas_colors.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/rtl_app_bar.dart';

class PrivacySettingsScreen extends StatelessWidget {
  const PrivacySettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = NafasScope.of(context);
    final saveLabel = state.lastLocalSaveAt == null
        ? 'با هر تغییر، داده‌ها خودکار ذخیره می‌شوند.'
        : 'آخرین ذخیره: ${formatRelativePersianTime(state.lastLocalSaveAt!)}';

    return Scaffold(
      appBar: const RtlAppBar(title: 'حریم خصوصی و داده‌ها'),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 30),
        children: [
          _card(Icons.save_rounded, 'ذخیره محلی فعال است', '${state.persistenceLabel} • $saveLabel', emphasized: true),
          _card(Icons.wifi_off_rounded, 'هسته برنامه آفلاین است', 'ثبت هوس، هدف، آمار، ژورنال و مسیر سلامت بدون اینترنت کار می‌کنند.'),
          _card(Icons.cloud_off_outlined, 'همگام‌سازی ابری فعال نیست', 'نسخه ۱.۰ حساب کاربری، بکاپ ابری و ارسال خودکار داده‌های مسیر ترک به سرور ندارد.'),
          _card(Icons.ads_click_outlined, 'بدون تبلیغات هدفمند', 'این نسخه داده‌های ترک یا سلامت را برای تبلیغات هدفمند جمع‌آوری یا به فروش نمی‌رساند.'),
          _card(Icons.support_agent_rounded, 'پشتیبانی فقط با اقدام خودت', 'در صورت انتخاب تماس با پشتیبانی، فقط محتوایی که خودت در ایمیل وارد می‌کنی به PULSE ارسال می‌شود.'),
          if (state.persistenceError != null) ...[
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: NafasColors.accentSoft, borderRadius: BorderRadius.circular(18)),
              child: Text('خطای ذخیره محلی: ${state.persistenceError}', style: const TextStyle(color: NafasColors.danger, fontWeight: FontWeight.w700)),
            ),
          ],
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(color: const Color(0xFFFFFBF0), borderRadius: BorderRadius.circular(18)),
            child: const Text(
              'مهم: در نسخه ۱.۰ داده‌ها بین گوشی‌ها منتقل نمی‌شوند. قبل از تعویض گوشی یا حذف برنامه، فعلاً بکاپ ابری در دسترس نیست.',
              style: TextStyle(height: 1.7, fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(height: 18),
          OutlinedButton.icon(
            icon: const Icon(Icons.delete_forever_outlined, color: NafasColors.danger),
            label: const Text('حذف داده‌های محلی و شروع دوباره', style: TextStyle(color: NafasColors.danger)),
            onPressed: () => _confirmDelete(context, state),
          ),
        ],
      ),
    );
  }

  Widget _card(IconData icon, String title, String subtitle, {bool emphasized = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: emphasized ? NafasColors.surfaceSoft : Colors.white,
        borderRadius: BorderRadius.circular(19),
        border: Border.all(color: emphasized ? NafasColors.primary.withValues(alpha: .22) : NafasColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(width: 42, height: 42, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(13)), child: Icon(icon, color: NafasColors.primary)),
          const SizedBox(width: 11),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.w900)), const SizedBox(height: 3), Text(subtitle, style: const TextStyle(color: NafasColors.textSecondary, height: 1.6))])),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, NafasAppState state) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('همه داده‌های محلی حذف شوند؟'),
        content: const Text('ثبت هوس‌ها، لغزش‌ها، ژورنال، هدف و تنظیمات این دستگاه پاک می‌شوند و برنامه از ابتدا شروع می‌شود. این کار قابل بازگشت نیست.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('لغو')),
          TextButton(
            onPressed: () async {
              await NafasNotificationService.cancelDailySupportReminder();
              await state.clearAllLocalData();
              if (!ctx.mounted) return;
              Navigator.of(ctx).popUntil((route) => route.isFirst);
            },
            child: const Text('حذف داده‌ها', style: TextStyle(color: NafasColors.danger)),
          ),
        ],
      ),
    );
  }
}
