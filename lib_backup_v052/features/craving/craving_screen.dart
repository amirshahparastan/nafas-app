import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/state/app_state.dart';
import '../../core/theme/nafas_colors.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/nafas_buttons.dart';
import '../../core/widgets/rtl_app_bar.dart';

class CravingScreen extends StatefulWidget {
  const CravingScreen({super.key});

  @override
  State<CravingScreen> createState() => _CravingScreenState();
}

class _CravingScreenState extends State<CravingScreen> {
  int intensity = 3;
  int afterIntensity = 2;
  int phase = 0;
  int seconds = 180;
  Timer? timer;

  String trigger = 'استرس';
  String intervention = 'تنفس آرام';
  final customTriggerController = TextEditingController();
  final customInterventionController = TextEditingController();

  static const triggers = [
    ('استرس', Icons.psychology_alt_rounded),
    ('بعد غذا', Icons.restaurant_rounded),
    ('قهوه', Icons.coffee_rounded),
    ('جمع دوستان', Icons.groups_rounded),
    ('بی‌حوصلگی', Icons.sentiment_neutral_rounded),
    ('عادت', Icons.replay_rounded),
  ];

  static const interventions = [
    ('تنفس آرام', '۳ دقیقه با ریتم هدایت‌شده', Icons.air_rounded),
    ('آب بنوش', 'یک لیوان آب و چند ثانیه مکث', Icons.water_drop_outlined),
    ('کمی قدم بزن', 'محیط رو عوض کن و حرکت کن', Icons.directions_walk_rounded),
    ('تغییر فضا', 'از محرک فاصله بگیر', Icons.door_front_door_outlined),
  ];

  @override
  void dispose() {
    timer?.cancel();
    customTriggerController.dispose();
    customInterventionController.dispose();
    super.dispose();
  }

  void start() {
    final customTrigger = customTriggerController.text.trim();
    if (customTrigger.isNotEmpty) trigger = customTrigger;
    final customIntervention = customInterventionController.text.trim();
    if (customIntervention.isNotEmpty) intervention = customIntervention;

    setState(() => phase = 1);
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      if (seconds <= 1) {
        t.cancel();
        setState(() {
          seconds = 0;
          phase = 2;
        });
      } else {
        setState(() => seconds--);
      }
    });
  }

  void finishEarly() {
    timer?.cancel();
    setState(() => phase = 2);
  }

  void save(bool passed) {
    NafasScope.of(context).addCraving(
      intensity: intensity,
      trigger: trigger,
      intervention: intervention,
      passed: passed,
    );
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(passed ? 'ثبت شد؛ یک موج دیگه رو رد کردی.' : 'ثبت شد؛ همین شناختن الگو هم پیشرفته.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NafasColors.primaryDark,
      appBar: const RtlAppBar(title: 'مدیریت هوس', dark: true),
      body: SafeArea(
        top: false,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 260),
          child: switch (phase) {
            0 => _startStep(),
            1 => _sessionStep(),
            _ => _resultStep(),
          },
        ),
      ),
    );
  }

  Widget _startStep() {
    final state = NafasScope.of(context);
    final remembered = state.customTriggers.reversed.take(3).toList();

    return SingleChildScrollView(
      key: const ValueKey('start'),
      padding: const EdgeInsets.fromLTRB(18, 8, 18, 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: const BoxDecoration(color: Color(0x18FFFFFF), shape: BoxShape.circle),
            child: const Icon(Icons.air_rounded, color: Color(0xFFB9F3DC), size: 30),
          ),
          const SizedBox(height: 18),
          const Text('این حس موقتیه.', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w900, height: 1.3)),
          const SizedBox(height: 7),
          Text(
            'اول فقط شدت و محرک رو ثبت کن. بعد یک راهکار کوتاه و مناسب انتخاب می‌کنیم.',
            style: TextStyle(color: Colors.white.withValues(alpha: .72), height: 1.75, fontSize: 13.5),
          ),
          if (state.personalQuitReason.trim().isNotEmpty) ...[
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: .08),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.white.withValues(alpha: .08)),
              ),
              child: Text('یادت باشه چرا شروع کردی: ${state.personalQuitReason}', style: const TextStyle(color: Color(0xFFE5FFF5), fontWeight: FontWeight.w700, height: 1.55)),
            ),
          ],
          const SizedBox(height: 22),
          _whitePanel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('شدت هوس الان چقدره؟', style: TextStyle(fontWeight: FontWeight.w900, color: NafasColors.textPrimary, fontSize: 16)),
                const SizedBox(height: 13),
                Row(
                  children: List.generate(5, (i) {
                    final value = i + 1;
                    final active = value == intensity;
                    return Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: i < 4 ? 7 : 0),
                        child: InkWell(
                          onTap: () => setState(() => intensity = value),
                          borderRadius: BorderRadius.circular(15),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            height: 50,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: active ? NafasColors.accentSoft : Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(color: active ? NafasColors.accent : NafasColors.border),
                            ),
                            child: Text(
                              faDigits(value),
                              style: TextStyle(color: active ? NafasColors.accent : NafasColors.textPrimary, fontWeight: FontWeight.w900),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 7),
                Text('۱ کم  •  ۵ خیلی شدید', style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _whitePanel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('چی باعث شد هوس کنی؟', style: TextStyle(fontWeight: FontWeight.w900, color: NafasColors.textPrimary, fontSize: 16)),
                const SizedBox(height: 4),
                Text('این‌ها فقط پیشنهادن؛ اگه محرک تو چیز دیگه‌ایه، خودت بنویس.', style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ...triggers.map((item) => _TriggerChip(
                          label: item.$1,
                          icon: item.$2,
                          active: customTriggerController.text.trim().isEmpty && trigger == item.$1,
                          onTap: () {
                            customTriggerController.clear();
                            setState(() => trigger = item.$1);
                          },
                        )),
                    ...remembered.map((item) => _TriggerChip(
                          label: item,
                          icon: Icons.history_rounded,
                          active: customTriggerController.text.trim().isEmpty && trigger == item,
                          onTap: () {
                            customTriggerController.clear();
                            setState(() => trigger = item);
                          },
                        )),
                  ],
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: customTriggerController,
                  textInputAction: TextInputAction.done,
                  onChanged: (_) => setState(() {}),
                  decoration: const InputDecoration(
                    labelText: 'محرک دیگه‌ای داشتم',
                    hintText: 'مثلاً رانندگی، تماس کاری، بوی سیگار...',
                    prefixIcon: Icon(Icons.edit_outlined),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _whitePanel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.auto_awesome_rounded, color: NafasColors.primary),
                    SizedBox(width: 8),
                    Text('راهکار فوری', style: TextStyle(fontWeight: FontWeight.w900, color: NafasColors.textPrimary, fontSize: 16)),
                  ],
                ),
                const SizedBox(height: 4),
                Text('یکی رو انتخاب کن؛ بعداً نفس یاد می‌گیره کدوم راهکار برای تو بهتر جواب می‌ده.', style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(height: 12),
                ...interventions.map((item) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: _InterventionChoice(
                        title: item.$1,
                        subtitle: item.$2,
                        icon: item.$3,
                        active: customInterventionController.text.trim().isEmpty && intervention == item.$1,
                        onTap: () {
                          customInterventionController.clear();
                          setState(() => intervention = item.$1);
                        },
                      ),
                    )),
                TextField(
                  controller: customInterventionController,
                  onChanged: (_) => setState(() {}),
                  decoration: const InputDecoration(
                    labelText: 'راهکار شخصی من',
                    hintText: 'مثلاً تماس با مهدیه، آدامس، رفتن به بالکن...',
                    prefixIcon: Icon(Icons.favorite_outline_rounded),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          NafasAccentButton(label: 'سه دقیقه با من بمون', icon: Icons.bolt_rounded, onPressed: start),
          const SizedBox(height: 9),
          NafasSecondaryButton(label: 'فعلاً برگشت', onPressed: () => Navigator.pop(context)),
        ],
      ),
    );
  }

  Widget _sessionStep() {
    final progress = 1 - (seconds / 180);
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    final time = '${faDigits(minutes)}:${faDigits(secs.toString().padLeft(2, '0'))}';

    return SingleChildScrollView(
      key: const ValueKey('session'),
      padding: const EdgeInsets.fromLTRB(18, 8, 18, 30),
      child: Column(
        children: [
          const SizedBox(height: 6),
          const Text('فقط همین سه دقیقه', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900)),
          const SizedBox(height: 6),
          Text('محرک: $trigger', style: TextStyle(color: Colors.white.withValues(alpha: .62), fontSize: 13)),
          const SizedBox(height: 24),
          SizedBox(
            width: 220,
            height: 220,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 190,
                  height: 190,
                  decoration: const BoxDecoration(shape: BoxShape.circle, gradient: RadialGradient(colors: [Color(0x3300D9A3), Color(0x0800D9A3)])),
                ),
                SizedBox(
                  width: 190,
                  height: 190,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 8,
                    backgroundColor: const Color(0x18FFFFFF),
                    valueColor: const AlwaysStoppedAnimation(Color(0xFF6DE4BC)),
                    strokeCap: StrokeCap.round,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.air_rounded, color: Color(0xFFB9F3DC), size: 30),
                    const SizedBox(height: 8),
                    Text(time, textDirection: TextDirection.ltr, style: const TextStyle(color: Colors.white, fontSize: 34, fontWeight: FontWeight.w900)),
                    const SizedBox(height: 3),
                    Text('تا پایان تمرین', style: TextStyle(color: Colors.white.withValues(alpha: .58), fontSize: 11)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          _SelectedInterventionCard(intervention: intervention),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(onPressed: finishEarly, style: OutlinedButton.styleFrom(backgroundColor: Colors.white), child: const Text('حالم بهتره؛ بریم نتیجه')),
          ),
        ],
      ),
    );
  }

  Widget _resultStep() {
    return SingleChildScrollView(
      key: const ValueKey('result'),
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 82,
              height: 82,
              decoration: const BoxDecoration(color: Color(0x1C6DE4BC), shape: BoxShape.circle),
              child: const Icon(Icons.check_rounded, color: Color(0xFF83E9C7), size: 46),
            ),
          ),
          const SizedBox(height: 20),
          const Center(child: Text('موج رو ثبت کردیم.', style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.w900))),
          const SizedBox(height: 6),
          Center(child: Text('الان شدت هوس چقدره؟', style: TextStyle(color: Colors.white.withValues(alpha: .7), fontSize: 13.5))),
          const SizedBox(height: 18),
          Row(
            children: List.generate(5, (i) {
              final value = i + 1;
              final active = value == afterIntensity;
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: i < 4 ? 7 : 0),
                  child: InkWell(
                    onTap: () => setState(() => afterIntensity = value),
                    borderRadius: BorderRadius.circular(15),
                    child: Container(
                      height: 48,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: active ? const Color(0xFFE8FFF6) : Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: active ? const Color(0xFF6DE4BC) : Colors.white),
                      ),
                      child: Text(faDigits(value), style: TextStyle(fontWeight: FontWeight.w900, color: active ? NafasColors.primaryDark : NafasColors.textPrimary)),
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('برای یادگیری بهتر نفس', style: TextStyle(fontWeight: FontWeight.w900, color: NafasColors.textPrimary)),
                const SizedBox(height: 6),
                Text('محرک: $trigger', style: Theme.of(context).textTheme.bodySmall),
                Text('راهکار: $intervention', style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(height: 5),
                Text('بعداً از این الگوها برای پیشنهادهای شخصی‌تر استفاده می‌کنیم.', style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
          const SizedBox(height: 14),
          NafasPrimaryButton(label: 'هوس کمتر شد', icon: Icons.check_circle_outline_rounded, onPressed: () => save(true)),
          const SizedBox(height: 9),
          NafasSecondaryButton(label: 'هنوز شدیده؛ فقط ثبتش کن', onPressed: () => save(false)),
        ],
      ),
    );
  }

  Widget _whitePanel({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [BoxShadow(color: Color(0x13000000), blurRadius: 24, offset: Offset(0, 10))],
      ),
      child: child,
    );
  }
}

class _SelectedInterventionCard extends StatelessWidget {
  const _SelectedInterventionCard({required this.intervention});

  final String intervention;

  (IconData, String, List<String>) get _content {
    switch (intervention) {
      case 'تنفس آرام':
        return (
          Icons.air_rounded,
          'ریتم کوتاه برای عبور از موج هوس',
          ['۴ ثانیه دم', '۲ ثانیه مکث', '۶ ثانیه بازدم'],
        );
      case 'آب بنوش':
        return (
          Icons.water_drop_rounded,
          'تمرکز حواس را برای چند لحظه جابه‌جا کن',
          ['یک لیوان آب', 'آهسته بنوش', '۳۰ ثانیه مکث'],
        );
      case 'کمی قدم بزن':
        return (
          Icons.directions_walk_rounded,
          'بدنت را از موقعیت فعلی بیرون ببر',
          ['بلند شو', 'چند دقیقه حرکت کن', 'محیط را عوض کن'],
        );
      case 'تغییر فضا':
        return (
          Icons.door_front_door_rounded,
          'فاصله گرفتن از محرک، شدت هوس را کم می‌کند',
          ['از محرک دور شو', 'هوای تازه', 'چند دقیقه صبر'],
        );
      default:
        return (
          Icons.favorite_rounded,
          'این راهکار شخصی خودته؛ همون چیزی که برای تو جواب می‌ده.',
          ['آرام انجامش بده', 'به حس بدنت توجه کن', 'بعد نتیجه را ثبت کن'],
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = _content;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFD9EEE7)),
        boxShadow: const [
          BoxShadow(color: Color(0x16000000), blurRadius: 26, offset: Offset(0, 12)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: NafasColors.surfaceSoft,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Text(
                  'راهکار فعلی',
                  style: TextStyle(
                    color: NafasColors.primary,
                    fontWeight: FontWeight.w900,
                    fontSize: 11.5,
                  ),
                ),
              ),
              const Spacer(),
              const Icon(Icons.auto_awesome_rounded, color: NafasColors.success, size: 20),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFE8F8F2), Color(0xFFF7FCFA)],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                  ),
                  borderRadius: BorderRadius.circular(17),
                  border: Border.all(color: const Color(0xFFD8EEE6)),
                ),
                child: Icon(data.$1, color: NafasColors.primary, size: 27),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      intervention,
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        color: NafasColors.textPrimary,
                        fontSize: 17,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      data.$2,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(height: 1.55),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
            decoration: BoxDecoration(
              color: NafasColors.background,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Wrap(
              spacing: 7,
              runSpacing: 7,
              children: data.$3
                  .map(
                    (step) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(color: NafasColors.border),
                      ),
                      child: Text(
                        step,
                        style: const TextStyle(
                          color: NafasColors.textSecondary,
                          fontWeight: FontWeight.w700,
                          fontSize: 11.5,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _TriggerChip extends StatelessWidget {
  const _TriggerChip({required this.label, required this.icon, required this.active, required this.onTap});

  final String label;
  final IconData icon;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 10),
        decoration: BoxDecoration(
          color: active ? NafasColors.surfaceSoft : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: active ? NafasColors.primary.withValues(alpha: .4) : NafasColors.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: active ? NafasColors.primary : NafasColors.textMuted),
            const SizedBox(width: 6),
            Text(label, style: TextStyle(fontWeight: FontWeight.w800, color: active ? NafasColors.primary : NafasColors.textPrimary)),
          ],
        ),
      ),
    );
  }
}

class _InterventionChoice extends StatelessWidget {
  const _InterventionChoice({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.active,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: active ? NafasColors.surfaceSoft : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: active ? NafasColors.primary.withValues(alpha: .35) : NafasColors.border),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(color: active ? Colors.white : NafasColors.background, borderRadius: BorderRadius.circular(13)),
              child: Icon(icon, color: active ? NafasColors.primary : NafasColors.textMuted),
            ),
            const SizedBox(width: 11),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.w900, color: NafasColors.textPrimary)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
            Icon(active ? Icons.check_circle_rounded : Icons.circle_outlined, color: active ? NafasColors.primary : NafasColors.border),
          ],
        ),
      ),
    );
  }
}
