import 'package:flutter/material.dart';
import '../../core/state/app_state.dart';
import '../../core/theme/nafas_colors.dart';
import '../../core/theme/nafas_spacing.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/nafas_logo.dart';
import '../../core/widgets/nature_backdrop.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int step = 0;
  int perDay = 10;
  int perPack = 20;
  int packPrice = 85000;
  DateTime quitDate = DateTime.now();
  final goalController = TextEditingController(text: 'سفر رویایی');
  final amountController = TextEditingController(text: '10000000');

  @override
  void dispose() { goalController.dispose(); amountController.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(children: [
          if (step > 0) _Progress(step: step, onBack: () => setState(() => step--)),
          Expanded(child: AnimatedSwitcher(duration: const Duration(milliseconds: 260), child: _content())),
        ]),
      ),
    );
  }

  Widget _content() {
    switch (step) {
      case 0: return _intro();
      case 1: return _usage();
      case 2: return _quitDate();
      default: return _goal();
    }
  }

  Widget _page({required Widget child, required String cta, VoidCallback? onTap}) {
    return SingleChildScrollView(
      key: ValueKey(step),
      padding: const EdgeInsets.fromLTRB(NafasSpacing.page, 20, NafasSpacing.page, 24),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        child,
        const SizedBox(height: 26),
        FilledButton(onPressed: onTap ?? () => setState(() => step++), child: Text(cta)),
      ]),
    );
  }

  Widget _intro() => _page(
    cta: 'شروع مسیر من',
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Center(child: NafasLogo()),
      const SizedBox(height: 22),
      Stack(alignment: Alignment.bottomCenter, children: [
        const NatureBackdrop(height: 300),
        Padding(padding: const EdgeInsets.all(24), child: Column(children: [
          Text('زندگی بزرگ‌تر از یک نخ سیگاره.', textAlign: TextAlign.center, style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: 10),
          Text('با نفس، هم ترک رو قابل‌دیدن می‌کنی، هم پول سیگار رو تبدیل می‌کنی به چیزی که واقعاً می‌خوای.', textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyMedium),
        ])),
      ]),
      const SizedBox(height: 20),
      const _Benefit(icon: Icons.favorite_rounded, title: 'پیشرفت واقعی', subtitle: 'روزها، هوس‌ها و نقاط سختت رو می‌بینی.'),
      const _Benefit(icon: Icons.savings_rounded, title: 'پول قابل لمس', subtitle: 'هزینه سیگار به پیشرفت هدف مالی تبدیل می‌شه.'),
      const _Benefit(icon: Icons.air_rounded, title: 'کمک در لحظه هوس', subtitle: 'یک مسیر کوتاه و بدون قضاوت برای عبور از لحظه سخت.'),
    ]),
  );

  Widget _usage() => _page(
    cta: 'ادامه',
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('الان الگوی مصرفت چطوره؟', style: Theme.of(context).textTheme.headlineMedium),
      const SizedBox(height: 8),
      Text('این اطلاعات فقط برای محاسبه دقیق‌تر پیشرفت و پول ذخیره‌شده استفاده می‌شن.', style: Theme.of(context).textTheme.bodyMedium),
      const SizedBox(height: 28),
      _StepperCard(title: 'تعداد سیگار در روز', value: perDay, suffix: 'نخ', onChanged: (v) => setState(() => perDay = v.clamp(1, 100).toInt())),
      const SizedBox(height: 12),
      _StepperCard(title: 'تعداد سیگار در هر پاکت', value: perPack, suffix: 'نخ', step: 5, onChanged: (v) => setState(() => perPack = v.clamp(5, 50).toInt())),
      const SizedBox(height: 12),
      _StepperCard(title: 'قیمت هر پاکت', value: packPrice, suffix: 'تومان', step: 5000, min: 5000, display: formatInt(packPrice), onChanged: (v) => setState(() => packPrice = v.clamp(5000, 5000000).toInt())),
      const SizedBox(height: 16),
      Container(padding: const EdgeInsets.all(18), decoration: BoxDecoration(color: NafasColors.surfaceSoft, borderRadius: BorderRadius.circular(20)), child: Row(children: [
        const Icon(Icons.auto_graph_rounded, color: NafasColors.primary), const SizedBox(width: 12),
        Expanded(child: Text('تقریباً روزی ${formatToman(perDay * (packPrice / perPack))} خرج سیگار می‌شه.', style: const TextStyle(fontWeight: FontWeight.w800, color: NafasColors.textPrimary))),
      ])),
    ]),
  );

  Widget _quitDate() => _page(
    cta: 'این تاریخ رو ثبت کن',
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('از چه زمانی شروع کردی؟', style: Theme.of(context).textTheme.headlineMedium),
      const SizedBox(height: 8),
      Text('اگه همین الان شروع می‌کنی، همون گزینه اول رو بزن. اگه قبلاً ترک کردی تاریخش رو انتخاب کن.', style: Theme.of(context).textTheme.bodyMedium),
      const SizedBox(height: 28),
      _ChoiceTile(selected: DateTime.now().difference(quitDate).inHours.abs() < 2, icon: Icons.bolt_rounded, title: 'از همین الان', subtitle: 'شروع رکورد از همین لحظه', onTap: () => setState(() => quitDate = DateTime.now())),
      const SizedBox(height: 12),
      _ChoiceTile(selected: DateTime.now().difference(quitDate).inHours.abs() >= 2, icon: Icons.calendar_month_rounded, title: 'قبلاً شروع کردم', subtitle: 'تاریخ شروع ترک رو انتخاب کن', onTap: () async {
        final picked = await showDatePicker(context: context, firstDate: DateTime(2010), lastDate: DateTime.now(), initialDate: quitDate.isAfter(DateTime.now()) ? DateTime.now() : quitDate);
        if (picked != null) setState(() => quitDate = picked);
      }),
      const SizedBox(height: 18),
      Text('تاریخ انتخاب‌شده: ${faDigits('${quitDate.year}/${quitDate.month}/${quitDate.day}')}', style: const TextStyle(fontWeight: FontWeight.w800, color: NafasColors.primary)),
    ]),
  );

  Widget _goal() => _page(
    cta: 'ورود به نفس',
    onTap: () {
      final amount = int.tryParse(amountController.text.replaceAll(',', '').replaceAll('٬', '')) ?? 10000000;
      NafasScope.of(context).completeSetup(perDay: perDay, perPack: perPack, packPrice: packPrice, quitDate: quitDate, goal: goalController.text, goalAmount: amount);
    },
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('پول سیگارت قراره تبدیل به چی بشه؟', style: Theme.of(context).textTheme.headlineMedium),
      const SizedBox(height: 8),
      Text('هدف مالی باعث می‌شه هر روز ترک، یک نتیجه ملموس هم داشته باشه.', style: Theme.of(context).textTheme.bodyMedium),
      const SizedBox(height: 28),
      TextField(controller: goalController, decoration: const InputDecoration(labelText: 'نام هدف', prefixIcon: Icon(Icons.flag_rounded))),
      const SizedBox(height: 12),
      TextField(controller: amountController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'مبلغ هدف (تومان)', prefixIcon: Icon(Icons.payments_outlined))),
      const SizedBox(height: 16),
      Wrap(spacing: 8, runSpacing: 8, children: ['سفر', 'گوشی', 'طلا', 'هدفون'].map((e) => ActionChip(label: Text(e), onPressed: () => setState(() => goalController.text = e == 'هدفون' ? 'خرید هدفون' : e))).toList()),
    ]),
  );
}

class _Progress extends StatelessWidget {
  const _Progress({required this.step, required this.onBack}); final int step; final VoidCallback onBack;
  @override Widget build(BuildContext context) => Padding(padding: const EdgeInsets.fromLTRB(12, 8, 18, 0), child: Row(children: [
    IconButton(onPressed: onBack, icon: const Icon(Icons.arrow_forward_rounded)),
    const SizedBox(width: 8),
    Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(99), child: LinearProgressIndicator(value: step / 3, minHeight: 7, backgroundColor: NafasColors.border, color: NafasColors.primary))),
    const SizedBox(width: 12), Text('${faDigits(step)}/۳', style: Theme.of(context).textTheme.bodySmall),
  ]));
}

class _Benefit extends StatelessWidget {
  const _Benefit({required this.icon, required this.title, required this.subtitle}); final IconData icon; final String title; final String subtitle;
  @override Widget build(BuildContext context) => Padding(padding: const EdgeInsets.only(bottom: 12), child: Row(children: [
    Container(width: 46, height: 46, decoration: BoxDecoration(color: NafasColors.surfaceSoft, borderRadius: BorderRadius.circular(15)), child: Icon(icon, color: NafasColors.primary)),
    const SizedBox(width: 13), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.w900, color: NafasColors.textPrimary)), const SizedBox(height: 2), Text(subtitle, style: Theme.of(context).textTheme.bodySmall)])),
  ]));
}

class _StepperCard extends StatelessWidget {
  const _StepperCard({required this.title, required this.value, required this.suffix, required this.onChanged, this.step = 1, this.min = 1, this.display});
  final String title, suffix; final int value, step, min; final String? display; final ValueChanged<int> onChanged;
  @override Widget build(BuildContext context) => Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: NafasColors.border)), child: Row(children: [
    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.w800, color: NafasColors.textPrimary)), const SizedBox(height: 5), Text('${display ?? faDigits(value)} $suffix', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: NafasColors.primary))])),
    IconButton.filledTonal(onPressed: value - step >= min ? () => onChanged(value-step) : null, icon: const Icon(Icons.remove_rounded)), const SizedBox(width: 6), IconButton.filled(onPressed: () => onChanged(value+step), icon: const Icon(Icons.add_rounded)),
  ]));
}

class _ChoiceTile extends StatelessWidget {
  const _ChoiceTile({required this.selected, required this.icon, required this.title, required this.subtitle, required this.onTap});
  final bool selected; final IconData icon; final String title, subtitle; final VoidCallback onTap;
  @override Widget build(BuildContext context) => InkWell(onTap: onTap, borderRadius: BorderRadius.circular(20), child: AnimatedContainer(duration: const Duration(milliseconds: 180), padding: const EdgeInsets.all(17), decoration: BoxDecoration(color: selected ? NafasColors.surfaceSoft : Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: selected ? NafasColors.primary : NafasColors.border, width: selected ? 1.4 : 1)), child: Row(children: [
    Container(width: 44, height: 44, decoration: BoxDecoration(color: selected ? Colors.white : NafasColors.surfaceSoft, borderRadius: BorderRadius.circular(14)), child: Icon(icon, color: NafasColors.primary)), const SizedBox(width: 13),
    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.w900, color: NafasColors.textPrimary)), const SizedBox(height: 3), Text(subtitle, style: Theme.of(context).textTheme.bodySmall)])),
    Icon(selected ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded, color: selected ? NafasColors.primary : NafasColors.textMuted),
  ])));
}
