import 'package:flutter/material.dart';
import '../../core/state/app_state.dart';
import '../../core/theme/nafas_colors.dart';
import '../../core/utils/formatters.dart';
import '../../core/utils/jalali.dart';
import '../../core/widgets/nafas_card.dart';
import '../../core/widgets/rtl_app_bar.dart';
import '../../core/widgets/rtl_icons.dart';

class QuitCalendarScreen extends StatefulWidget {
  const QuitCalendarScreen({super.key});
  @override State<QuitCalendarScreen> createState() => _QuitCalendarScreenState();
}

class _QuitCalendarScreenState extends State<QuitCalendarScreen> {
  late JalaliDate visible;
  DateTime selected = DateTime.now();

  @override
  void initState() {
    super.initState();
    final j = JalaliDate.fromDateTime(DateTime.now());
    visible = JalaliDate(j.year, j.month, 1);
  }

  @override
  Widget build(BuildContext context) {
    final state = NafasScope.of(context);
    final firstDate = visible.toDateTime();
    final offset = saturdayFirstWeekdayIndex(firstDate);
    final totalCells = ((offset + visible.daysInMonth + 6) ~/ 7) * 7;
    final selectedStatus = state.journeyStatusFor(selected);

    return Scaffold(
      appBar: const RtlAppBar(title: 'تقویم نفس'),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 30),
          children: [
            Text('مسیرت رو روزبه‌روز ببین', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 6),
            Text('همه تاریخ‌ها جلالی‌اند. سبز یعنی روز پاک، زرد یعنی روزی که هوس ثبت شده و قرمز یعنی لغزش ثبت‌شده.', style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 18),
            NafasCard(
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(tooltip: 'ماه قبل', onPressed: () => setState(() => visible = visible.previousMonth()), icon: const NafasPreviousIcon()),
                      Expanded(child: Text('${visible.monthName} ${faDigits(visible.year)}', textAlign: TextAlign.center, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w900))),
                      IconButton(tooltip: 'ماه بعد', onPressed: () => setState(() => visible = visible.nextMonth()), icon: const NafasNextIcon()),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: persianWeekdayNamesSaturdayFirst.map((name) => Expanded(
                      child: SizedBox(height: 32, child: Center(child: FittedBox(fit: BoxFit.scaleDown, child: Text(name, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: NafasColors.textMuted))))),
                    )).toList(),
                  ),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: totalCells,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7, mainAxisSpacing: 6, crossAxisSpacing: 6),
                    itemBuilder: (_, index) {
                      final day = index - offset + 1;
                      if (day < 1 || day > visible.daysInMonth) return const SizedBox.shrink();
                      final date = JalaliDate(visible.year, visible.month, day).toDateTime();
                      final status = state.journeyStatusFor(date);
                      final active = sameCalendarDay(date, selected);
                      return InkWell(
                        onTap: () => setState(() => selected = date),
                        borderRadius: BorderRadius.circular(14),
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: active ? NafasColors.primaryDark : _statusColor(status),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: active ? NafasColors.primaryDark : _statusBorder(status)),
                          ),
                          child: Text(faDigits(day), style: TextStyle(fontWeight: FontWeight.w900, color: active ? Colors.white : _statusText(status))),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  const Wrap(
                    spacing: 14,
                    runSpacing: 8,
                    children: [
                      _Legend(color: Color(0xFFE4F7EF), dot: NafasColors.success, label: 'روز پاک'),
                      _Legend(color: Color(0xFFFFF6E7), dot: NafasColors.warning, label: 'هوس ثبت شده'),
                      _Legend(color: Color(0xFFFFECEC), dot: NafasColors.danger, label: 'لغزش'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            NafasCard(
              backgroundColor: NafasColors.surfaceSoft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(formatJalaliDate(selected), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: NafasColors.textPrimary)),
                  const SizedBox(height: 8),
                  Text(_statusTextLabel(selectedStatus, state), style: Theme.of(context).textTheme.bodyMedium),
                  if (state.journalOn(selected).isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Text('یادداشت: ${state.journalOn(selected).last.note.isEmpty ? 'حال روز ثبت شده' : state.journalOn(selected).last.note}', style: const TextStyle(fontWeight: FontWeight.w700)),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _statusColor(JourneyDayStatus status) => switch (status) {
    JourneyDayStatus.smokeFree => const Color(0xFFE4F7EF),
    JourneyDayStatus.craving => const Color(0xFFFFF6E7),
    JourneyDayStatus.slip => const Color(0xFFFFECEC),
    _ => Colors.white,
  };

  Color _statusBorder(JourneyDayStatus status) => switch (status) {
    JourneyDayStatus.smokeFree => const Color(0xFFBDEBD9),
    JourneyDayStatus.craving => const Color(0xFFFFDC9B),
    JourneyDayStatus.slip => const Color(0xFFF2BABA),
    _ => NafasColors.border,
  };

  Color _statusText(JourneyDayStatus status) => switch (status) {
    JourneyDayStatus.future || JourneyDayStatus.beforeJourney => NafasColors.textMuted,
    JourneyDayStatus.slip => NafasColors.danger,
    JourneyDayStatus.craving => const Color(0xFF9B671D),
    _ => NafasColors.primary,
  };

  String _statusTextLabel(JourneyDayStatus status, NafasAppState state) => switch (status) {
    JourneyDayStatus.beforeJourney => 'این روز قبل از شروع مسیر ثبت‌شده توست.',
    JourneyDayStatus.future => 'این روز هنوز نرسیده.',
    JourneyDayStatus.smokeFree => 'روز پاک ثبت شده؛ بدون لغزش و بدون هوس ثبت‌شده.',
    JourneyDayStatus.craving => '${formatInt(state.cravingsOn(selected))} هوس در این روز ثبت شده و مسیر ادامه پیدا کرده.',
    JourneyDayStatus.slip => '${formatInt(state.slipsOn(selected))} نخ به‌عنوان لغزش ثبت شده؛ سابقه مسیر پاک نشده و ادامه مسیر مهم‌تره.',
  };
}

class _Legend extends StatelessWidget {
  const _Legend({required this.color, required this.dot, required this.label});
  final Color color;
  final Color dot;
  final String label;
  @override Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
    decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(99)),
    child: Row(mainAxisSize: MainAxisSize.min, children: [Container(width: 7, height: 7, decoration: BoxDecoration(color: dot, shape: BoxShape.circle)), const SizedBox(width: 6), Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800))]),
  );
}
