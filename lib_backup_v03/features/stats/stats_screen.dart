import 'package:flutter/material.dart';
import '../../core/state/app_state.dart';
import '../../core/theme/nafas_colors.dart';
import '../../core/utils/formatters.dart';
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
    return 'از ${formatInt(state.cravings.length)} هوس ثبت‌شده، ${formatInt(passed)} مورد رو با موفقیت پشت سر گذاشتی.';
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
    final values = List<int>.filled(7, 0);
    final now = DateTime.now();
    for (final craving in state.cravings) {
      final dayDistance = now.difference(craving.at).inDays;
      if (dayDistance >= 0 && dayDistance < 7) {
        values[6 - dayDistance]++;
      }
    }
    final maxValue = values.fold<int>(1, (a, b) => a > b ? a : b);
    const labels = ['ش', 'ی', 'د', 'س', 'چ', 'پ', 'ج'];

    return NafasCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'هوس‌های ۷ روز اخیر',
            style: TextStyle(
              fontWeight: FontWeight.w900,
              color: NafasColors.textPrimary,
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: 130,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(7, (i) {
                final height = values[i] == 0
                    ? 8.0
                    : 100.0 * (values[i] / maxValue);
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              height: height,
                              decoration: BoxDecoration(
                                color: values[i] == 0
                                    ? NafasColors.border
                                    : NafasColors.success,
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 7),
                        Text(
                          labels[i],
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
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
