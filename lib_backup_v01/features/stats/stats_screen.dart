import 'package:flutter/material.dart';
import '../../core/theme/nafas_colors.dart';
import '../../core/theme/nafas_spacing.dart';
import '../../core/widgets/nafas_card.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(NafasSpacing.pageHorizontal),
        children: [
          Text('آمار و روند', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 18),
          const Row(
            children: [
              _MiniStat(value: '۱۲', label: 'روز پاکی'),
              SizedBox(width: 12),
              _MiniStat(value: '۱۸۰', label: 'نخ نکشیده'),
            ],
          ),
          const SizedBox(height: 12),
          const Row(
            children: [
              _MiniStat(value: '۱.۸M', label: 'تومان ذخیره'),
              SizedBox(width: 12),
              _MiniStat(value: '۸', label: 'هوس ثبت‌شده'),
            ],
          ),
          const SizedBox(height: 24),
          NafasCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('ساعات پرریسک', style: TextStyle(fontWeight: FontWeight.w900, color: NafasColors.textPrimary)),
                const SizedBox(height: 18),
                SizedBox(
                  height: 150,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: const [
                      _Bar(height: 44),
                      _Bar(height: 70),
                      _Bar(height: 95),
                      _Bar(height: 58),
                      _Bar(height: 120),
                      _Bar(height: 82),
                      _Bar(height: 52),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({required this.value, required this.label});
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: NafasCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: NafasColors.primary)),
            const SizedBox(height: 4),
            Text(label, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}

class _Bar extends StatelessWidget {
  const _Bar({required this.height});
  final double height;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Container(
          height: height,
          decoration: BoxDecoration(
            color: NafasColors.success,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
