import 'package:flutter/material.dart';
import '../../core/state/app_state.dart';
import '../../core/theme/nafas_colors.dart';
import '../../core/widgets/nafas_buttons.dart';
import '../../core/widgets/rtl_app_bar.dart';
import '../../core/widgets/rtl_icons.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  bool _initialized = false;
  late final TextEditingController nameController;
  late final TextEditingController mobileController;
  late final TextEditingController emailController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;
    final state = NafasScope.of(context);
    nameController = TextEditingController(text: state.displayName);
    mobileController = TextEditingController(text: state.mobile);
    emailController = TextEditingController(text: state.email);
  }

  @override
  void dispose() {
    nameController.dispose();
    mobileController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = NafasScope.of(context);
    return Scaffold(
      appBar: const RtlAppBar(title: 'حساب و اطلاعات شخصی'),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 30),
        children: [
          _statusCard(state),
          const SizedBox(height: 12),
          _localSaveCard(context, state),
          const SizedBox(height: 18),
          const Text('اطلاعات خصوصی', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900)),
          const SizedBox(height: 6),
          Text(
            'این اطلاعات فقط برای حساب، بازیابی و همگام‌سازی استفاده می‌شوند و در دیوار امید نمایش داده نمی‌شوند.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'نام و نام خانوادگی', prefixIcon: Icon(Icons.person_outline_rounded)),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: mobileController,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(labelText: 'شماره موبایل', prefixIcon: Icon(Icons.phone_iphone_rounded)),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            textDirection: TextDirection.ltr,
            decoration: const InputDecoration(labelText: 'ایمیل', prefixIcon: Icon(Icons.alternate_email_rounded)),
          ),
          const SizedBox(height: 14),
          NafasPrimaryButton(
            label: 'ذخیره اطلاعات شخصی',
            onPressed: () {
              state.updateIdentity(
                name: nameController.text,
                mobileValue: mobileController.text,
                emailValue: emailController.text,
              );
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('اطلاعات شخصی ذخیره شد.')));
            },
          ),
          const SizedBox(height: 12),
          InkWell(
            onTap: () => Navigator.pushNamed(context, '/public-profile'),
            borderRadius: BorderRadius.circular(18),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: NafasColors.surfaceSoft,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: NafasColors.border),
              ),
              child: const Row(
                children: [
                  Icon(Icons.public_rounded, color: NafasColors.primary),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('پروفایل عمومی دیوار امید', style: TextStyle(fontWeight: FontWeight.w900)),
                        SizedBox(height: 2),
                        Text('نام مستعار و اطلاعاتی که دیگران می‌بینند', style: TextStyle(fontSize: 12.5)),
                      ],
                    ),
                  ),
                  NafasDisclosureIcon(),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text('ورود و پشتیبان‌گیری', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900)),
          const SizedBox(height: 6),
          Text(
            'اطلاعات روی همین دستگاه ذخیره می‌شن. ورود واقعی با موبایل یا Google برای همگام‌سازی چنددستگاهی به Backend امن متصل خواهد شد.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 12),
          _providerCard(
            icon: Icons.phone_android_rounded,
            title: 'ورود با شماره موبایل',
            subtitle: 'OTP پیامکی • مناسب کاربران ایران',
            onTap: () => _backendPending(context, 'ورود با شماره موبایل'),
          ),
          const SizedBox(height: 9),
          _providerCard(
            icon: Icons.g_mobiledata_rounded,
            title: 'ورود با Google',
            subtitle: 'اتصال Gmail برای بازیابی و همگام‌سازی',
            onTap: () => _backendPending(context, 'ورود با Google'),
          ),
        ],
      ),
    );
  }

  Widget _localSaveCard(BuildContext context, NafasAppState state) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: NafasColors.surfaceSoft,
        borderRadius: BorderRadius.circular(19),
        border: Border.all(color: NafasColors.primary.withValues(alpha: .18)),
      ),
      child: Row(
        children: [
          const Icon(Icons.save_rounded, color: NafasColors.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('ذخیره خودکار فعاله', style: TextStyle(fontWeight: FontWeight.w900)),
                const SizedBox(height: 2),
                Text(
                  state.localPersistenceDurable
                      ? 'تغییراتت در این مرورگر باقی می‌مونه، حتی بعد از Refresh.'
                      : 'در این پیش‌نمایش، لایه ذخیره محلی برای پلتفرم نهایی آماده شده.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          const Icon(Icons.check_circle_rounded, color: NafasColors.success),
        ],
      ),
    );
  }

  Widget _statusCard(NafasAppState state) {
    final connected = state.isSignedIn;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF0F6F5C), Color(0xFF0B4F43)]),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(color: Colors.white.withValues(alpha: .12), borderRadius: BorderRadius.circular(16)),
            child: Icon(connected ? Icons.cloud_done_rounded : Icons.cloud_off_rounded, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(connected ? 'حساب متصل است' : 'فعلاً به‌صورت محلی استفاده می‌کنی', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 17)),
                const SizedBox(height: 3),
                Text(connected ? 'داده‌ها برای همگام‌سازی ابری آماده‌اند.' : 'پیشرفتت روی همین دستگاه ذخیره می‌شه؛ حساب برای بکاپ بین دستگاه‌هاست.', style: TextStyle(color: Colors.white.withValues(alpha: .75))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _providerCard({required IconData icon, required String title, required String subtitle, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: NafasColors.border)),
        child: Row(
          children: [
            Container(width: 44, height: 44, decoration: BoxDecoration(color: NafasColors.surfaceSoft, borderRadius: BorderRadius.circular(14)), child: Icon(icon, color: NafasColors.primary)),
            const SizedBox(width: 11),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.w900)), const SizedBox(height: 2), Text(subtitle, style: Theme.of(context).textTheme.bodySmall)])),
            const NafasDisclosureIcon(),
          ],
        ),
      ),
    );
  }

  void _backendPending(BuildContext context, String title) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: const Text('رابط این بخش آماده شده، اما احراز هویت واقعی باید به Backend امن، OTP و Google OAuth متصل شود. در نسخه دمو عمداً ورود جعلی انجام نمی‌دهیم.'),
        actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('باشه'))],
      ),
    );
  }
}
