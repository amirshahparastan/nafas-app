import 'package:flutter/material.dart';

import '../../core/constants/product_info.dart';
import '../../core/theme/nafas_colors.dart';
import '../../core/widgets/rtl_app_bar.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const RtlAppBar(title: 'قوانین استفاده'),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 10, 18, 34),
        children: [
          Container(
            padding: const EdgeInsets.all(17),
            decoration: BoxDecoration(
              color: NafasColors.surfaceSoft,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: NafasColors.primary.withValues(alpha: .18)),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'شرایط استفاده از نفس',
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.w900),
                ),
                SizedBox(height: 7),
                Text(
                  'استفاده از اپلیکیشن نفس به معنی پذیرش شرایط زیر است. هدف این متن روشن‌کردن حدود مسئولیت محصول و کاربر است.',
                  style: TextStyle(height: 1.75, color: NafasColors.textSecondary),
                ),
                SizedBox(height: 8),
                Text(
                  'آخرین بازبینی: ${NafasProductInfo.legalReview}',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          const _TermSection(
            title: '۱. هدف برنامه',
            body:
                'نفس برای حمایت از مسیر ترک سیگار، ثبت پیشرفت، مدیریت هوس، ایجاد انگیزه و ارائه محتوای آموزشی طراحی شده است. برنامه تضمین درمان یا موفقیت قطعی در ترک ارائه نمی‌کند.',
          ),
          const _TermSection(
            title: '۲. توصیه پزشکی و وضعیت اضطراری',
            body:
                'محتوای نفس جایگزین پزشک، روان‌شناس، داروساز یا خدمات اورژانسی نیست. در صورت علائم شدید، وضعیت غیرعادی یا نیاز به درمان تخصصی باید از خدمات پزشکی مناسب استفاده شود.',
          ),
          const _TermSection(
            title: '۳. مسئولیت اطلاعات واردشده',
            body:
                'محاسبات و پیشنهادهای شخصی برنامه بر اساس اطلاعاتی انجام می‌شوند که کاربر وارد می‌کند. نادرست یا ناقص بودن این اطلاعات می‌تواند نتیجه محاسبات را تغییر دهد.',
          ),
          const _TermSection(
            title: '۴. استفاده مناسب از امکانات اجتماعی',
            body:
                'در صورت فعال‌بودن دیوار امید، محتوای توهین‌آمیز، تهدیدآمیز، تبلیغاتی، گمراه‌کننده یا مغایر با هدف حمایتی جامعه می‌تواند گزارش یا حذف شود. اطلاعات خصوصی دیگران نباید بدون اجازه منتشر شود.',
          ),
          const _TermSection(
            title: '۵. دسترسی و تغییر قابلیت‌ها',
            body:
                'برای بهبود کیفیت، امنیت یا سازگاری، ممکن است برخی قابلیت‌ها در نسخه‌های بعدی تغییر کنند. در صورت تغییر مهمی که بر داده یا حقوق کاربر اثر بگذارد، متن‌های مرتبط نیز به‌روزرسانی خواهند شد.',
          ),
          const _TermSection(
            title: '۶. مالکیت محصول',
            body:
                'طراحی و توسعه اپلیکیشن نفس توسط تیم توسعه PULSE و امیرمحمد شاه‌پرستان انجام شده است. استفاده از برنامه به معنی انتقال مالکیت کد، طراحی یا هویت محصول به کاربر نیست.',
          ),
          const _TermSection(
            title: '۷. پشتیبانی',
            body:
                'کانال رسمی پشتیبانی این نسخه فقط ایمیل info@wearepulse.ir است. برای گزارش مشکل، پیشنهاد یا پرسش درباره استفاده از برنامه می‌توانی از همین آدرس استفاده کنی.',
          ),
        ],
      ),
    );
  }
}

class _TermSection extends StatelessWidget {
  const _TermSection({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15.5)),
          const SizedBox(height: 6),
          Text(
            body,
            style: const TextStyle(
              color: NafasColors.textSecondary,
              height: 1.85,
            ),
          ),
        ],
      ),
    );
  }
}
