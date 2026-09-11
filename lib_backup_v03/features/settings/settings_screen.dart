import 'package:flutter/material.dart';
import '../../core/state/app_state.dart';
import '../../core/theme/nafas_colors.dart';
import '../../core/widgets/nafas_logo.dart';
import '../../core/widgets/rtl_app_bar.dart';

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
            const SizedBox(height: 22),
            _tile(
              Icons.notifications_outlined,
              'یادآوری‌های حمایتی',
              'یادآوری‌های سبک و غیرآزاردهنده',
              trailing: Switch(value: state.remindersEnabled, onChanged: state.toggleReminders),
            ),
            _tile(Icons.smoke_free_rounded, 'اطلاعات مصرف', 'تعداد روزانه، قیمت پاکت و تاریخ شروع', onTap: () => _info(context)),
            _tile(Icons.flag_outlined, 'هدف مالی', 'از تب هدف می‌تونی ویرایشش کنی'),
            _tile(Icons.volunteer_activism_outlined, 'دیوار امید', 'نام مستعار، حریم خصوصی و گزارش محتوا', onTap: () => _communityInfo(context)),
            _tile(Icons.lock_outline_rounded, 'حریم خصوصی', 'اطلاعات حساس عمومی نمی‌شود؛ انتشار پیشرفت اختیاری است'),
            _tile(Icons.health_and_safety_outlined, 'اطلاعات سلامت', 'محتوای آموزشی؛ جایگزین توصیه پزشکی نیست'),
            _tile(Icons.info_outline_rounded, 'درباره نفس', 'نسخه ۰.۳.۰ • Product Hardening'),
            const SizedBox(height: 18),
            OutlinedButton(
              onPressed: () => _confirmReset(context, state),
              child: const Text('شروع دوباره نسخه آزمایشی', style: TextStyle(color: NafasColors.danger)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tile(IconData icon, String title, String subtitle, {Widget? trailing, VoidCallback? onTap}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(19),
        border: Border.all(color: NafasColors.border),
        boxShadow: const [BoxShadow(color: Color(0x08083B34), blurRadius: 18, offset: Offset(0, 7))],
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 13, vertical: 4),
        leading: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(color: NafasColors.surfaceSoft, borderRadius: BorderRadius.circular(13)),
          child: Icon(icon, color: NafasColors.primary),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
        subtitle: Text(subtitle),
        trailing: trailing ?? const Icon(Icons.chevron_left_rounded, color: NafasColors.textMuted),
      ),
    );
  }

  void _info(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('ویرایش اطلاعات مصرف'),
        content: const Text('ساختار فرم ویرایش در نسخه لانچ با ذخیره محلی دائمی فعال می‌شود. در این build آزمایشی داده‌ها هنوز در حافظه اجرای برنامه‌اند.'),
        actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('باشه'))],
      ),
    );
  }

  void _communityInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('قواعد دیوار امید'),
        content: const Text('نام مستعار استفاده می‌شود، نمایش روزهای پاکی و مبلغ ذخیره‌شده اختیاری است، و هر پیام قابلیت گزارش دارد. کامنت و پیام خصوصی در نسخه اول نداریم.'),
        actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('متوجه شدم'))],
      ),
    );
  }

  void _confirmReset(BuildContext context, NafasAppState state) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('شروع دوباره؟'),
        content: const Text('داده‌های همین اجرای آزمایشی پاک می‌شوند و دوباره به آنبوردینگ برمی‌گردی.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('لغو')),
          TextButton(
            onPressed: () {
              state.resetForDemo();
              Navigator.of(ctx).popUntil((route) => route.isFirst);
            },
            child: const Text('شروع دوباره', style: TextStyle(color: NafasColors.danger)),
          ),
        ],
      ),
    );
  }
}
