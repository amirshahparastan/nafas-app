import 'package:flutter/material.dart';
import '../../core/theme/nafas_colors.dart';
import '../../core/theme/nafas_spacing.dart';
import '../../core/widgets/nafas_card.dart';

class HealthScreen extends StatelessWidget {
  const HealthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      ('۲۰ دقیقه', 'شروع بازگشت بدن به شرایط بهتر', true),
      ('۸ ساعت', 'یک مرحله دیگر از پاکسازی بدن', true),
      ('۴۸ ساعت', 'حس بویایی و چشایی می‌تواند بهتر شود', true),
      ('۲ هفته', 'پیشرفت محسوس‌تر در مسیر سلامت', false),
    ];

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(NafasSpacing.pageHorizontal),
        children: [
          Text('مسیر سلامت', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 6),
          Text('این بخش فعلاً UI است؛ متن‌های پزشکی نسخه انتشار باید از منابع معتبر نهایی شوند.', style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 24),
          ...items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: NafasCard(
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: item.$3 ? NafasColors.success : NafasColors.surfaceSoft,
                        foregroundColor: item.$3 ? Colors.white : NafasColors.primary,
                        child: Icon(item.$3 ? Icons.check_rounded : Icons.lock_outline_rounded),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.$1, style: const TextStyle(fontWeight: FontWeight.w900, color: NafasColors.textPrimary)),
                            const SizedBox(height: 4),
                            Text(item.$2, style: Theme.of(context).textTheme.bodySmall),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
