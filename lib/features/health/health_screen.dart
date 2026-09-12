import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/constants/product_info.dart';
import '../../core/state/app_state.dart';
import '../../core/theme/nafas_colors.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/nafas_card.dart';
import '../../core/widgets/nature_backdrop.dart';

class HealthScreen extends StatelessWidget {
  const HealthScreen({super.key});

  static const _whoUrl =
      'https://www.who.int/news-room/questions-and-answers/item/tobacco-health-benefits-of-smoking-cessation';

  static const milestones = <_HealthMilestone>[
    _HealthMilestone(
      label: '۲۰ دقیقه',
      unlockAfter: Duration(minutes: 20),
      text: 'ضربان قلب و فشار خون شروع به کاهش می‌کنند.',
      icon: Icons.favorite_rounded,
    ),
    _HealthMilestone(
      label: '۱۲ ساعت',
      unlockAfter: Duration(hours: 12),
      text: 'سطح مونوکسیدکربن خون به محدوده طبیعی برمی‌گردد.',
      icon: Icons.bloodtype_rounded,
    ),
    _HealthMilestone(
      label: '۲ تا ۱۲ هفته',
      unlockAfter: Duration(days: 14),
      text: 'در این بازه گردش خون بهتر می‌شود و عملکرد ریه افزایش پیدا می‌کند.',
      icon: Icons.air_rounded,
    ),
    _HealthMilestone(
      label: '۱ تا ۹ ماه',
      unlockAfter: Duration(days: 30),
      text: 'در این بازه سرفه و تنگی نفس کاهش پیدا می‌کند.',
      icon: Icons.health_and_safety_rounded,
    ),
    _HealthMilestone(
      label: '۱ سال',
      unlockAfter: Duration(days: 365),
      text: 'خطر بیماری کرونری قلب حدود نصف یک فرد سیگاری می‌شود.',
      icon: Icons.monitor_heart_rounded,
    ),
    _HealthMilestone(
      label: '۵ تا ۱۵ سال',
      unlockAfter: Duration(days: 365 * 5),
      text: 'در این بازه خطر سکته مغزی تا سطح فرد غیرسیگاری کاهش پیدا می‌کند.',
      icon: Icons.favorite_border_rounded,
    ),
    _HealthMilestone(
      label: '۱۰ سال',
      unlockAfter: Duration(days: 365 * 10),
      text: 'خطر سرطان ریه حدود نصف فرد سیگاری می‌شود و خطر چند سرطان دیگر نیز کاهش پیدا می‌کند.',
      icon: Icons.spa_rounded,
    ),
    _HealthMilestone(
      label: '۱۵ سال',
      unlockAfter: Duration(days: 365 * 15),
      text: 'خطر بیماری کرونری قلب به سطح فرد غیرسیگاری می‌رسد.',
      icon: Icons.verified_rounded,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final state = NafasScope.of(context);
    final rawElapsed = DateTime.now().difference(state.currentStreakStartedAt);
    final elapsed = rawElapsed.isNegative ? Duration.zero : rawElapsed;
    final nextIndex = milestones.indexWhere((item) => elapsed < item.unlockAfter);
    final completed = nextIndex == -1 ? milestones.length : nextIndex;
    final next = nextIndex == -1 ? null : milestones[nextIndex];
    final previous = nextIndex <= 0 ? Duration.zero : milestones[nextIndex - 1].unlockAfter;
    final progress = next == null
        ? 1.0
        : ((elapsed.inMinutes - previous.inMinutes) /
                (next.unlockAfter.inMinutes - previous.inMinutes))
            .clamp(0.0, 1.0)
            .toDouble();

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 120),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Text('مسیر سلامت', style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 6),
                Text(
                  'اطلاعات این صفحه بر پایه زمان سپری‌شده از آخرین شروع مسیر ترک تو نمایش داده می‌شود.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 18),
                _progressHero(context, elapsed, completed, next, progress),
                const SizedBox(height: 22),
                ...List.generate(
                  milestones.length,
                  (index) => _Milestone(
                    data: milestones[index],
                    reached: elapsed >= milestones[index].unlockAfter,
                    current: index == nextIndex,
                    last: index == milestones.length - 1,
                  ),
                ),
                const SizedBox(height: 14),
                _sourceCard(context),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _progressHero(
    BuildContext context,
    Duration elapsed,
    int completed,
    _HealthMilestone? next,
    double progress,
  ) {
    return Stack(
      children: [
        const NatureBackdrop(height: 225),
        Positioned.fill(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Icon(Icons.eco_rounded, color: NafasColors.primary, size: 34),
                const SizedBox(height: 9),
                Text(
                  _elapsedLabel(elapsed),
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: NafasColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  next == null
                      ? 'تمام نقاط زمانی این مسیر را پشت سر گذاشتی.'
                      : 'مرحله بعدی: ${next.label}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: LinearProgressIndicator(value: progress, minHeight: 7),
                ),
                const SizedBox(height: 7),
                Text(
                  '${faDigits(completed)} از ${faDigits(milestones.length)} مرحله ثبت‌شده طی شده',
                  style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w800),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _sourceCard(BuildContext context) {
    return NafasCard(
      backgroundColor: const Color(0xFFFFFBF0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.fact_check_outlined, color: NafasColors.warning),
              SizedBox(width: 8),
              Text('منبع و یادداشت سلامت', style: TextStyle(fontWeight: FontWeight.w900)),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'زمان‌بندی بالا از راهنمای سازمان جهانی بهداشت (WHO) درباره مزایای ترک سیگار گرفته شده است. این اعداد عمومی‌اند و تجربه هر فرد می‌تواند متفاوت باشد.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 8),
          Text(
            'این بخش آموزشی است و جایگزین تشخیص، درمان یا توصیه پزشکی شخصی نیست. آخرین بازبینی: ${NafasProductInfo.legalReview}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 10),
          TextButton.icon(
            onPressed: () => launchUrl(
              Uri.parse(_whoUrl),
              mode: LaunchMode.externalApplication,
            ),
            icon: const Icon(Icons.open_in_new_rounded),
            label: const Text('مشاهده منبع WHO'),
          ),
        ],
      ),
    );
  }

  static String _elapsedLabel(Duration duration) {
    if (duration.inDays >= 365) {
      final years = duration.inDays ~/ 365;
      final days = duration.inDays % 365;
      return days == 0
          ? '${faDigits(years)} سال بدون سیگار'
          : '${faDigits(years)} سال و ${faDigits(days)} روز بدون سیگار';
    }
    if (duration.inDays > 0) return '${faDigits(duration.inDays)} روز بدون سیگار';
    if (duration.inHours > 0) return '${faDigits(duration.inHours)} ساعت بدون سیگار';
    return '${faDigits(duration.inMinutes.clamp(0, 59))} دقیقه بدون سیگار';
  }
}

class _HealthMilestone {
  const _HealthMilestone({
    required this.label,
    required this.unlockAfter,
    required this.text,
    required this.icon,
  });

  final String label;
  final Duration unlockAfter;
  final String text;
  final IconData icon;
}

class _Milestone extends StatelessWidget {
  const _Milestone({
    required this.data,
    required this.reached,
    required this.current,
    required this.last,
  });

  final _HealthMilestone data;
  final bool reached;
  final bool current;
  final bool last;

  @override
  Widget build(BuildContext context) {
    final color = reached ? NafasColors.success : current ? NafasColors.primary : NafasColors.textSecondary;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: reached || current ? NafasColors.surfaceSoft : const Color(0xFFF3F3F3),
                shape: BoxShape.circle,
                border: current ? Border.all(color: NafasColors.primary, width: 2) : null,
              ),
              child: Icon(reached ? Icons.check_rounded : data.icon, color: color, size: 21),
            ),
            if (!last)
              Container(
                width: 2,
                height: 76,
                color: reached ? NafasColors.success.withValues(alpha: .35) : NafasColors.border,
              ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 2, bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(data.label, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: color)),
                    if (current) ...[
                      const SizedBox(width: 7),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(color: NafasColors.surfaceSoft, borderRadius: BorderRadius.circular(99)),
                        child: const Text('مرحله بعدی', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w900, color: NafasColors.primary)),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(data.text, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
