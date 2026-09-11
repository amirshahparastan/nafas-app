import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/state/app_state.dart';
import '../../core/theme/nafas_colors.dart';
import '../../core/widgets/nafas_card.dart';
import '../../core/widgets/rtl_app_bar.dart';

class HelpSafetyScreen extends StatelessWidget {
  const HelpSafetyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = NafasScope.of(context);
    return Scaffold(
      appBar: const RtlAppBar(title: 'کمک و ایمنی'),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 30),
          children: [
            Text('وقتی تنهایی سخت می‌شه', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 6),
            Text('این بخش برای لحظه‌های سخت طراحی شده؛ از حمایت یک آدم مطمئن تا کمک پزشکی فوری.', style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 18),
            NafasCard(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Row(children: [Icon(Icons.person_rounded, color: NafasColors.primary), SizedBox(width: 9), Text('فرد مورد اعتماد', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900))]),
                const SizedBox(height: 9),
                Text(state.trustedContactName.isEmpty ? 'هنوز کسی رو انتخاب نکردی. بهتره یک نفر رو از قبل مشخص کنی که در لحظه سخت بدون فکر اضافه بتونی سراغش بری.' : '${state.trustedContactName} • ${state.trustedContactPhone}', style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 12),
                Row(children: [
                  Expanded(child: OutlinedButton(onPressed: () => _editContact(context, state), child: Text(state.trustedContactName.isEmpty ? 'انتخاب فرد' : 'ویرایش'))),
                  if (state.trustedContactPhone.isNotEmpty) ...[
                    const SizedBox(width: 9),
                    Expanded(child: FilledButton(onPressed: () => _copy(context, state.trustedContactPhone, 'شماره فرد مورد اعتماد کپی شد'), child: const Text('کپی شماره'))),
                  ],
                ]),
              ]),
            ),
            const SizedBox(height: 12),
            NafasCard(
              backgroundColor: NafasColors.surfaceSoft,
              child: const Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Icon(Icons.psychology_alt_rounded, color: NafasColors.primary),
                SizedBox(width: 11),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('کمک تخصصی', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
                  SizedBox(height: 5),
                  Text('اگر ترک برات خیلی سخت شده، یا از دارو/روش‌های ترک مطمئن نیستی، صحبت با پزشک یا متخصص ترک دخانیات می‌تونه مسیر رو امن‌تر و مؤثرتر کنه.'),
                ])),
              ]),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(17),
              decoration: BoxDecoration(color: const Color(0xFFFFEEEE), borderRadius: BorderRadius.circular(24), border: Border.all(color: const Color(0xFFF3C3C3))),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Row(children: [Icon(Icons.emergency_rounded, color: NafasColors.danger), SizedBox(width: 9), Text('علائم شدید یا وضعیت اضطراری', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: NafasColors.textPrimary))]),
                const SizedBox(height: 8),
                const Text('درد شدید قفسه سینه، تنگی نفس جدی، غش یا هر وضعیت غیرعادی شدید را با تمرین داخل اپ مدیریت نکن. کمک پزشکی فوری بگیر.'),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () => _copy(context, '115', 'شماره اورژانس ۱۱۵ کپی شد'),
                  icon: const Icon(Icons.content_copy_rounded),
                  label: const Text('کپی شماره اورژانس ۱۱۵'),
                  style: OutlinedButton.styleFrom(foregroundColor: NafasColors.danger, side: const BorderSide(color: Color(0xFFE8B5B5))),
                ),
                const SizedBox(height: 5),
                Text('تماس مستقیم در نسخه Android Release با تأیید کاربر فعال می‌شود.', style: Theme.of(context).textTheme.bodySmall),
              ]),
            ),
            const SizedBox(height: 18),
            Text('نفس جایگزین خدمات پزشکی یا اورژانسی نیست.', textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }

  void _copy(BuildContext context, String text, String message) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  void _editContact(BuildContext context, NafasAppState state) {
    final name = TextEditingController(text: state.trustedContactName);
    final phone = TextEditingController(text: state.trustedContactPhone);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(18, 20, 18, MediaQuery.of(ctx).viewInsets.bottom + 24),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('فرد مورد اعتماد', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
          const SizedBox(height: 6),
          Text('فقط نام و شماره‌ای که خودت انتخاب می‌کنی نگه داشته می‌شه.', style: Theme.of(ctx).textTheme.bodyMedium),
          const SizedBox(height: 16),
          TextField(controller: name, decoration: const InputDecoration(labelText: 'نام یا نسبت')),
          const SizedBox(height: 10),
          TextField(controller: phone, keyboardType: TextInputType.phone, textDirection: TextDirection.ltr, decoration: const InputDecoration(labelText: 'شماره تماس')),
          const SizedBox(height: 14),
          FilledButton(onPressed: () { state.updateTrustedContact(name: name.text, phone: phone.text); Navigator.pop(ctx); }, child: const Text('ذخیره')),
        ]),
      ),
    );
  }
}
