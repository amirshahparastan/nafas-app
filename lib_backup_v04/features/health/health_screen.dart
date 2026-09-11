import 'package:flutter/material.dart';
import '../../core/theme/nafas_colors.dart';
import '../../core/widgets/nafas_card.dart';
import '../../core/widgets/nature_backdrop.dart';

class HealthScreen extends StatelessWidget {
  const HealthScreen({super.key});

  static const milestones = <(String, String, IconData)>[
    ('۲۰ دقیقه', 'ضربان قلب و فشار خون شروع به کاهش می‌کنند.', Icons.favorite_rounded),
    ('۱۲ ساعت', 'سطح مونوکسیدکربن خون به محدوده طبیعی برمی‌گردد.', Icons.bloodtype_rounded),
    ('۲ تا ۱۲ هفته', 'گردش خون بهتر می‌شود و عملکرد ریه افزایش پیدا می‌کند.', Icons.air_rounded),
    ('۱ تا ۹ ماه', 'سرفه و تنگی نفس می‌تواند کمتر شود.', Icons.health_and_safety_rounded),
    ('۱ سال', 'خطر بیماری کرونری قلب حدود نصف یک فرد سیگاری می‌شود.', Icons.monitor_heart_rounded),
    ('۱۰ سال', 'خطر سرطان ریه حدود نصف فرد سیگاری می‌شود.', Icons.spa_rounded),
    ('۱۵ سال', 'خطر بیماری کرونری قلب به سطح فرد غیرسیگاری نزدیک می‌شود.', Icons.verified_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 120),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Text(
                  'مسیر سلامت',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 6),
                Text(
                  'تغییرهای بدن رو به‌صورت مرحله‌ای ببین؛ نه برای ترساندن، برای یادآوری اینکه هر روز ارزش داره.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 18),
                Stack(
                  children: [
                    const NatureBackdrop(height: 190),
                    Positioned.fill(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Icon(
                              Icons.eco_rounded,
                              color: NafasColors.primary,
                              size: 36,
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'بدنت داره کار خودش رو می‌کنه',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                                color: NafasColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'تو فقط امروز رو ادامه بده.',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ...List.generate(
                  milestones.length,
                  (i) => _Milestone(
                    data: milestones[i],
                    last: i == milestones.length - 1,
                  ),
                ),
                const SizedBox(height: 18),
                NafasCard(
                  backgroundColor: const Color(0xFFFFFBF0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(
                            Icons.info_outline_rounded,
                            color: NafasColors.warning,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'یادداشت سلامت',
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              color: NafasColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'این زمان‌بندی اطلاعات عمومی آموزشی است و جایگزین توصیه پزشک نیست. منبع پایه: سازمان جهانی بهداشت (WHO).',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _Milestone extends StatelessWidget {
  const _Milestone({required this.data, required this.last});

  final (String, String, IconData) data;
  final bool last;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: const BoxDecoration(
                color: NafasColors.surfaceSoft,
                shape: BoxShape.circle,
              ),
              child: Icon(
                data.$3,
                color: NafasColors.primary,
                size: 20,
              ),
            ),
            if (!last)
              Container(
                width: 2,
                height: 72,
                color: NafasColors.border,
              ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 3, bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.$1,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                    color: NafasColors.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  data.$2,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
