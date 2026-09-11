import 'package:flutter/material.dart';
import '../../core/state/app_state.dart';
import '../../core/theme/nafas_colors.dart';
import '../../core/theme/nafas_spacing.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/nafas_card.dart';
import '../../core/widgets/nafas_logo.dart';
import '../../core/widgets/nature_backdrop.dart';
import '../../core/widgets/section_title.dart';
import '../../core/widgets/stat_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = NafasScope.of(context);
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(NafasSpacing.page, 14, NafasSpacing.page, 126),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _Header(onSettings: () => Navigator.pushNamed(context, '/settings')),
                const SizedBox(height: 20),
                _Hero(state: state),
                const SizedBox(height: 14),
                Row(
                  children: [
                    StatCard(icon: Icons.smoke_free_rounded, value: '${formatInt(state.cigarettesAvoided)} نخ', label: 'سیگار نکشیدی'),
                    const SizedBox(width: 12),
                    StatCard(icon: Icons.account_balance_wallet_outlined, value: formatToman(state.moneySaved), label: 'ذخیره کردی'),
                  ],
                ),
                const SizedBox(height: 16),
                _CravingButton(onTap: () => Navigator.pushNamed(context, '/craving')),
                const SizedBox(height: 28),
                SectionTitle(title: 'هدف مالی من', action: 'جزئیات', onAction: () => state.setTab(3)),
                const SizedBox(height: 10),
                _GoalCard(state: state, onTap: () => state.setTab(3)),
                const SizedBox(height: 28),
                SectionTitle(title: 'دیوار امید', action: 'همه پیام‌ها', onAction: () => state.setTab(2)),
                const SizedBox(height: 10),
                _HopePreview(state: state, onTap: () => state.setTab(2)),
                const SizedBox(height: 28),
                SectionTitle(title: 'امروز حواست به چی باشه؟', action: 'سلامت', onAction: () => state.setTab(1)),
                const SizedBox(height: 10),
                _DailyInsight(state: state, onTap: () => state.setTab(1)),
                const SizedBox(height: 14),
                _SmartCoach(state: state),
                const SizedBox(height: 28),
                const SectionTitle(title: 'ابزارهای مسیر'),
                const SizedBox(height: 10),
                Row(children: [
                  Expanded(child: _QuickAction(icon: Icons.calendar_month_rounded, label: 'تقویم نفس', onTap: () => Navigator.pushNamed(context, '/calendar'))),
                  const SizedBox(width: 10),
                  Expanded(child: _QuickAction(icon: Icons.edit_note_rounded, label: 'حال امروز', onTap: () => Navigator.pushNamed(context, '/journal'))),
                ]),
                const SizedBox(height: 10),
                Row(children: [
                  Expanded(child: _QuickAction(icon: Icons.emoji_events_rounded, label: 'دستاوردها', onTap: () => Navigator.pushNamed(context, '/achievements'))),
                  const SizedBox(width: 10),
                  Expanded(child: _QuickAction(icon: Icons.health_and_safety_rounded, label: 'کمک فوری', onTap: () => Navigator.pushNamed(context, '/help'))),
                ]),
                const SizedBox(height: 10),
                _QuickAction(icon: Icons.history_rounded, label: 'ثبت لغزش بدون پاک شدن سابقه مسیر', onTap: () => Navigator.pushNamed(context, '/slip')),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.onSettings});
  final VoidCallback onSettings;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const NafasLogo(compact: true),
        const SizedBox(width: 10),
        Expanded(child: Text(formatJalaliDate(DateTime.now()), maxLines: 1, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.bodySmall)),
        IconButton.filledTonal(
          tooltip: 'تنظیمات',
          onPressed: onSettings,
          icon: const Icon(Icons.settings_outlined),
          style: IconButton.styleFrom(backgroundColor: Colors.white, foregroundColor: NafasColors.primary),
        ),
      ],
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero({required this.state});
  final NafasAppState state;

  @override
  Widget build(BuildContext context) {
    final days = state.smokeFreeDays;
    final progress = ((days % 7) / 7).clamp(.05, 1.0).toDouble();
    final next = 7 - (days % 7);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: const [BoxShadow(color: Color(0x25083B34), blurRadius: 36, offset: Offset(0, 16))],
      ),
      child: Stack(
        children: [
          const NatureBackdrop(dark: true, height: 250),
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
                        decoration: BoxDecoration(color: const Color(0x22FFFFFF), borderRadius: BorderRadius.circular(99)),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.verified_rounded, size: 15, color: Color(0xFFC7F5DE)),
                            SizedBox(width: 5),
                            Text('مسیر فعلی', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w800)),
                          ],
                        ),
                      ),
                      const Spacer(),
                      const Icon(Icons.eco_rounded, color: Color(0xFFC7F5DE)),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    days == 0 ? 'امروز، روز اولته' : '${formatInt(days)} روز پاکی',
                    style: const TextStyle(color: Colors.white, fontSize: 31, fontWeight: FontWeight.w900, height: 1.25),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    days == 0 ? 'شروع کوچک؛ نتیجه بزرگ.' : 'این رکورد رو خودت ساختی. فقط امروز رو ادامه بده.',
                    style: TextStyle(color: Colors.white.withValues(alpha: .84), fontSize: 13, height: 1.6),
                  ),
                  const SizedBox(height: 18),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(99),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 8,
                      backgroundColor: const Color(0x33FFFFFF),
                      valueColor: const AlwaysStoppedAnimation(Colors.white),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('تا نشان هفتگی بعدی: ${formatInt(next)} روز', style: TextStyle(color: Colors.white.withValues(alpha: .76), fontSize: 11)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CravingButton extends StatelessWidget {
  const _CravingButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(23),
      child: Ink(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Color(0xFFFF8C68), NafasColors.accent]),
          borderRadius: BorderRadius.circular(23),
          boxShadow: const [BoxShadow(color: Color(0x35FF7A59), blurRadius: 28, offset: Offset(0, 12))],
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: const BoxDecoration(color: Color(0x24FFFFFF), shape: BoxShape.circle),
              child: const Icon(Icons.air_rounded, color: Colors.white),
            ),
            const SizedBox(width: 13),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('الان هوس کردم', style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w900)),
                  SizedBox(height: 3),
                  Text('چند دقیقه با هم از موجش رد می‌شیم', style: TextStyle(color: Color(0xEAFFFFFF), fontSize: 11.5)),
                ],
              ),
            ),
            Container(
              width: 38,
              height: 38,
              decoration: const BoxDecoration(color: Color(0x20FFFFFF), shape: BoxShape.circle),
              child: const Icon(Icons.chevron_left_rounded, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

class _GoalCard extends StatelessWidget {
  const _GoalCard({required this.state, required this.onTap});
  final NafasAppState state;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    if (!state.hasGoal) {
      return NafasCard(
        onTap: onTap,
        child: const Row(
          children: [
            Icon(Icons.flag_outlined, color: NafasColors.primary),
            SizedBox(width: 12),
            Expanded(child: Text('هنوز هدف مالی نداری؛ یه چیز واقعی برای پول سیگارت انتخاب کن.', style: TextStyle(fontWeight: FontWeight.w800, color: NafasColors.textPrimary))),
            Icon(Icons.chevron_left_rounded, color: NafasColors.textMuted),
          ],
        ),
      );
    }

    return NafasCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(color: NafasColors.surfaceSoft, borderRadius: BorderRadius.circular(16)),
                child: const Icon(Icons.flag_rounded, color: NafasColors.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(state.goalTitle, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: NafasColors.textPrimary)),
                    const SizedBox(height: 3),
                    Text('${formatToman(state.moneySaved)} از ${formatToman(state.goalAmountToman.toDouble())}', style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
              Text('${formatInt((state.goalProgress * 100).round())}٪', style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w900, color: NafasColors.primary)),
            ],
          ),
          const SizedBox(height: 17),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              value: state.goalProgress,
              minHeight: 10,
              backgroundColor: NafasColors.surfaceSoft,
              valueColor: const AlwaysStoppedAnimation(NafasColors.success),
            ),
          ),
          const SizedBox(height: 11),
          Text(
            state.goalProgress >= 1 ? 'تبریک! هدفت کامل شده 🎉' : 'با همین روند، حدود ${formatInt(state.estimatedGoalDaysRemaining)} روز دیگه به هدفت می‌رسی ✨',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _HopePreview extends StatelessWidget {
  const _HopePreview({required this.state, required this.onTap});
  final NafasAppState state;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final posts = state.visibleHopePosts;
    if (posts.isEmpty) {
      return NafasCard(
        onTap: onTap,
        child: const Row(
          children: [
            Icon(Icons.volunteer_activism_outlined, color: NafasColors.primary),
            SizedBox(width: 12),
            Expanded(child: Text('اولین پیام امید رو تو بنویس.', style: TextStyle(fontWeight: FontWeight.w800))),
            Icon(Icons.chevron_left_rounded),
          ],
        ),
      );
    }
    final post = posts.first;
    return NafasCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(color: NafasColors.surfaceSoft, shape: BoxShape.circle),
                child: const Icon(Icons.eco_rounded, color: NafasColors.primary, size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Row(
                  children: [
                    Flexible(child: Text(post.authorAlias, style: const TextStyle(fontWeight: FontWeight.w900))),
                    if (post.verifiedProgress) ...[
                      const SizedBox(width: 5),
                      const Icon(Icons.verified_rounded, size: 16, color: NafasColors.success),
                    ],
                  ],
                ),
              ),
              if (post.verifiedProgress)
                Text('${formatInt(post.smokeFreeDays)} روز', style: const TextStyle(color: NafasColors.primary, fontWeight: FontWeight.w800, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 12),
          Text(post.message, maxLines: 3, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w600, height: 1.75, color: NafasColors.textPrimary)),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.favorite_border_rounded, color: NafasColors.accent, size: 18),
              const SizedBox(width: 5),
              Text('${formatInt(post.hopeCount)} نفر گفتن امید داد', style: Theme.of(context).textTheme.bodySmall),
              const Spacer(),
              const Icon(Icons.chevron_left_rounded, color: NafasColors.textMuted),
            ],
          ),
        ],
      ),
    );
  }
}

class _DailyInsight extends StatelessWidget {
  const _DailyInsight({required this.state, required this.onTap});
  final NafasAppState state;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final hasCraving = state.cravings.isNotEmpty;
    return NafasCard(
      onTap: onTap,
      backgroundColor: NafasColors.surfaceSoft,
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
            child: Icon(hasCraving ? Icons.psychology_alt_rounded : Icons.favorite_rounded, color: NafasColors.success, size: 28),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(hasCraving ? 'داری الگوهای هوس رو می‌شناسی' : 'بدنت داره خودش رو بازسازی می‌کنه', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: NafasColors.textPrimary)),
                const SizedBox(height: 5),
                Text(
                  hasCraving ? '${formatInt(state.cravings.length)} هوس ثبت شده؛ هر ثبت یعنی شناخت بهتر محرک‌ها.' : 'حتی روزهای اول هم تغییرات مفید بدن شروع می‌شن. مسیر سلامت رو ببین.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_left_rounded, color: NafasColors.primary),
        ],
      ),
    );
  }
}

class _SmartCoach extends StatelessWidget {
  const _SmartCoach({required this.state});
  final NafasAppState state;

  @override
  Widget build(BuildContext context) {
    final trigger = state.topCravingTrigger;
    final risky = state.riskyTimeLabel;
    final message = trigger == null
        ? 'هر بار که هوس میاد فقط شدت و محرکش رو ثبت کن؛ بعد از چند ثبت، نفس الگوی شخصی خودت رو بهت نشون می‌ده.'
        : 'تا اینجا «$trigger» پرتکرارترین محرکته${risky == null ? '' : ' و $risky زمان حساس‌تری بوده'}. قبل از اون موقع یک برنامه کوتاه آماده داشته باش.';
    return NafasCard(
      backgroundColor: const Color(0xFFF7FBF9),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(width: 46, height: 46, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)), child: const Icon(Icons.auto_awesome_rounded, color: NafasColors.primary)),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('بینش شخصی تو', style: TextStyle(fontWeight: FontWeight.w900, color: NafasColors.textPrimary)),
            const SizedBox(height: 4),
            Text(message, style: Theme.of(context).textTheme.bodySmall),
          ])),
        ],
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({required this.icon, required this.label, required this.onTap});
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: NafasColors.border),
          boxShadow: const [BoxShadow(color: Color(0x09083B34), blurRadius: 18, offset: Offset(0, 8))],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: NafasColors.primary, size: 20),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w800, color: NafasColors.textPrimary)),
          ],
        ),
      ),
    );
  }
}
