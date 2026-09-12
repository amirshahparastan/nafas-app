import 'package:flutter/material.dart';
import '../../core/state/app_state.dart';
import '../../core/theme/nafas_colors.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/nafas_buttons.dart';
import '../../core/widgets/rtl_app_bar.dart';

class PublicProfileScreen extends StatefulWidget {
  const PublicProfileScreen({super.key});

  @override
  State<PublicProfileScreen> createState() => _PublicProfileScreenState();
}

class _PublicProfileScreenState extends State<PublicProfileScreen> {
  bool _initialized = false;
  late final TextEditingController aliasController;
  bool shareProgress = true;
  bool shareSavings = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;
    final state = NafasScope.of(context);
    aliasController = TextEditingController(text: state.communityAlias);
    shareProgress = state.communityShareProgressDefault;
    shareSavings = state.communityShareSavingsDefault;
  }

  @override
  void dispose() {
    aliasController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = NafasScope.of(context);
    final alias = aliasController.text.trim().isEmpty ? 'یک نفس تازه' : aliasController.text.trim();

    return Scaffold(
      appBar: const RtlAppBar(title: 'پروفایل عمومی دیوار امید'),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 30),
        children: [
          _previewCard(context, state, alias),
          const SizedBox(height: 18),
          const Text('هویت عمومی', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 17)),
          const SizedBox(height: 6),
          Text(
            'این بخش از حساب خصوصی تو جداست. فقط اطلاعاتی که خودت اجازه می‌دهی در دیوار امید دیده می‌شوند.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: aliasController,
            maxLength: 24,
            onChanged: (_) => setState(() {}),
            decoration: const InputDecoration(
              labelText: 'نام مستعار عمومی',
              hintText: 'مثلاً: نفس آرام',
              prefixIcon: Icon(Icons.badge_outlined),
            ),
          ),
          const SizedBox(height: 8),
          _switchCard(
            icon: Icons.verified_outlined,
            title: 'نمایش روزهای پاکی در پیام‌های جدید',
            subtitle: 'Badge پیشرفت از داده واقعی داخل اپ ساخته می‌شود.',
            value: shareProgress,
            onChanged: (value) => setState(() => shareProgress = value),
          ),
          const SizedBox(height: 9),
          _switchCard(
            icon: Icons.savings_outlined,
            title: 'نمایش مبلغ ذخیره‌شده در پیام‌های جدید',
            subtitle: 'اختیاری است و می‌توانی برای هر پست دوباره تغییرش بدهی.',
            value: shareSavings,
            onChanged: (value) => setState(() => shareSavings = value),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: NafasColors.surfaceSoft, borderRadius: BorderRadius.circular(18)),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.privacy_tip_outlined, color: NafasColors.primary),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'نام واقعی، شماره موبایل و ایمیل هیچ‌وقت از این صفحه به دیوار امید منتقل نمی‌شوند.',
                    style: TextStyle(fontWeight: FontWeight.w700, height: 1.6),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          NafasPrimaryButton(
            label: 'ذخیره پروفایل عمومی',
            onPressed: () {
              final aliasValue = aliasController.text.trim();
              if (aliasValue.length < 2) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('یک نام مستعار کوتاه وارد کن.')));
                return;
              }
              state.updateCommunityProfile(
                alias: aliasValue,
                shareProgressByDefault: shareProgress,
                shareSavingsByDefault: shareSavings,
              );
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('پروفایل عمومی ذخیره شد.')));
            },
          ),
        ],
      ),
    );
  }

  Widget _previewCard(BuildContext context, NafasAppState state, String alias) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF0F6F5C), Color(0xFF0B4F43)]),
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [BoxShadow(color: Color(0x22083B34), blurRadius: 25, offset: Offset(0, 12))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(color: Colors.white.withValues(alpha: .14), borderRadius: BorderRadius.circular(16)),
                child: const Icon(Icons.spa_rounded, color: Colors.white),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(alias, style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w900)),
                    const SizedBox(height: 2),
                    Text('پیش‌نمایش هویت عمومی', style: TextStyle(color: Colors.white.withValues(alpha: .72), fontSize: 12.5)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (shareProgress) _chip('${formatInt(state.smokeFreeDays)} روز پاکی', Icons.verified_rounded),
              if (shareSavings) _chip('${formatToman(state.moneySaved)} ذخیره', Icons.savings_rounded),
              if (!shareProgress && !shareSavings) _chip('فقط نام مستعار', Icons.visibility_off_outlined),
            ],
          ),
        ],
      ),
    );
  }

  Widget _chip(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(color: Colors.white.withValues(alpha: .12), borderRadius: BorderRadius.circular(99)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 16),
          const SizedBox(width: 5),
          Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _switchCard({required IconData icon, required String title, required String subtitle, required bool value, required ValueChanged<bool> onChanged}) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(19), border: Border.all(color: NafasColors.border)),
      child: SwitchListTile(
        value: value,
        onChanged: onChanged,
        secondary: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(color: NafasColors.surfaceSoft, borderRadius: BorderRadius.circular(13)),
          child: Icon(icon, color: NafasColors.primary),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
        subtitle: Text(subtitle),
      ),
    );
  }
}
