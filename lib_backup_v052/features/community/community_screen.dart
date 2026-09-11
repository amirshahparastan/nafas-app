import 'package:flutter/material.dart';
import '../../core/state/app_state.dart';
import '../../core/theme/nafas_colors.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/nafas_buttons.dart';
import '../../core/widgets/nafas_card.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  bool verifiedOnly = false;

  @override
  Widget build(BuildContext context) {
    final state = NafasScope.of(context);
    final posts = state.visibleHopePosts
        .where((post) => !verifiedOnly || post.verifiedProgress)
        .toList(growable: false);

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 122),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('دیوار امید', style: Theme.of(context).textTheme.headlineMedium),
                          const SizedBox(height: 5),
                          Text(
                            'تجربه‌های کوتاه آدم‌هایی که همین مسیر رو می‌رن؛ بدون قضاوت و بدون شلوغی شبکه اجتماعی.',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    IconButton.filledTonal(
                      tooltip: 'نوشتن پیام',
                      onPressed: () => _showComposer(context, state),
                      icon: const Icon(Icons.edit_rounded),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: NafasColors.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                _CommunityHero(onWrite: () => _showComposer(context, state)),
                const SizedBox(height: 14),
                NafasCard(
                  backgroundColor: const Color(0xFFFFFBF5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.shield_outlined, color: NafasColors.warning),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'نسخه فعلی نمایشی است و پیام‌های اولیه نمونه‌اند. در نسخه آنلاین، نام مستعار استفاده می‌شود، اطلاعات تماس نمایش داده نمی‌شود و پیام‌های نامناسب قابل گزارش‌اند.',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Text('پیام‌های تازه', style: Theme.of(context).textTheme.titleLarge),
                    const Spacer(),
                    FilterChip(
                      selected: verifiedOnly,
                      label: const Text('پیشرفت تأییدشده'),
                      avatar: const Icon(Icons.verified_rounded, size: 17),
                      onSelected: (value) => setState(() => verifiedOnly = value),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                if (posts.isEmpty)
                  NafasCard(
                    child: Column(
                      children: [
                        const Icon(Icons.forum_outlined, size: 44, color: NafasColors.primary),
                        const SizedBox(height: 10),
                        const Text('هنوز پیامی برای این فیلتر نیست', style: TextStyle(fontWeight: FontWeight.w900)),
                        const SizedBox(height: 5),
                        Text('اولین پیام امید رو تو بنویس.', style: Theme.of(context).textTheme.bodyMedium),
                      ],
                    ),
                  )
                else
                  ...posts.map((post) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _HopePostCard(post: post),
                      )),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  void _showComposer(BuildContext context, NafasAppState state) {
    final messageController = TextEditingController();
    var shareProgress = state.communityShareProgressDefault;
    var shareSavings = state.communityShareSavingsDefault;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) {
          final bottom = MediaQuery.of(ctx).viewInsets.bottom;
          return Padding(
            padding: EdgeInsets.fromLTRB(18, 20, 18, bottom + 24),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 42,
                      height: 5,
                      decoration: BoxDecoration(color: NafasColors.border, borderRadius: BorderRadius.circular(99)),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text('یک پیام امید بنویس', style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 6),
                  Text(
                    'کوتاه، واقعی و از تجربه خودت. تشخیص پزشکی یا تبلیغ درمان نامعتبر منتشر نکن.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 18),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: NafasColors.surfaceSoft,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.public_rounded, color: NafasColors.primary),
                        const SizedBox(width: 9),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('انتشار با نام مستعار', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12)),
                              const SizedBox(height: 2),
                              Text(state.communityAlias, style: const TextStyle(fontWeight: FontWeight.w900)),
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(ctx);
                            Navigator.pushNamed(context, '/public-profile');
                          },
                          child: const Text('ویرایش'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: messageController,
                    minLines: 4,
                    maxLines: 7,
                    maxLength: 280,
                    decoration: const InputDecoration(
                      labelText: 'پیام تو',
                      hintText: 'مثلاً: سخت‌ترین بخش برای من هفته اول بود، ولی هر موج هوس واقعاً رد شد...',
                      alignLabelWithHint: true,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _PrivacyToggle(
                    title: 'نمایش روزهای پاکی',
                    subtitle: 'Badge پیشرفت فقط از داده داخل اپ ساخته می‌شود.',
                    value: shareProgress,
                    onChanged: (value) => setSheetState(() => shareProgress = value),
                  ),
                  _PrivacyToggle(
                    title: 'نمایش مبلغ ذخیره‌شده',
                    subtitle: 'اختیاری؛ مبلغ تقریبی بر اساس اطلاعات مصرف خودت.',
                    value: shareSavings,
                    onChanged: (value) => setSheetState(() => shareSavings = value),
                  ),
                  const SizedBox(height: 16),
                  NafasPrimaryButton(
                    label: 'انتشار پیام',
                    icon: Icons.send_rounded,
                    onPressed: () {
                      final message = messageController.text.trim();
                      if (message.length < 8) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('پیامت کمی کوتاهه؛ چند کلمه بیشتر بنویس.')));
                        return;
                      }
                      state.addHopePost(
                        message: message,
                        shareProgress: shareProgress,
                        shareSavings: shareSavings,
                      );
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('پیامت به دیوار امید اضافه شد.')));
                    },
                  ),
                  const SizedBox(height: 8),
                  NafasSecondaryButton(label: 'فعلاً نه', onPressed: () => Navigator.pop(ctx)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _CommunityHero extends StatelessWidget {
  const _CommunityHero({required this.onWrite});
  final VoidCallback onWrite;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Color(0xFF0B594C), Color(0xFF0F7D67)],
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [BoxShadow(color: Color(0x25083B34), blurRadius: 30, offset: Offset(0, 14))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(color: Color(0x20FFFFFF), shape: BoxShape.circle),
            child: const Icon(Icons.volunteer_activism_rounded, color: Colors.white),
          ),
          const SizedBox(height: 20),
          const Text(
            'شاید تجربه امروز تو، دلیل ادامه دادن یک نفر دیگه باشه.',
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900, height: 1.55),
          ),
          const SizedBox(height: 8),
          const Text(
            'پیام کوتاه بذار؛ بدون دنبال‌کننده، بدون دایرکت، فقط حمایت.',
            style: TextStyle(color: Color(0xD9FFFFFF), fontSize: 12.5, height: 1.65),
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onWrite,
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: NafasColors.primaryDark,
                side: BorderSide.none,
              ),
              icon: const Icon(Icons.edit_rounded),
              label: const Text('پیام امید من'),
            ),
          ),
        ],
      ),
    );
  }
}

class _HopePostCard extends StatelessWidget {
  const _HopePostCard({required this.post});
  final HopePost post;

  @override
  Widget build(BuildContext context) {
    final state = NafasScope.of(context);
    return NafasCard(
      padding: const EdgeInsets.all(17),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: const BoxDecoration(color: NafasColors.surfaceSoft, shape: BoxShape.circle),
                child: const Icon(Icons.eco_rounded, color: NafasColors.primary),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(post.authorAlias, style: const TextStyle(fontWeight: FontWeight.w900, color: NafasColors.textPrimary)),
                        ),
                        if (post.verifiedProgress) ...[
                          const SizedBox(width: 5),
                          const Icon(Icons.verified_rounded, size: 16, color: NafasColors.success),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(_timeLabel(post.createdAt), style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                tooltip: 'گزینه‌ها',
                icon: const Icon(Icons.more_horiz_rounded, color: NafasColors.textMuted),
                onSelected: (value) {
                  if (value == 'report') {
                    _confirmReport(context, state, post.id);
                  }
                },
                itemBuilder: (_) => const [
                  PopupMenuItem(value: 'report', child: Text('گزارش این پیام')),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            post.message,
            style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w600, color: NafasColors.textPrimary, height: 1.8),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 7,
            runSpacing: 7,
            children: [
              if (post.verifiedProgress)
                _Badge(icon: Icons.smoke_free_rounded, label: '${formatInt(post.smokeFreeDays)} روز پاکی'),
              if (post.savedMoneyToman != null)
                _Badge(icon: Icons.savings_outlined, label: formatToman(post.savedMoneyToman!.toDouble())),
              if (post.goalTitle != null)
                _Badge(icon: Icons.flag_outlined, label: post.goalTitle!),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => state.toggleHopeReaction(post.id),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(0, 46),
                    backgroundColor: post.reactedByMe ? NafasColors.accentSoft : Colors.white,
                    foregroundColor: post.reactedByMe ? NafasColors.accent : NafasColors.textPrimary,
                    side: BorderSide(color: post.reactedByMe ? NafasColors.accent.withValues(alpha: .25) : NafasColors.border),
                  ),
                  icon: Icon(post.reactedByMe ? Icons.favorite_rounded : Icons.favorite_border_rounded, size: 19),
                  label: Text('به من امید داد • ${formatInt(post.hopeCount)}'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _timeLabel(DateTime at) {
    final diff = DateTime.now().difference(at);
    if (diff.inMinutes < 60) return '${faDigits(diff.inMinutes.clamp(1, 59))} دقیقه پیش';
    if (diff.inHours < 24) return '${faDigits(diff.inHours)} ساعت پیش';
    return '${faDigits(diff.inDays)} روز پیش';
  }

  void _confirmReport(BuildContext context, NafasAppState state, String id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('گزارش پیام'),
        content: const Text('اگر پیام توهین‌آمیز، تبلیغاتی، خطرناک یا حاوی توصیه پزشکی نامعتبره، گزارشش کن.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('لغو')),
          TextButton(
            onPressed: () {
              state.reportHopePost(id);
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('گزارش ثبت شد و پیام از فید تو پنهان شد.')));
            },
            child: const Text('گزارش', style: TextStyle(color: NafasColors.danger)),
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(color: NafasColors.surfaceSoft, borderRadius: BorderRadius.circular(99)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: NafasColors.primary),
          const SizedBox(width: 5),
          Text(label, style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w800, color: NafasColors.textPrimary)),
        ],
      ),
    );
  }
}

class _PrivacyToggle extends StatelessWidget {
  const _PrivacyToggle({required this.title, required this.subtitle, required this.value, required this.onChanged});
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 9),
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
      decoration: BoxDecoration(
        color: NafasColors.background,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: NafasColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w800, color: NafasColors.textPrimary)),
                const SizedBox(height: 2),
                Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
          Switch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}
