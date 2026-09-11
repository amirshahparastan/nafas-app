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
  String trigger = 'استرس';
  int phase = 0;
  int seconds = 180;
  Timer? timer;

  static const triggers = [
    ('استرس', Icons.psychology_alt_rounded),
    ('بعد غذا', Icons.restaurant_rounded),
    ('قهوه', Icons.coffee_rounded),
    ('جمع دوستان', Icons.groups_rounded),
    ('بی‌حوصلگی', Icons.sentiment_neutral_rounded),
    ('عادت', Icons.replay_rounded),
  ];

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void start() {
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
    NafasScope.of(context).addCraving(intensity: intensity, trigger: trigger, passed: passed);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(passed ? 'ثبت شد؛ یک موج دیگه رو رد کردی.' : 'ثبت شد؛ مهم اینه که الگو رو شناختی.')),
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
          duration: const Duration(milliseconds: 280),
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
    return SingleChildScrollView(
      key: const ValueKey('start'),
      padding: const EdgeInsets.fromLTRB(18, 10, 18, 30),
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
            'لازم نیست باهاش بجنگی. فقط سه دقیقه به بدنت فرصت بده تا شدت موج پایین بیاد.',
            style: TextStyle(color: Colors.white.withValues(alpha: .72), height: 1.75, fontSize: 13.5),
          ),
          const SizedBox(height: 24),
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
                              style: TextStyle(
                                color: active ? NafasColors.accent : NafasColors.textPrimary,
                                fontWeight: FontWeight.w900,
                              ),
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
                const Text('چی محرکش کرد؟', style: TextStyle(fontWeight: FontWeight.w900, color: NafasColors.textPrimary, fontSize: 16)),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: triggers.map((item) {
                    final active = item.$1 == trigger;
                    return InkWell(
                      onTap: () => setState(() => trigger = item.$1),
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
                            Icon(item.$2, size: 18, color: active ? NafasColors.primary : NafasColors.textMuted),
                            const SizedBox(width: 6),
                            Text(item.$1, style: TextStyle(fontWeight: FontWeight.w800, color: active ? NafasColors.primary : NafasColors.textPrimary)),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          NafasAccentButton(label: 'همین حالا کمکم کن', icon: Icons.bolt_rounded, onPressed: start),
          const SizedBox(height: 9),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(backgroundColor: Colors.white),
              child: const Text('فعلاً برگشت'),
            ),
          ),
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
          const Text('آروم‌تر از موج نفس بکش', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900)),
          const SizedBox(height: 6),
          Text('چهار ثانیه دم، کمی مکث، شش ثانیه بازدم.', style: TextStyle(color: Colors.white.withValues(alpha: .68), fontSize: 13)),
          const SizedBox(height: 28),
          SizedBox(
            width: 220,
            height: 220,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 190,
                  height: 190,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(colors: [Color(0x3300D9A3), Color(0x0800D9A3)]),
                  ),
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
          _whitePanel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('یکی رو همین الان انجام بده', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: NafasColors.textPrimary)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: _Intervention(icon: Icons.water_drop_outlined, label: 'آب بنوش')),
                    const SizedBox(width: 8),
                    Expanded(child: _Intervention(icon: Icons.directions_walk_rounded, label: 'قدم بزن')),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(child: _Intervention(icon: Icons.self_improvement_rounded, label: 'نفس عمیق')),
                    const SizedBox(width: 8),
                    Expanded(child: _Intervention(icon: Icons.music_note_rounded, label: 'حواست رو پرت کن')),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: finishEarly,
              style: OutlinedButton.styleFrom(backgroundColor: Colors.white),
              child: const Text('حالم بهتره؛ بریم نتیجه'),
            ),
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
          const Center(child: Text('سه دقیقه گذشت.', style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.w900))),
          const SizedBox(height: 6),
          Center(
            child: Text('الان شدت هوس چقدره؟', style: TextStyle(color: Colors.white.withValues(alpha: .7), fontSize: 13.5)),
          ),
          const SizedBox(height: 20),
          _whitePanel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                            height: 50,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: active ? NafasColors.surfaceSoft : Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(color: active ? NafasColors.primary : NafasColors.border),
                            ),
                            child: Text(faDigits(value), style: TextStyle(fontWeight: FontWeight.w900, color: active ? NafasColors.primary : NafasColors.textPrimary)),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    const Icon(Icons.trending_down_rounded, color: NafasColors.success),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        afterIntensity < intensity
                            ? 'شدت از ${faDigits(intensity)} به ${faDigits(afterIntensity)} رسیده؛ همین کاهش مهمه.'
                            : 'حتی اگه هنوز شدیده، ثبتش کمک می‌کنه دفعه بعد الگو رو سریع‌تر بشناسی.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          NafasPrimaryButton(label: 'از این هوس عبور کردم', icon: Icons.check_circle_outline_rounded, onPressed: () => save(true)),
          const SizedBox(height: 9),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => save(false),
              style: OutlinedButton.styleFrom(backgroundColor: Colors.white),
              child: const Text('هنوز سخته؛ فقط ثبتش کن'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _whitePanel({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FCFB),
        borderRadius: BorderRadius.circular(23),
        border: Border.all(color: Colors.white),
        boxShadow: const [BoxShadow(color: Color(0x18000000), blurRadius: 28, offset: Offset(0, 12))],
      ),
      child: child,
    );
  }
}

class _Intervention extends StatelessWidget {
  const _Intervention({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 82,
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: NafasColors.border),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: NafasColors.primary, size: 23),
          const SizedBox(height: 7),
          Text(label, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w800, color: NafasColors.textPrimary, fontSize: 12)),
        ],
      ),
    );
  }
}
