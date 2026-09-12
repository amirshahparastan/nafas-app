import 'package:flutter/material.dart';

import '../../core/constants/product_info.dart';
import '../../core/theme/nafas_colors.dart';
import '../../core/widgets/nafas_logo.dart';
import '../../core/widgets/rtl_app_bar.dart';
import '../../core/widgets/rtl_icons.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const RtlAppBar(title: 'درباره نفس'),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 32),
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(18, 24, 18, 22),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [Color(0xFFFFFAF1), Color(0xFFEAF6F1)],
                ),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: NafasColors.border),
              ),
              child: Column(
                children: [
                  Container(
                    width: 76,
                    height: 76,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x15083B34),
                          blurRadius: 24,
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Image.asset(
                      'assets/branding/nafas_app_icon_1024.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const NafasLogo(),
                  const SizedBox(height: 8),
                  const Text(
                    'همراه شما در مسیر ترک سیگار',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: NafasColors.textSecondary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(99),
                      border: Border.all(color: NafasColors.border),
                    ),
                    child: const Text(
                      'نسخه ${NafasProductInfo.version}',
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            _card(
              icon: Icons.favorite_outline_rounded,
              title: 'چرا نفس ساخته شد؟',
              text:
                  'نفس برای این ساخته شده که مسیر ترک سیگار فقط یک شمارنده نباشد؛ بتوانی لحظه‌های هوس را مدیریت کنی، پیشرفتت را ببینی، پول ذخیره‌شده را به یک هدف واقعی وصل کنی و دلیل شخصی ادامه‌دادن را همیشه جلوی چشمت داشته باشی.',
            ),
            const SizedBox(height: 12),
            _card(
              icon: Icons.code_rounded,
              title: 'طراحی و توسعه',
              text:
                  '${NafasProductInfo.developerTeam}\n${NafasProductInfo.developerName}',
              emphasized: true,
            ),
            const SizedBox(height: 18),
            const Text(
              'اطلاعات و قوانین',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 8),
            _navTile(
              context,
              icon: Icons.support_agent_rounded,
              title: 'تماس با پشتیبانی',
              subtitle: NafasProductInfo.supportEmail,
              route: '/support',
            ),
            _navTile(
              context,
              icon: Icons.privacy_tip_outlined,
              title: 'سیاست حریم خصوصی',
              subtitle: 'نحوه نگهداری و استفاده از داده‌های شما',
              route: '/privacy-policy',
            ),
            _navTile(
              context,
              icon: Icons.description_outlined,
              title: 'قوانین استفاده',
              subtitle: 'شرایط استفاده از اپلیکیشن نفس',
              route: '/terms',
            ),
            const SizedBox(height: 14),
            Text(
              '© PULSE • ${NafasProductInfo.legalReview}',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  Widget _card({
    required IconData icon,
    required String title,
    required String text,
    bool emphasized = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: emphasized ? NafasColors.surfaceSoft : Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: emphasized
              ? NafasColors.primary.withValues(alpha: .22)
              : NafasColors.border,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: NafasColors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
                ),
                const SizedBox(height: 5),
                Text(
                  text,
                  style: const TextStyle(
                    color: NafasColors.textSecondary,
                    height: 1.75,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _navTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required String route,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 9),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(19),
        border: Border.all(color: NafasColors.border),
      ),
      child: ListTile(
        onTap: () => Navigator.pushNamed(context, route),
        leading: Icon(icon, color: NafasColors.primary),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
        subtitle: Text(subtitle),
        trailing: const NafasDisclosureIcon(),
      ),
    );
  }
}
