import 'package:flutter/material.dart';
import '../../core/state/app_state.dart';
import '../../core/theme/nafas_colors.dart';
import '../../core/utils/formatters.dart';
import '../../core/utils/jalali.dart';
import '../../core/widgets/nafas_card.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = NafasScope.of(context);
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'آمار و بینش‌ها',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 6),
            Text(
              'هدف آمار اینه که الگو رو بشناسی؛ نه اینکه بابت عددها خودت رو قضاوت کنی.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                _Kpi(
                  value: '${formatInt(state.smokeFreeDays)} روز',
                  label: 'رکورد فعلی',
                  icon: Icons.local_fire_department_rounded,
                ),
                const SizedBox(width: 10),
                _Kpi(
                  value: formatInt(state.cigarettesAvoided),
                  label: 'نخ نکشیده',
                  icon: Icons.smoke_free_rounded,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _Kpi(
                  value: formatToman(state.moneySaved),
                  label: 'ذخیره‌شده',
                  icon: Icons.savings_rounded,
                ),
                const SizedBox(width: 10),
                _Kpi(
                  value: formatInt(state.cravings.length),
                  label: 'هوس ثبت‌شده',
                  icon: Icons.air_rounded,
                ),
              ],
            ),
            const SizedBox(height: 20),
            _CravingChart(state: state),
            const SizedBox(height: 14),
            _TriggerCard(state: state),
            const SizedBox(height: 14),
            NafasCard(
              backgroundColor: NafasColors.surfaceSoft,
              child: Row(
                children: [
                  const Icon(
                    Icons.lightbulb_outline_rounded,
                    color: NafasColors.primary,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _insight(state),
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        color: NafasColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _insight(NafasAppState state) {
    if (state.cravings.isEmpty) {
      return 'هنوز داده کافی برای تحلیل هوس‌ها نداریم. دفعه بعد فقط شدت و محرک رو ثبت کن.';
    }
    final passed = state.cravings.where((e) => e.passed).length;
    final trigger = state.topCravingTrigger;
    final risky = state.riskyTimeLabel;
    return 'از ${formatInt(state.cravings.length)} هوس ثبت‌شده، ${formatInt(passed)} مورد رو پشت سر گذاشتی.${trigger == null ? '' : ' محرک پرتکرارت «$trigger» بوده'}${risky == null ? '' : ' و بیشتر در $risky دیده شده'}. ';
  }
}

class _Kpi extends StatelessWidget {
  const _Kpi({
    required this.value,
    required this.label,
    required this.icon,
  });

  final String value;
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: NafasCard(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: NafasColors.primary),
            const SizedBox(height: 12),
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w900,
                color: NafasColors.textPrimary,
              ),
            ),
            const SizedBox(height: 2),
            Text(label, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}

class _CravingChart extends StatelessWidget {
  const _CravingChart({required this.state});
  final NafasAppState state;

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final dates = List.generate(7, (i) {
      final d = today.subtract(Duration(days: 6 - i));
      return DateTime(d.year, d.month, d.day);
    });
    final values = dates.map((date) => state.cravingsOn(date)).toList();
    final maxValue = values.fold<int>(1, (a, b) => a > b ? a : b);

    return NafasCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('هوس‌های ۷ روز اخیر', style: TextStyle(fontWeight: FontWeight.w900, color: NafasColors.textPrimary)),
          const SizedBox(height: 6),
          Text('عنوان روزها کامل نمایش داده می‌شه تا نمودار در فارسی سریع‌تر خوانده بشه.', style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 18),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            reverse: true,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(7, (i) {
                final height = values[i] == 0 ? 8.0 : 92.0 * (values[i] / maxValue);
                return SizedBox(
                  width: 76,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        height: 104,
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            width: 30,
                            height: height,
                            decoration: BoxDecoration(color: values[i] == 0 ? NafasColors.border : NafasColors.success, borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(persianWeekdayName(dates[i]), maxLines: 1, style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w800, color: NafasColors.textSecondary)),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class _TriggerCard extends StatelessWidget {
  const _TriggerCard({required this.state});
  final NafasAppState state;

  @override
  Widget build(BuildContext context) {
    final counts = <String, int>{};
    for (final craving in state.cravings) {
      counts[craving.trigger] = (counts[craving.trigger] ?? 0) + 1;
    }
    final entries = counts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return NafasCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'محرک‌های پرتکرار',
            style: TextStyle(
              fontWeight: FontWeight.w900,
              color: NafasColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          if (entries.isEmpty)
            Text(
              'هنوز محرکی ثبت نشده.',
              style: Theme.of(context).textTheme.bodyMedium,
            )
          else
            ...entries.take(4).map(
              (entry) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        entry.key,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                    Text(
                      '${formatInt(entry.value)} بار',
                      style: const TextStyle(
                        color: NafasColors.primary,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
