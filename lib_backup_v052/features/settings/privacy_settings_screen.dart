import 'package:flutter/material.dart';
import '../../core/state/app_state.dart';
import '../../core/theme/nafas_colors.dart';
import '../../core/widgets/rtl_app_bar.dart';

class PrivacySettingsScreen extends StatelessWidget {
  const PrivacySettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = NafasScope.of(context);
    return Scaffold(
      appBar: const RtlAppBar(title: 'حریم خصوصی و داده‌ها'),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 30),
        children: [
          _card(Icons.visibility_off_outlined, 'هویت عمومی جداست', 'در دیوار امید فقط «${state.communityAlias}» نمایش داده می‌شود؛ نام، موبایل و ایمیل خصوصی‌اند.'),
          _card(Icons.cloud_sync_outlined, 'پشتیبان‌گیری ابری', 'بعد از اتصال حساب، داده‌های اصلی به‌شکل امن همگام می‌شوند. نسخه فعلی هنوز Local/Demo است.'),
          _card(Icons.fingerprint_rounded, 'قفل برنامه', 'برای نسخه لانچ، قفل بیومتریک یا PIN را به‌صورت اختیاری در نظر گرفته‌ایم.'),
          _card(Icons.download_outlined, 'خروجی گرفتن از داده‌ها', 'کاربر باید بتواند سابقه شخصی خودش را دریافت کند.'),
          _card(Icons.delete_outline_rounded, 'حذف حساب و داده‌ها', 'نسخه لانچ مسیر حذف حساب و داده‌های ابری را شفاف و قابل دسترس خواهد داشت.'),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(color: NafasColors.accentSoft, borderRadius: BorderRadius.circular(18)),
            child: const Text('اصل محصول: حداقل داده لازم را جمع می‌کنیم. اطلاعات سلامت/ترک برای تبلیغات هدفمند فروخته یا عمومی نمی‌شوند.', style: TextStyle(height: 1.7, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  Widget _card(IconData icon, String title, String subtitle) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(19), border: Border.all(color: NafasColors.border)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(width: 42, height: 42, decoration: BoxDecoration(color: NafasColors.surfaceSoft, borderRadius: BorderRadius.circular(13)), child: Icon(icon, color: NafasColors.primary)),
          const SizedBox(width: 11),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.w900)), const SizedBox(height: 3), Text(subtitle, style: const TextStyle(color: NafasColors.textSecondary, height: 1.6))])),
        ],
      ),
    );
  }
}
