import 'package:flutter/material.dart';
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
        ? 'بعد از اولین تغییر، ذخیره خودکار انجام می‌شود.'
        : 'آخرین ذخیره خودکار: ${formatRelativePersianTime(state.lastLocalSaveAt!)}';

    return Scaffold(
      appBar: const RtlAppBar(title: 'حریم خصوصی و داده‌ها'),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 30),
        children: [
          _card(
            Icons.save_rounded,
            state.localPersistenceDurable ? 'ذخیره خودکار روی دستگاه فعال است' : 'ذخیره پیش‌نمایش فعال است',
            '${state.persistenceLabel} • $saveLabel',
            emphasized: true,
          ),
          _card(Icons.visibility_off_outlined, 'هویت عمومی جداست', 'در دیوار امید فقط «${state.communityAlias}» نمایش داده می‌شود؛ نام، موبایل و ایمیل خصوصی‌اند.'),
          _card(Icons.cloud_sync_outlined, 'پشتیبان‌گیری ابری', 'معماری Sync آماده است؛ فعال‌سازی واقعی بین چند دستگاه به Backend امن و حساب کاربری متصل می‌شود.'),
          _card(Icons.fingerprint_rounded, 'قفل برنامه', 'برای نسخه لانچ، قفل بیومتریک یا PIN به‌صورت اختیاری در نظر گرفته شده.'),
          _card(Icons.download_outlined, 'خروجی گرفتن از داده‌ها', 'قرارداد Export در مستندات تعریف شده و در فاز Backend به فایل قابل دریافت متصل می‌شود.'),
          _card(Icons.delete_outline_rounded, 'حذف حساب و داده‌ها', 'در لانچ، حذف حساب باید داده ابری را هم حذف کند و از داخل خود برنامه در دسترس باشد.'),
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
            decoration: BoxDecoration(color: NafasColors.surfaceSoft, borderRadius: BorderRadius.circular(18)),
            child: const Text(
              'اصل محصول: حداقل داده لازم را جمع می‌کنیم. اطلاعات ترک و سلامت برای تبلیغات هدفمند فروخته یا عمومی نمی‌شوند.',
              style: TextStyle(height: 1.7, fontWeight: FontWeight.w700),
            ),
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
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(13)),
            child: Icon(icon, color: NafasColors.primary),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
                const SizedBox(height: 3),
                Text(subtitle, style: const TextStyle(color: NafasColors.textSecondary, height: 1.6)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
