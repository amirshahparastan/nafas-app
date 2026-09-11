import 'package:flutter/material.dart';
import '../../core/theme/nafas_colors.dart';
import '../../core/theme/nafas_spacing.dart';
import '../../core/widgets/nafas_card.dart';
import '../../core/widgets/section_title.dart';
import '../../core/widgets/stat_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          NafasSpacing.pageHorizontal,
          18,
          NafasSpacing.pageHorizontal,
          24,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Header(onSettings: () => Navigator.pushNamed(context, '/settings')),
            const SizedBox(height: 24),
            const _HeroCard(),
            const SizedBox(height: 14),
            const Row(
              children: [
                StatCard(
                  icon: Icons.smoke_free_rounded,
                  value: '۱۸۰ نخ',
                  label: 'سیگار نکشیدی',
                ),
                SizedBox(width: 12),
                StatCard(
                  icon: Icons.account_balance_wallet_outlined,
                  value: '۱.۸ میلیون',
                  label: 'تومان ذخیره کردی',
                ),
              ],
            ),
            const SizedBox(height: 18),
            _CravingButton(onTap: () => Navigator.pushNamed(context, '/craving')),
            const SizedBox(height: 28),
            const SectionTitle(title: 'هدف مالی من'),
            const SizedBox(height: 12),
            const _GoalCard(),
            const SizedBox(height: 28),
            const SectionTitle(title: 'بدنت داره بهتر میشه'),
            const SizedBox(height: 12),
            const _HealthCard(),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.onSettings});
  final VoidCallback onSettings;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('صبح بخیر، امیر 👋', style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 4),
              Text('امروز هم یک قدم جلوتر', style: Theme.of(context).textTheme.headlineMedium),
            ],
          ),
        ),
        IconButton.filledTonal(
          onPressed: onSettings,
          icon: const Icon(Icons.settings_outlined),
          style: IconButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: NafasColors.primary,
          ),
        ),
      ],
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [NafasColors.primary, NafasColors.primaryDark],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: const [
          BoxShadow(
            color: Color(0x2A0F6F5C),
            blurRadius: 28,
            offset: Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('🔥 ۱۲ روز پاکی', style: TextStyle(color: Colors.white, fontSize: 29, fontWeight: FontWeight.w900)),
          const SizedBox(height: 8),
          Text('یک روز دیگه هم برای خودت بردی.', style: TextStyle(color: Colors.white.withValues(alpha: .82), fontSize: 14)),
          const SizedBox(height: 24),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: const LinearProgressIndicator(
              value: .72,
              minHeight: 9,
              backgroundColor: Color(0x33FFFFFF),
              valueColor: AlwaysStoppedAnimation(Colors.white),
            ),
          ),
          const SizedBox(height: 10),
          Text('تا رکورد بعدی: ۳ روز', style: TextStyle(color: Colors.white.withValues(alpha: .78), fontSize: 12)),
        ],
      ),
    );
  }
}

class _CravingButton extends StatelessWidget {
  const _CravingButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Ink(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          color: NafasColors.accent,
          borderRadius: BorderRadius.circular(22),
          boxShadow: const [
            BoxShadow(color: Color(0x33FF7A59), blurRadius: 24, offset: Offset(0, 10)),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(color: Color(0x26FFFFFF), shape: BoxShape.circle),
              child: Icon(Icons.air_rounded, color: Colors.white),
            ),
            SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('الان هوس کردم', style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w900)),
                  SizedBox(height: 3),
                  Text('۳ دقیقه کنارت می‌مونم', style: TextStyle(color: Color(0xE6FFFFFF), fontSize: 12)),
                ],
              ),
            ),
            Icon(Icons.chevron_left_rounded, color: Colors.white),
          ],
        ),
      ),
    );
  }
}

class _GoalCard extends StatelessWidget {
  const _GoalCard();

  @override
  Widget build(BuildContext context) {
    return NafasCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              CircleAvatar(
                backgroundColor: NafasColors.surfaceSoft,
                foregroundColor: NafasColors.primary,
                child: Icon(Icons.headphones_rounded),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('خرید هدفون', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: NafasColors.textPrimary)),
                    SizedBox(height: 3),
                    Text('۱.۸ از ۱۵ میلیون تومان', style: TextStyle(fontSize: 12, color: NafasColors.textSecondary)),
                  ],
                ),
              ),
              Text('۱۲٪', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: NafasColors.primary)),
            ],
          ),
          const SizedBox(height: 18),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: const LinearProgressIndicator(
              value: .12,
              minHeight: 10,
              backgroundColor: NafasColors.surfaceSoft,
              valueColor: AlwaysStoppedAnimation(NafasColors.success),
            ),
          ),
          const SizedBox(height: 12),
          Text('با همین روند، حدود ۹۲ روز دیگه به هدفت می‌رسی ✨', style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}

class _HealthCard extends StatelessWidget {
  const _HealthCard();

  @override
  Widget build(BuildContext context) {
    return NafasCard(
      backgroundColor: NafasColors.surfaceSoft,
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
            child: const Icon(Icons.favorite_rounded, color: NafasColors.success, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('بدنت در حال ترمیمه', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: NafasColors.textPrimary)),
                const SizedBox(height: 6),
                Text('مرحله بعدی سلامتت نزدیکه؛ همین مسیر رو ادامه بده.', style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
          const Icon(Icons.chevron_left_rounded, color: NafasColors.primary),
        ],
      ),
    );
  }
}
