import 'package:flutter/material.dart';
import '../theme/nafas_colors.dart';
import '../utils/formatters.dart';
import '../utils/jalali.dart';
import 'rtl_icons.dart';

Future<DateTime?> showNafasJalaliDatePicker({
  required BuildContext context,
  required DateTime initialDate,
  required DateTime firstDate,
  required DateTime lastDate,
}) {
  return showModalBottomSheet<DateTime>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _JalaliPicker(
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    ),
  );
}

class _JalaliPicker extends StatefulWidget {
  const _JalaliPicker({required this.initialDate, required this.firstDate, required this.lastDate});
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;

  @override
  State<_JalaliPicker> createState() => _JalaliPickerState();
}

class _JalaliPickerState extends State<_JalaliPicker> {
  late DateTime selected;
  late JalaliDate visibleMonth;

  @override
  void initState() {
    super.initState();
    selected = widget.initialDate.isAfter(widget.lastDate) ? widget.lastDate : widget.initialDate;
    final j = JalaliDate.fromDateTime(selected);
    visibleMonth = JalaliDate(j.year, j.month, 1);
  }

  bool _allowed(DateTime value) {
    final day = DateTime(value.year, value.month, value.day);
    final first = DateTime(widget.firstDate.year, widget.firstDate.month, widget.firstDate.day);
    final last = DateTime(widget.lastDate.year, widget.lastDate.month, widget.lastDate.day);
    return !day.isBefore(first) && !day.isAfter(last);
  }

  void _move(bool next) {
    final candidate = next ? visibleMonth.nextMonth() : visibleMonth.previousMonth();
    final date = candidate.toDateTime();
    final firstMonth = JalaliDate.fromDateTime(widget.firstDate);
    final lastMonth = JalaliDate.fromDateTime(widget.lastDate);
    final beforeFirst = candidate.year < firstMonth.year || (candidate.year == firstMonth.year && candidate.month < firstMonth.month);
    final afterLast = candidate.year > lastMonth.year || (candidate.year == lastMonth.year && candidate.month > lastMonth.month);
    if (beforeFirst || afterLast) return;
    setState(() => visibleMonth = JalaliDate(candidate.year, candidate.month, 1));
  }

  @override
  Widget build(BuildContext context) {
    final firstGregorian = visibleMonth.toDateTime();
    final offset = saturdayFirstWeekdayIndex(firstGregorian);
    final totalCells = ((offset + visibleMonth.daysInMonth + 6) ~/ 7) * 7;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        margin: const EdgeInsets.only(top: 44),
        padding: const EdgeInsets.fromLTRB(18, 10, 18, 24),
        decoration: const BoxDecoration(
          color: NafasColors.background,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 46, height: 5, decoration: BoxDecoration(color: NafasColors.border, borderRadius: BorderRadius.circular(99))),
              const SizedBox(height: 16),
              Row(
                children: [
                  IconButton(
                    tooltip: 'ماه قبل',
                    onPressed: () => _move(false),
                    icon: const NafasPreviousIcon(),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text('${visibleMonth.monthName} ${faDigits(visibleMonth.year)}', style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w900)),
                        const SizedBox(height: 2),
                        Text('تقویم جلالی', style: Theme.of(context).textTheme.bodySmall),
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: 'ماه بعد',
                    onPressed: () => _move(true),
                    icon: const NafasNextIcon(),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: persianWeekdayNamesSaturdayFirst.map((label) {
                  return Expanded(
                    child: SizedBox(
                      height: 30,
                      child: Center(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(label, maxLines: 1, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: NafasColors.textMuted)),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: totalCells,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7, mainAxisSpacing: 5, crossAxisSpacing: 5),
                itemBuilder: (_, index) {
                  final day = index - offset + 1;
                  if (day < 1 || day > visibleMonth.daysInMonth) return const SizedBox.shrink();
                  final date = JalaliDate(visibleMonth.year, visibleMonth.month, day).toDateTime();
                  final enabled = _allowed(date);
                  final active = sameCalendarDay(date, selected);
                  final today = sameCalendarDay(date, DateTime.now());
                  return InkWell(
                    onTap: enabled ? () => setState(() => selected = date) : null,
                    borderRadius: BorderRadius.circular(14),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 160),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: active ? NafasColors.primary : today ? NafasColors.surfaceSoft : Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: active ? NafasColors.primary : NafasColors.border),
                      ),
                      child: Text(
                        faDigits(day),
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          color: !enabled ? NafasColors.textMuted.withValues(alpha: .4) : active ? Colors.white : NafasColors.textPrimary,
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 14),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), border: Border.all(color: NafasColors.border)),
                child: Text('تاریخ انتخاب‌شده: ${formatJalaliDate(selected)}', textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w800, color: NafasColors.primary)),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: OutlinedButton(onPressed: () => Navigator.pop(context), child: const Text('لغو'))),
                  const SizedBox(width: 10),
                  Expanded(child: FilledButton(onPressed: () => Navigator.pop(context, selected), child: const Text('انتخاب تاریخ'))),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
