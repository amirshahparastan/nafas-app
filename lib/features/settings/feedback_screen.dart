import 'package:flutter/material.dart';
import '../../core/state/app_state.dart';
import '../../core/theme/nafas_colors.dart';
import '../../core/widgets/nafas_buttons.dart';
import '../../core/widgets/rtl_app_bar.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  String category = 'پیشنهاد';
  final messageController = TextEditingController();
  final contactController = TextEditingController();
  static const categories = ['پیشنهاد', 'گزارش مشکل', 'تجربه کاربری', 'محتوا', 'سایر'];

  @override
  void dispose() {
    messageController.dispose();
    contactController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = NafasScope.of(context);
    return Scaffold(
      appBar: const RtlAppBar(title: 'انتقاد و پیشنهاد'),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 30),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: NafasColors.surfaceSoft, borderRadius: BorderRadius.circular(20)),
            child: const Text('هر چیزی که باعث میشه نفس بهتر، ساده‌تر یا انسانی‌تر بشه برامون ارزشمنده. برای گزارش مشکل هم همین بخش رو استفاده کن.', style: TextStyle(height: 1.7, fontWeight: FontWeight.w700)),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: categories.map((item) => ChoiceChip(label: Text(item), selected: category == item, onSelected: (_) => setState(() => category = item))).toList(),
          ),
          const SizedBox(height: 14),
          TextField(controller: messageController, minLines: 5, maxLines: 8, decoration: const InputDecoration(labelText: 'پیامت', hintText: 'مشکل، پیشنهاد یا تجربه‌ات رو با جزئیات بنویس...')),
          const SizedBox(height: 10),
          TextField(controller: contactController, decoration: const InputDecoration(labelText: 'راه ارتباطی اختیاری', hintText: 'موبایل یا ایمیل، فقط اگر دوست داری پاسخ بگیری')),
          const SizedBox(height: 14),
          NafasPrimaryButton(
            label: 'ارسال بازخورد',
            icon: Icons.send_rounded,
            onPressed: () {
              if (messageController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('اول متن بازخورد رو بنویس.')));
                return;
              }
              state.addFeedback(category: category, message: messageController.text, contact: contactController.text);
              messageController.clear();
              contactController.clear();
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('بازخورد ثبت شد؛ اتصال سرور در فاز Backend فعال میشه.')));
            },
          ),
          const SizedBox(height: 12),
          Text('نسخه لانچ: نسخه اپ و اطلاعات فنی دستگاه فقط با رضایت کاربر به گزارش خطا اضافه می‌شود.', style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}
