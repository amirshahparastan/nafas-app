import 'package:flutter/material.dart';
import '../../core/theme/nafas_colors.dart';
import '../../core/theme/nafas_spacing.dart';
import '../../core/widgets/nafas_card.dart';

class GoalScreen extends StatelessWidget {
  const GoalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(NafasSpacing.pageHorizontal),
        children: [
          Text('هدف من', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 18),
          NafasCard(
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 34,
                  backgroundColor: NafasColors.surfaceSoft,
                  child: Icon(Icons.headphones_rounded, color: NafasColors.primary, size: 34),
                ),
                const SizedBox(height: 14),
                const Text('خرید هدفون', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: NafasColors.textPrimary)),
                const SizedBox(height: 8),
                Text('۱.۸ میلیون از ۱۵ میلیون تومان', style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 18),
                ClipRRect(
                  borderRadius: BorderRadius.circular(99),
                  child: const LinearProgressIndicator(
                    value: .12,
                    minHeight: 12,
                    backgroundColor: NafasColors.surfaceSoft,
                    valueColor: AlwaysStoppedAnimation(NafasColors.success),
                  ),
                ),
                const SizedBox(height: 12),
                const Text('۱۲٪', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: NafasColors.primary)),
                const SizedBox(height: 6),
                Text('تخمین رسیدن به هدف: حدود ۹۲ روز', style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
