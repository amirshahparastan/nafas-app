import 'package:flutter/material.dart';

import '../../core/constants/product_info.dart';
import '../../core/services/notification_service.dart';
import '../../core/state/app_state.dart';
import '../../core/theme/nafas_colors.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/nafas_logo.dart';
import '../../core/widgets/rtl_app_bar.dart';
import '../../core/widgets/rtl_icons.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = NafasScope.of(context);
    return Scaffold(
      appBar: const RtlAppBar(title: 'تنظیمات'),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 28),
          children: [
            const Center(child: NafasLogo()),
            const SizedBox(height: 18),
            _accountHero(context, state),
            const SizedBox(height: 22),
            _section('شخصی‌سازی'),
            _tile(Icons.smoke_free_rounded, 'اطلاعات مصرف و انگیزه', 'مصرف روزانه، قیمت پاکت و دلیل شخصی ترک', onTap: () => Navigator.pushNamed(context, '/smoking-settings')),
            _tile(Icons.notifications_outlined, 'اعلان‌ها و یادآوری‌ها', 'یادآوری محلی و اختیاری بدون نیاز به اینترنت', onTap: () => Navigator.pushNamed(context, '/notification-settings')),
            const SizedBox(height: 14),
            _section('مسیر ترک'),
            _tile(Icons.calendar_month_rounded, 'تقویم نفس', 'تقویم جلالی با روزهای پاک، هوس و لغزش', onTap: () => Navigator.pushNamed(context, '/calendar')),
            _tile(Icons.edit_note_rounded, 'حال امروز و ژورنال', 'ثبت حال، یادداشت و شناخت روزهای سخت', onTap: () => Navigator.pushNamed(context, '/journal')),
            _tile(Icons.flag_outlined, 'هدف مالی', state.hasGoal ? '${state.goalTitle} • ${formatToman(state.goalAmountToman.toDouble())}' : 'هنوز هدفی ثبت نشده', onTap: () {
              Navigator.pop(context);
              state.setTab(3);
            }),
            _tile(Icons.health_and_safety_outlined, 'اطلاعات سلامت', 'خط زمانی منبع‌دار بر اساس زمان ترک تو', onTap: () {
              Navigator.pop(context);
              state.setTab(1);
            }),
            _tile(Icons.health_and_safety_rounded, 'کمک و ایمنی', 'فرد مورد اعتماد، کمک تخصصی و اورژانس', onTap: () => Navigator.pushNamed(context, '/help')),
            const SizedBox(height: 14),
            _section('حریم خصوصی'),
            _tile(Icons.lock_outline_rounded, 'حریم خصوصی و داده‌ها', 'ذخیره محلی، حالت آفلاین و حذف داده‌ها', onTap: () => Navigator.pushNamed(context, '/privacy-settings')),
            const SizedBox(height: 14),
            _section('پشتیبانی'),
            _tile(Icons.support_agent_rounded, 'تماس با پشتیبانی', NafasProductInfo.supportEmail, onTap: () => Navigator.pushNamed(context, '/support')),
            _tile(Icons.rate_review_outlined, 'انتقاد و پیشنهاد', 'پیشنهاد، گزارش مشکل یا تجربه کاربری', onTap: () => Navigator.pushNamed(context, '/feedback')),
            const SizedBox(height: 14),
            _section('درباره و قوانین'),
            _tile(Icons.privacy_tip_outlined, 'سیاست حریم خصوصی', 'نحوه نگهداری و استفاده از داده‌های شما', onTap: () => Navigator.pushNamed(context, '/privacy-policy')),
            _tile(Icons.description_outlined, 'قوانین استفاده', 'شرایط استفاده از اپلیکیشن نفس', onTap: () => Navigator.pushNamed(context, '/terms')),
            _tile(Icons.info_outline_rounded, 'درباره نفس', 'نسخه ${NafasProductInfo.version} • PULSE', onTap: () => Navigator.pushNamed(context, '/about')),
            const SizedBox(height: 18),
            OutlinedButton(
              onPressed: () => _confirmReset(context, state),
              child: const Text('شروع دوباره', style: TextStyle(color: NafasColors.danger)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _accountHero(BuildContext context, NafasAppState state) {
    final display = state.displayName.trim().isNotEmpty ? state.displayName : 'کاربر نفس';
    return InkWell(
      onTap: () => Navigator.pushNamed(context, '/account'),
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Color(0xFF0F6F5C), Color(0xFF0B4F43)]),
          borderRadius: BorderRadius.circular(24),
          boxShadow: const [BoxShadow(color: Color(0x22083B34), blurRadius: 25, offset: Offset(0, 12))],
        ),
        child: Row(
          children: [
            Container(width: 54, height: 54, decoration: BoxDecoration(color: Colors.white.withValues(alpha: .13), borderRadius: BorderRadius.circular(18)), child: const Icon(Icons.person_rounded, color: Colors.white, size: 30)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(display, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 17)),
                  const SizedBox(height: 3),
                  Text('نسخه ۱.۰ • داده‌ها روی همین دستگاه ذخیره می‌شوند', style: TextStyle(color: Colors.white.withValues(alpha: .72), fontSize: 12.5)),
                ],
              ),
            ),
            const NafasDisclosureIcon(color: Colors.white70),
          ],
        ),
      ),
    );
  }

  Widget _section(String title) => Padding(
        padding: const EdgeInsets.only(right: 2, bottom: 8),
        child: Text(title, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15, color: NafasColors.textPrimary)),
      );

  Widget _tile(IconData icon, String title, String subtitle, {VoidCallback? onTap}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 9),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(19), border: Border.all(color: NafasColors.border), boxShadow: const [BoxShadow(color: Color(0x06083B34), blurRadius: 16, offset: Offset(0, 7))]),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 13, vertical: 4),
        leading: Container(width: 42, height: 42, decoration: BoxDecoration(color: NafasColors.surfaceSoft, borderRadius: BorderRadius.circular(13)), child: Icon(icon, color: NafasColors.primary)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
        subtitle: Text(subtitle),
        trailing: const NafasDisclosureIcon(),
      ),
    );
  }

  void _confirmReset(BuildContext context, NafasAppState state) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('شروع دوباره؟'),
        content: const Text('داده‌های مسیر ترک این دستگاه پاک می‌شوند و دوباره وارد مرحله شروع برنامه می‌شی.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('لغو')),
          TextButton(
            onPressed: () async {
              await NafasNotificationService.cancelDailySupportReminder();
              await state.clearAllLocalData();
              if (!ctx.mounted) return;
              Navigator.of(ctx).popUntil((route) => route.isFirst);
            },
            child: const Text('شروع دوباره', style: TextStyle(color: NafasColors.danger)),
          ),
        ],
      ),
    );
  }
}
