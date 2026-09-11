import 'package:flutter/material.dart';
import '../../core/state/app_state.dart';
import '../../core/theme/nafas_colors.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/rtl_app_bar.dart';

class SlipScreen extends StatefulWidget {
  const SlipScreen({super.key});

  @override
  State<SlipScreen> createState() => _SlipScreenState();
}

class _SlipScreenState extends State<SlipScreen> {
  int count = 1;
  String reason = 'استرس';
  final reasons = const ['استرس', 'جمع دوستان', 'بعد غذا', 'قهوه', 'عادت', 'دلیل دیگه'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const RtlAppBar(title: 'ثبت لغزش'),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(color: const Color(0xFFFFF6F2), borderRadius: BorderRadius.circular(22)),
                child: Row(
                  children: [
                    const Icon(Icons.favorite_outline_rounded, color: NafasColors.accent),
                    const SizedBox(width: 12),
                    Expanded(child: Text('لغزش یعنی یک داده جدید، نه پایان مسیر. سابقه‌ات حفظ می‌شه؛ فقط رکورد فعلی از نو شروع می‌شه.', style: Theme.of(context).textTheme.bodyMedium)),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text('چند نخ؟', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900)),
              const SizedBox(height: 12),
              Row(
                children: [
                  IconButton.filledTonal(onPressed: count > 1 ? () => setState(() => count--) : null, icon: const Icon(Icons.remove_rounded)),
                  Expanded(child: Center(child: Text('${formatInt(count)} نخ', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: NafasColors.primary)))),
                  IconButton.filled(onPressed: () => setState(() => count++), icon: const Icon(Icons.add_rounded)),
                ],
              ),
              const SizedBox(height: 24),
              const Text('چه چیزی محرکش کرد؟', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900)),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: reasons.map((e) => ChoiceChip(label: Text(e), selected: reason == e, onSelected: (_) => setState(() => reason = e))).toList(),
              ),
              const SizedBox(height: 28),
              FilledButton(
                onPressed: () {
                  NafasScope.of(context).recordSlip(count: count, reason: reason);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('ثبت شد. مسیرت ادامه داره.')));
                },
                child: const Text('ثبت و ادامه مسیر'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
