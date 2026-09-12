import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/constants/product_info.dart';
import '../../core/services/support_email.dart';
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
  static const categories = ['پیشنهاد', 'گزارش مشکل', 'تجربه کاربری', 'محتوا', 'سایر'];

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const RtlAppBar(title: 'انتقاد و پیشنهاد'),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 30),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: NafasColors.surfaceSoft,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'هر چیزی که باعث میشه نفس بهتر، ساده‌تر یا انسانی‌تر بشه برامون ارزشمنده. پیام از طریق برنامه ایمیل دستگاهت برای تیم PULSE آماده میشه و قبل از ارسال خودت می‌تونی متن نهایی رو ببینی.',
              style: TextStyle(height: 1.7, fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: categories
                .map(
                  (item) => ChoiceChip(
                    label: Text(item),
                    selected: category == item,
                    onSelected: (_) => setState(() => category = item),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: messageController,
            minLines: 5,
            maxLines: 9,
            decoration: const InputDecoration(
              labelText: 'پیامت',
              hintText: 'مشکل، پیشنهاد یا تجربه‌ات رو با جزئیات بنویس...',
            ),
          ),
          const SizedBox(height: 14),
          NafasPrimaryButton(
            label: 'ادامه در ایمیل',
            icon: Icons.email_outlined,
            onPressed: _prepareEmail,
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(17),
              border: Border.all(color: NafasColors.border),
            ),
            child: const Text(
              'گیرنده: ${NafasProductInfo.supportEmail}\nاطلاعات دستگاه یا داده‌های ترک به‌صورت خودکار به پیام اضافه نمی‌شوند.',
              style: TextStyle(
                height: 1.7,
                color: NafasColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _prepareEmail() async {
    final message = messageController.text.trim();
    if (message.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('اول متن بازخورد رو بنویس.')),
      );
      return;
    }

    final opened = await openNafasSupportEmail(
      subject: '$category — اپلیکیشن نفس',
      body: 'دسته‌بندی: $category\n\n$message\n\nنسخه برنامه: ${NafasProductInfo.version}',
    );
    if (!mounted) return;

    if (!opened) {
      await Clipboard.setData(
        ClipboardData(
          text:
              'گیرنده: ${NafasProductInfo.supportEmail}\nموضوع: $category — اپلیکیشن نفس\n\n$message',
        ),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('برنامه ایمیل باز نشد؛ متن و آدرس پشتیبانی کپی شد.'),
        ),
      );
    }
  }
}
