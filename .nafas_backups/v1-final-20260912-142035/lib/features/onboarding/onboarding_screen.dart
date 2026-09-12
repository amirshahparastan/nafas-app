import 'package:flutter/material.dart';
import '../../core/state/app_state.dart';
import '../../core/theme/nafas_colors.dart';
import '../../core/theme/nafas_spacing.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/jalali_date_picker.dart';
import '../../core/widgets/nafas_buttons.dart';
import '../../core/widgets/nafas_logo.dart';
import '../../core/widgets/nafas_money_field.dart';
import '../../core/widgets/rtl_icons.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int step = 0;
  int perDay = 10;
  int perPack = 20;
  int packPrice = 85000;
  DateTime quitDate = DateTime.now();
  final goalController = TextEditingController(text: 'سفر رویایی');
  final amountController = TextEditingController(text: '۱۰٬۰۰۰٬۰۰۰');
  final reasonController = TextEditingController();

  @override
  void dispose() {
    goalController.dispose();
    amountController.dispose();
    reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            if (step > 0) _Progress(step: step, onBack: () => setState(() => step--)),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 260),
                child: _content(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _content() {
    switch (step) {
      case 0:
        return _intro();
      case 1:
        return _usage();
      case 2:
        return _quitDate();
      default:
        return _goal();
    }
  }

  Widget _page({required Widget child, required String cta, VoidCallback? onTap}) {
    return SingleChildScrollView(
      key: ValueKey(step),
      padding: const EdgeInsets.fromLTRB(NafasSpacing.page, 20, NafasSpacing.page, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          child,
          const SizedBox(height: 26),
          FilledButton(onPressed: onTap ?? () => setState(() => step++), child: Text(cta)),
        ],
      ),
    );
  }

  Widget _intro() {
    return SingleChildScrollView(
      key: const ValueKey('intro-pro'),
      padding: const EdgeInsets.fromLTRB(NafasSpacing.page, 18, NafasSpacing.page, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const NafasLogo(),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(99),
                  border: Border.all(color: NafasColors.border),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.lock_outline_rounded, size: 15, color: NafasColors.primary),
                    SizedBox(width: 5),
                    Text('خصوصی و بدون قضاوت', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w800)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [Color(0xFF117A64), Color(0xFF083B34)],
              ),
              borderRadius: BorderRadius.circular(30),
              boxShadow: const [
                BoxShadow(color: Color(0x2A083B34), blurRadius: 34, offset: Offset(0, 16)),
              ],
            ),
            child: Stack(
              children: [
                Positioned(
                  left: -16,
                  top: -18,
                  child: Container(
                    width: 118,
                    height: 118,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: .05),
                    ),
                  ),
                ),
                Positioned(
                  right: -28,
                  bottom: -34,
                  child: Container(
                    width: 128,
                    height: 128,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: NafasColors.sun.withValues(alpha: .13),
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: .11),
                        borderRadius: BorderRadius.circular(99),
                      ),
                      child: const Text(
                        'ترک را قابل‌دیدن کن',
                        style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w800),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'فقط روزها رو نشمار؛\nهر روز رو تبدیل به پیشرفت کن.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 27,
                        height: 1.38,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'نفس کنارت می‌مونه تا هوس‌ها رو مدیریت کنی، پول سیگار رو ببینی و برای چیزی که واقعاً می‌خوای جلو بری.',
                      style: TextStyle(color: Colors.white.withValues(alpha: .78), fontSize: 13.5, height: 1.75),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: .09),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white.withValues(alpha: .09)),
                      ),
                      child: const Row(
                        children: [
                          Expanded(child: _HeroMetric(value: '۱۲', label: 'روز پاکی')),
                          _MetricDivider(),
                          Expanded(child: _HeroMetric(value: '۱۸۰', label: 'نخ نکشیدی')),
                          _MetricDivider(),
                          Expanded(child: _HeroMetric(value: '۱٫۸ میلیون', label: 'تومان پس‌انداز')),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          Text('از نفس دقیقاً چی می‌گیری؟', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          const _IntroFeature(
            icon: Icons.air_rounded,
            title: 'کمک در لحظه هوس',
            subtitle: 'شدت هوس، محرک و راهکاری که برای خودت جواب می‌ده رو ثبت و پیدا می‌کنی.',
            tone: NafasColors.accent,
            soft: NafasColors.accentSoft,
          ),
          const _IntroFeature(
            icon: Icons.savings_outlined,
            title: 'هدف مالی واقعی',
            subtitle: 'هزینه سیگار تبدیل می‌شه به پیشرفت روی هدفی که خودت انتخاب کردی.',
            tone: NafasColors.money,
            soft: NafasColors.moneySoft,
          ),
          const _IntroFeature(
            icon: Icons.favorite_border_rounded,
            title: 'انگیزه از آدم‌های واقعی',
            subtitle: 'در دیوار امید پیام کسانی رو می‌بینی که از همین مسیر عبور کردن.',
            tone: NafasColors.lilac,
            soft: NafasColors.lilacSoft,
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: NafasColors.surfaceSoft,
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Row(
              children: [
                Icon(Icons.schedule_rounded, color: NafasColors.primary),
                SizedBox(width: 9),
                Expanded(
                  child: Text(
                    'تنظیم اولیه کمتر از ۲ دقیقه زمان می‌بره. بعداً هر چیزی قابل ویرایشه.',
                    style: TextStyle(fontWeight: FontWeight.w700, height: 1.6),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          NafasPrimaryButton(
            label: 'شروع مسیر من',
            icon: Icons.rocket_launch_rounded,
            onPressed: () => setState(() => step = 1),
          ),
          const SizedBox(height: 10),
          NafasSecondaryButton(
            label: 'درباره ذخیره و بازیابی اطلاعات',
            icon: Icons.cloud_download_outlined,
            onPressed: () => Navigator.pushNamed(context, '/account'),
          ),
          const SizedBox(height: 12),
          Center(
            child: Text(
              'فارسی • تقویم جلالی • ذخیره خودکار روی دستگاه',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }

  Widget _usage() => _page(
        cta: 'ادامه',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('الان الگوی مصرفت چطوره؟', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 8),
            Text('این اطلاعات فقط برای محاسبه دقیق‌تر پیشرفت و پول ذخیره‌شده استفاده می‌شن.', style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 28),
            _StepperCard(
              title: 'تعداد سیگار در روز',
              value: perDay,
              suffix: 'نخ',
              onChanged: (v) => setState(() => perDay = v.clamp(1, 100).toInt()),
            ),
            const SizedBox(height: 12),
            _StepperCard(
              title: 'تعداد سیگار در هر پاکت',
              value: perPack,
              suffix: 'نخ',
              step: 5,
              onChanged: (v) => setState(() => perPack = v.clamp(5, 50).toInt()),
            ),
            const SizedBox(height: 12),
            _StepperCard(
              title: 'قیمت هر پاکت',
              value: packPrice,
              suffix: 'تومان',
              step: 5000,
              min: 5000,
              display: formatInt(packPrice),
              onChanged: (v) => setState(() => packPrice = v.clamp(5000, 5000000).toInt()),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(color: NafasColors.surfaceSoft, borderRadius: BorderRadius.circular(20)),
              child: Row(
                children: [
                  const Icon(Icons.auto_graph_rounded, color: NafasColors.primary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'تقریباً روزی ${formatToman(perDay * (packPrice / perPack))} خرج سیگار می‌شه.',
                      style: const TextStyle(fontWeight: FontWeight.w800, color: NafasColors.textPrimary),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Text('دلیل شخصی تو برای ترک چیه؟', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 6),
            Text('اختیاریه و فقط برای خودت می‌مونه؛ در لحظه‌های هوس بهت یادآوری می‌کنیم.', style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 10),
            TextField(
              controller: reasonController,
              maxLines: 3,
              decoration: const InputDecoration(hintText: 'مثلاً برای سلامتی، خانواده، آرامش یا هزینه‌ها...'),
            ),
          ],
        ),
      );

  Widget _quitDate() => _page(
        cta: 'این تاریخ رو ثبت کن',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('از چه زمانی شروع کردی؟', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 8),
            Text('اگه همین الان شروع می‌کنی، همون گزینه اول رو بزن. اگه قبلاً ترک کردی تاریخش رو انتخاب کن.', style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 28),
            _ChoiceTile(
              selected: DateTime.now().difference(quitDate).inHours.abs() < 2,
              icon: Icons.bolt_rounded,
              title: 'از همین الان',
              subtitle: 'شروع رکورد از همین لحظه',
              onTap: () => setState(() => quitDate = DateTime.now()),
            ),
            const SizedBox(height: 12),
            _ChoiceTile(
              selected: DateTime.now().difference(quitDate).inHours.abs() >= 2,
              icon: Icons.calendar_month_rounded,
              title: 'قبلاً شروع کردم',
              subtitle: 'تاریخ شروع ترک رو انتخاب کن',
              onTap: () async {
                final picked = await showNafasJalaliDatePicker(
                  context: context,
                  firstDate: DateTime(2010),
                  lastDate: DateTime.now(),
                  initialDate: quitDate.isAfter(DateTime.now()) ? DateTime.now() : quitDate,
                );
                if (picked != null) setState(() => quitDate = picked);
              },
            ),
            const SizedBox(height: 18),
            Text('تاریخ انتخاب‌شده: ${formatJalaliDate(quitDate)}', style: const TextStyle(fontWeight: FontWeight.w800, color: NafasColors.primary)),
          ],
        ),
      );

  Widget _goal() => _page(
        cta: 'ورود به نفس',
        onTap: () {
          final amount = NafasMoneyField.parse(amountController, fallback: 10000000);
          NafasScope.of(context).completeSetup(
            perDay: perDay,
            perPack: perPack,
            packPrice: packPrice,
            quitDate: quitDate,
            goal: goalController.text,
            goalAmount: amount,
            quitReason: reasonController.text,
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('پول سیگارت قراره تبدیل به چی بشه؟', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 8),
            Text('هدف مالی باعث می‌شه هر روز ترک، یک نتیجه ملموس هم داشته باشه.', style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 28),
            TextField(
              controller: goalController,
              decoration: const InputDecoration(labelText: 'نام هدف', prefixIcon: Icon(Icons.flag_rounded)),
            ),
            const SizedBox(height: 12),
            NafasMoneyField(
              controller: amountController,
              label: 'مبلغ هدف',
              helperText: 'مبلغ رو کامل وارد کن؛ واحد جدا نمایش داده می‌شه تا خواناتر باشه.',
              presetAmounts: const [5000000, 10000000, 20000000, 50000000],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: ['سفر', 'گوشی', 'طلا', 'هدفون']
                  .map((e) => ActionChip(label: Text(e), onPressed: () => setState(() => goalController.text = e == 'هدفون' ? 'خرید هدفون' : e)))
                  .toList(),
            ),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), border: Border.all(color: NafasColors.border)),
              child: const Row(
                children: [
                  Icon(Icons.cloud_done_outlined, color: NafasColors.primary),
                  SizedBox(width: 9),
                  Expanded(
                    child: Text(
                      'پیشرفتت به‌صورت خودکار روی همین دستگاه ذخیره می‌شه. بکاپ ابری و ورود حساب هنوز فعال نیست و قبل از انتشار آن قابلیت، سیاست حریم خصوصی به‌روزرسانی می‌شود.',
                      style: TextStyle(fontSize: 12.5, height: 1.65, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}

class _HeroMetric extends StatelessWidget {
  const _HeroMetric({required this.value, required this.label});
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FittedBox(fit: BoxFit.scaleDown, child: Text(value, style: const TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.w900))),
        const SizedBox(height: 2),
        Text(label, textAlign: TextAlign.center, style: TextStyle(color: Colors.white.withValues(alpha: .7), fontSize: 10.5, fontWeight: FontWeight.w700)),
      ],
    );
  }
}

class _MetricDivider extends StatelessWidget {
  const _MetricDivider();

  @override
  Widget build(BuildContext context) => Container(width: 1, height: 34, color: Colors.white.withValues(alpha: .13));
}

class _IntroFeature extends StatelessWidget {
  const _IntroFeature({required this.icon, required this.title, required this.subtitle, required this.tone, required this.soft});
  final IconData icon;
  final String title;
  final String subtitle;
  final Color tone;
  final Color soft;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: NafasColors.border),
        boxShadow: const [BoxShadow(color: Color(0x07083B34), blurRadius: 18, offset: Offset(0, 7))],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(color: soft, borderRadius: BorderRadius.circular(14)),
            child: Icon(icon, color: tone),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w900, color: NafasColors.textPrimary)),
                const SizedBox(height: 3),
                Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Progress extends StatelessWidget {
  const _Progress({required this.step, required this.onBack});
  final int step;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 18, 0),
        child: Row(
          children: [
            NafasBackButton(onPressed: onBack),
            const SizedBox(width: 8),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(99),
                child: LinearProgressIndicator(
                  value: step / 3,
                  minHeight: 7,
                  backgroundColor: NafasColors.border,
                  color: NafasColors.primary,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text('${faDigits(step)}/۳', style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      );
}

class _StepperCard extends StatelessWidget {
  const _StepperCard({required this.title, required this.value, required this.suffix, required this.onChanged, this.step = 1, this.min = 1, this.display});
  final String title, suffix;
  final int value, step, min;
  final String? display;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: NafasColors.border)),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.w800, color: NafasColors.textPrimary)),
                  const SizedBox(height: 5),
                  if (suffix == 'تومان')
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(display ?? faDigits(value), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: NafasColors.textPrimary)),
                        const SizedBox(width: 7),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(color: NafasColors.moneySoft, borderRadius: BorderRadius.circular(9)),
                          child: const Text('تومان', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: NafasColors.money)),
                        ),
                      ],
                    )
                  else
                    Text('${display ?? faDigits(value)} $suffix', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: NafasColors.primary)),
                ],
              ),
            ),
            IconButton.filledTonal(onPressed: value - step >= min ? () => onChanged(value - step) : null, icon: const Icon(Icons.remove_rounded)),
            const SizedBox(width: 6),
            IconButton.filled(onPressed: () => onChanged(value + step), icon: const Icon(Icons.add_rounded)),
          ],
        ),
      );
}

class _ChoiceTile extends StatelessWidget {
  const _ChoiceTile({required this.selected, required this.icon, required this.title, required this.subtitle, required this.onTap});
  final bool selected;
  final IconData icon;
  final String title, subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.all(17),
          decoration: BoxDecoration(
            color: selected ? NafasColors.surfaceSoft : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: selected ? NafasColors.primary : NafasColors.border, width: selected ? 1.4 : 1),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(color: selected ? Colors.white : NafasColors.surfaceSoft, borderRadius: BorderRadius.circular(14)),
                child: Icon(icon, color: NafasColors.primary),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.w900, color: NafasColors.textPrimary)),
                    const SizedBox(height: 3),
                    Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
              Icon(selected ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded, color: selected ? NafasColors.primary : NafasColors.textMuted),
            ],
          ),
        ),
      );
}
