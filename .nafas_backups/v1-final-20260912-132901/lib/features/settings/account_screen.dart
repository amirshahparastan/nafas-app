import 'package:flutter/material.dart';

import '../../core/state/app_state.dart';
import '../../core/theme/nafas_colors.dart';
import '../../core/widgets/nafas_buttons.dart';
import '../../core/widgets/rtl_app_bar.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  bool _initialized = false;
  late final TextEditingController nameController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;
    nameController = TextEditingController(text: NafasScope.of(context).displayName);
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = NafasScope.of(context);
    return Scaffold(
      appBar: const RtlAppBar(title: 'اطلاعات من'),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 30),
        children: [
          _statusCard(),
          const SizedBox(height: 12),
          _localSaveCard(context, state),
          const SizedBox(height: 20),
          const Text('نام داخل برنامه', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900)),
          const SizedBox(height: 6),
          Text('اختیاری است و فقط روی همین دستگاه برای شخصی‌تر شدن تجربه نفس نگهداری می‌شود.', style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 12),
          TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'نام', prefixIcon: Icon(Icons.person_outline_rounded)),
          ),
          const SizedBox(height: 14),
          NafasPrimaryButton(
            label: 'ذخیره نام',
            onPressed: () {
              state.updateIdentity(name: nameController.text, mobileValue: '', emailValue: '');
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('نام ذخیره شد.')));
            },
          ),
          const SizedBox(height: 24),
          const Text('حساب و بکاپ ابری', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(color: const Color(0xFFFFFBF0), borderRadius: BorderRadius.circular(20), border: Border.all(color: NafasColors.border)),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.cloud_outlined, color: NafasColors.warning),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('در نسخه ۱.۰ حساب کاربری لازم نیست', style: TextStyle(fontWeight: FontWeight.w900)),
                      SizedBox(height: 4),
                      Text('ورود با موبایل/Google و همگام‌سازی امن بین دستگاه‌ها در نسخه بعدی اضافه می‌شود. در نسخه ۱.۰ هیچ اطلاعات ورود از کاربر دریافت نمی‌شود.', style: TextStyle(height: 1.7, color: NafasColors.textSecondary)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _localSaveCard(BuildContext context, NafasAppState state) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: NafasColors.surfaceSoft, borderRadius: BorderRadius.circular(19), border: Border.all(color: NafasColors.primary.withValues(alpha: .18))),
      child: Row(
        children: [
          const Icon(Icons.save_rounded, color: NafasColors.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('ذخیره خودکار روی دستگاه فعاله', style: TextStyle(fontWeight: FontWeight.w900)),
                const SizedBox(height: 2),
                Text('${state.persistenceLabel}؛ برای امکانات اصلی اینترنت لازم نیست.', style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
          const Icon(Icons.check_circle_rounded, color: NafasColors.success),
        ],
      ),
    );
  }

  Widget _statusCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF0F6F5C), Color(0xFF0B4F43)]), borderRadius: BorderRadius.circular(24)),
      child: Row(
        children: [
          Container(width: 48, height: 48, decoration: BoxDecoration(color: Colors.white.withValues(alpha: .12), borderRadius: BorderRadius.circular(16)), child: const Icon(Icons.phonelink_lock_rounded, color: Colors.white)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('نسخه ۱.۰ • محلی و بدون ورود', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 17)),
                const SizedBox(height: 3),
                Text('داده‌های مسیر ترک روی همین دستگاه باقی می‌مانند.', style: TextStyle(color: Colors.white.withValues(alpha: .75))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
