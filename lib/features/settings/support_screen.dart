import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/constants/product_info.dart';
import '../../core/services/support_email.dart';
import '../../core/theme/nafas_colors.dart';
import '../../core/widgets/nafas_buttons.dart';
import '../../core/widgets/rtl_app_bar.dart';
import '../../core/widgets/rtl_icons.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const RtlAppBar(title: 'تماس با پشتیبانی'),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 10, 18, 30),
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [NafasColors.surfaceSoft, Color(0xFFFFF8E8)],
                ),
                borderRadius: BorderRadius.circular(26),
                border: Border.all(color: NafasColors.border),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.support_agent_rounded, color: NafasColors.primary, size: 34),
                  SizedBox(height: 12),
                  Text(
                    'پشتیبانی نفس',
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 21),
                  ),
                  SizedBox(height: 7),
                  Text(
                    'اگر در استفاده از نفس به مشکل خوردی، پیشنهادی برای بهتر شدن برنامه داری یا نیاز به راهنمایی داری، پیام تو از طریق ایمیل رسمی تیم PULSE دریافت می‌شود.',
                    style: TextStyle(
                      color: NafasColors.textSecondary,
                      height: 1.75,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: NafasColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'ایمیل رسمی پشتیبانی',
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 8),
                  Directionality(
                    textDirection: TextDirection.ltr,
                    child: SelectableText(
                      NafasProductInfo.supportEmail,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                        color: NafasColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  NafasPrimaryButton(
                    label: 'ارسال ایمیل به پشتیبانی',
                    icon: Icons.email_outlined,
                    onPressed: () => _sendEmail(context),
                  ),
                  const SizedBox(height: 9),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => _copyEmail(context),
                      icon: const Icon(Icons.copy_rounded),
                      label: const Text('کپی ایمیل'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'چه موضوعی را می‌توانی برای ما بفرستی؟',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 8),
            _item(
              context,
              Icons.bug_report_outlined,
              'گزارش مشکل فنی',
              'اگر صفحه‌ای درست کار نمی‌کند یا با خطا روبه‌رو شدی.',
              'گزارش مشکل فنی در اپلیکیشن نفس',
            ),
            _item(
              context,
              Icons.lightbulb_outline_rounded,
              'پیشنهاد قابلیت جدید',
              'ایده‌ای که می‌تواند نفس را کاربردی‌تر یا ساده‌تر کند.',
              'پیشنهاد برای اپلیکیشن نفس',
            ),
            _item(
              context,
              Icons.help_outline_rounded,
              'راهنمای استفاده',
              'اگر درباره یکی از بخش‌های برنامه سؤال داری.',
              'راهنمای استفاده از اپلیکیشن نفس',
            ),
            const SizedBox(height: 12),
            Text(
              'کانال رسمی پشتیبانی این نسخه فقط ${NafasProductInfo.supportEmail} است.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  Widget _item(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    String subject,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 9),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(19),
        border: Border.all(color: NafasColors.border),
      ),
      child: ListTile(
        onTap: () => _sendEmail(context, subject: subject),
        leading: Icon(icon, color: NafasColors.primary),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
        subtitle: Text(subtitle),
        trailing: const NafasDisclosureIcon(),
      ),
    );
  }

  Future<void> _sendEmail(BuildContext context, {String? subject}) async {
    final opened = await openNafasSupportEmail(
      subject: subject ?? 'پشتیبانی اپلیکیشن نفس',
    );
    if (!context.mounted) return;
    if (!opened) {
      _copyEmail(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('برنامه ایمیل باز نشد؛ آدرس پشتیبانی کپی شد.'),
        ),
      );
    }
  }

  void _copyEmail(BuildContext context) {
    Clipboard.setData(const ClipboardData(text: NafasProductInfo.supportEmail));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('ایمیل پشتیبانی کپی شد.')),
    );
  }
}
