import 'package:flutter/material.dart';
import '../../core/state/app_state.dart';
import '../../core/theme/nafas_colors.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/rtl_app_bar.dart';

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = NafasScope.of(context);
    final days = state.smokeFreeDays;
    final items = [
      (1, 'اولین روز', 'شروع کردی؛ مهم‌ترین قدم.', Icons.eco_rounded),
      (3, 'سه روز', 'سه روز مقاومت پیوسته.', Icons.bolt_rounded),
      (7, 'یک هفته', 'هفت روز کنار هم.', Icons.emoji_events_rounded),
      (30, 'یک ماه', 'یک ماه مسیر مداوم.', Icons.workspace_premium_rounded),
      (100, 'صد روز', 'یک نقطه عطف بزرگ.', Icons.auto_awesome_rounded),
    ];

    return Scaffold(
      appBar: const RtlAppBar(title: 'دستاوردها'),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 28),
        children: [
          Text('هر نشان، یادآور یه بخش از مسیریه که خودت ساختی.', style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 18),
          ...items.map((e) {
            final unlocked = days >= e.$1;
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: unlocked ? NafasColors.surfaceSoft : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: unlocked ? NafasColors.success.withValues(alpha: .4) : NafasColors.border),
                boxShadow: const [BoxShadow(color: Color(0x07083B34), blurRadius: 18, offset: Offset(0, 7))],
              ),
              child: Row(
                children: [
                  Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(color: unlocked ? NafasColors.primary : const Color(0xFFF0F3F2), shape: BoxShape.circle),
                    child: Icon(unlocked ? e.$4 : Icons.lock_outline_rounded, color: unlocked ? Colors.white : NafasColors.textMuted),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(e.$2, style: const TextStyle(fontWeight: FontWeight.w900, color: NafasColors.textPrimary)),
                        const SizedBox(height: 3),
                        Text(e.$3, style: Theme.of(context).textTheme.bodySmall),
                      ],
                    ),
                  ),
                  Text(unlocked ? 'باز شده' : '${formatInt(e.$1)} روز', style: TextStyle(color: unlocked ? NafasColors.primary : NafasColors.textMuted, fontWeight: FontWeight.w800)),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
