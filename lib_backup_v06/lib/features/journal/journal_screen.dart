import 'package:flutter/material.dart';
import '../../core/state/app_state.dart';
import '../../core/theme/nafas_colors.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/nafas_card.dart';
import '../../core/widgets/rtl_app_bar.dart';

class JournalScreen extends StatefulWidget {
  const JournalScreen({super.key});
  @override State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  String mood = 'معمولی';
  final note = TextEditingController();

  @override void dispose() { note.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final state = NafasScope.of(context);
    final history = [...state.journalEntries]..sort((a, b) => b.at.compareTo(a.at));
    return Scaffold(
      appBar: const RtlAppBar(title: 'حالِ امروز'),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 30),
          children: [
            Text(formatJalaliDate(DateTime.now()), style: const TextStyle(color: NafasColors.primary, fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            Text('امروز چه حالی داری؟', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 6),
            Text('لازم نیست زیاد بنویسی. یک ثبت کوتاه کمک می‌کنه بفهمی چه روزها و چه حال‌هایی سخت‌ترن.', style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(child: _Mood(label: 'خوب', icon: Icons.sentiment_satisfied_alt_rounded, selected: mood == 'خوب', onTap: () => setState(() => mood = 'خوب'))),
                const SizedBox(width: 9),
                Expanded(child: _Mood(label: 'معمولی', icon: Icons.sentiment_neutral_rounded, selected: mood == 'معمولی', onTap: () => setState(() => mood = 'معمولی'))),
                const SizedBox(width: 9),
                Expanded(child: _Mood(label: 'سخت', icon: Icons.sentiment_dissatisfied_rounded, selected: mood == 'سخت', onTap: () => setState(() => mood = 'سخت'))),
              ],
            ),
            const SizedBox(height: 14),
            TextField(
              controller: note,
              maxLines: 4,
              minLines: 3,
              decoration: const InputDecoration(labelText: 'یادداشت کوتاه (اختیاری)', hintText: 'مثلاً بعد از ناهار هوس داشتم ولی با پیاده‌روی بهتر شد...'),
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: () {
                state.addJournalEntry(mood: mood, note: note.text);
                note.clear();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('حال امروز ثبت شد.')));
              },
              icon: const Icon(Icons.check_rounded),
              label: const Text('ثبت حال امروز'),
            ),
            const SizedBox(height: 28),
            const Text('یادداشت‌های قبلی', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900)),
            const SizedBox(height: 10),
            if (history.isEmpty)
              NafasCard(child: Text('هنوز چیزی ثبت نکردی. همین ثبت‌های کوتاه بعداً به بینش‌های شخصی کمک می‌کنن.', style: Theme.of(context).textTheme.bodyMedium))
            else
              ...history.take(12).map((entry) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: NafasCard(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(width: 44, height: 44, decoration: BoxDecoration(color: NafasColors.surfaceSoft, borderRadius: BorderRadius.circular(14)), child: Icon(_moodIcon(entry.mood), color: NafasColors.primary)),
                      const SizedBox(width: 12),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Row(children: [Text(entry.mood, style: const TextStyle(fontWeight: FontWeight.w900)), const Spacer(), Text(formatJalaliDate(entry.at, includeWeekday: false), style: Theme.of(context).textTheme.bodySmall)]),
                        if (entry.note.isNotEmpty) ...[const SizedBox(height: 5), Text(entry.note, style: Theme.of(context).textTheme.bodyMedium)],
                      ])),
                    ],
                  ),
                ),
              )),
          ],
        ),
      ),
    );
  }

  IconData _moodIcon(String value) => value == 'خوب' ? Icons.sentiment_satisfied_alt_rounded : value == 'سخت' ? Icons.sentiment_dissatisfied_rounded : Icons.sentiment_neutral_rounded;
}

class _Mood extends StatelessWidget {
  const _Mood({required this.label, required this.icon, required this.selected, required this.onTap});
  final String label; final IconData icon; final bool selected; final VoidCallback onTap;
  @override Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(19),
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 170),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(color: selected ? NafasColors.surfaceSoft : Colors.white, borderRadius: BorderRadius.circular(19), border: Border.all(color: selected ? NafasColors.primary : NafasColors.border, width: selected ? 1.4 : 1)),
      child: Column(children: [Icon(icon, color: selected ? NafasColors.primary : NafasColors.textMuted, size: 28), const SizedBox(height: 7), Text(label, style: TextStyle(fontWeight: FontWeight.w900, color: selected ? NafasColors.primary : NafasColors.textPrimary))]),
    ),
  );
}
