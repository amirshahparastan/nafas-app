import 'package:flutter/material.dart';

import '../../core/theme/nafas_colors.dart';
import '../../core/widgets/nafas_buttons.dart';
import '../../core/widgets/nafas_card.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(18, 22, 18, 122),
        children: [
          Row(
            children: [
              Expanded(child: Text('دیوار امید', style: Theme.of(context).textTheme.headlineMedium)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
                decoration: BoxDecoration(color: NafasColors.sunSoft, borderRadius: BorderRadius.circular(99)),
                child: const Text('به‌زودی', style: TextStyle(fontWeight: FontWeight.w900, color: NafasColors.money)),
              ),
            ],
          ),
          const SizedBox(height: 7),
          Text(
            'فضایی برای پیام‌های کوتاه و حمایتی آدم‌هایی که همین مسیر را طی می‌کنند.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF0F6F5C), Color(0xFF0B4F43)]),
              borderRadius: BorderRadius.circular(28),
              boxShadow: const [BoxShadow(color: Color(0x22083B34), blurRadius: 26, offset: Offset(0, 12))],
            ),
            child: Column(
              children: [
                Container(
                  width: 76,
                  height: 76,
                  decoration: BoxDecoration(color: Colors.white.withValues(alpha: .12), shape: BoxShape.circle),
                  child: const Icon(Icons.volunteer_activism_rounded, color: Colors.white, size: 39),
                ),
                const SizedBox(height: 16),
                const Text('داریم دیوار امید را برای نسخه آنلاین آماده می‌کنیم', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900, height: 1.5)),
                const SizedBox(height: 9),
                Text(
                  'هسته اصلی نفس بدون اینترنت کار می‌کند. دیوار امید بعد از آماده‌شدن زیرساخت امن، گزارش محتوا و مدیریت جامعه فعال می‌شود.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white.withValues(alpha: .78), height: 1.75),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const _Principle(icon: Icons.visibility_off_outlined, title: 'نام مستعار', subtitle: 'هویت عمومی از اطلاعات خصوصی جدا خواهد بود.'),
          const _Principle(icon: Icons.report_gmailerrorred_rounded, title: 'گزارش محتوا', subtitle: 'پیام نامناسب قابل گزارش و بررسی خواهد بود.'),
          const _Principle(icon: Icons.forum_outlined, title: 'بدون پیام خصوصی', subtitle: 'نسخه اول جامعه روی حمایت عمومی تمرکز می‌کند، نه دایرکت.'),
          const SizedBox(height: 14),
          NafasCard(
            backgroundColor: const Color(0xFFFFFBF0),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.wifi_rounded, color: NafasColors.warning),
                SizedBox(width: 10),
                Expanded(child: Text('فقط دیوار امید و قابلیت‌های ابری آینده به اینترنت نیاز خواهند داشت؛ ثبت مسیر ترک و ابزارهای اصلی نفس آفلاین می‌مانند.', style: TextStyle(height: 1.7))),
              ],
            ),
          ),
          const SizedBox(height: 14),
          NafasSecondaryButton(
            label: 'پیشنهاد برای دیوار امید',
            icon: Icons.lightbulb_outline_rounded,
            onPressed: () => Navigator.pushNamed(context, '/feedback'),
          ),
        ],
      ),
    );
  }
}

class _Principle extends StatelessWidget {
  const _Principle({required this.icon, required this.title, required this.subtitle});

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: NafasColors.border)),
      child: Row(
        children: [
          Container(width: 44, height: 44, decoration: BoxDecoration(color: NafasColors.surfaceSoft, borderRadius: BorderRadius.circular(14)), child: Icon(icon, color: NafasColors.primary)),
          const SizedBox(width: 11),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.w900)), const SizedBox(height: 2), Text(subtitle, style: Theme.of(context).textTheme.bodySmall)])),
        ],
      ),
    );
  }
}
