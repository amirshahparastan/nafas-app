import 'package:flutter/material.dart';

import '../../core/constants/product_info.dart';
import '../../core/theme/nafas_colors.dart';
import '../../core/widgets/rtl_app_bar.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const RtlAppBar(title: 'سیاست حریم خصوصی'),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 10, 18, 34),
        children: [
          _intro(),
          const SizedBox(height: 16),
          const _PolicySection(
            title: '۱. چه اطلاعاتی در نفس استفاده می‌شود؟',
            body:
                'اطلاعاتی که خودت برای استفاده از امکانات برنامه وارد می‌کنی می‌تواند شامل الگوی مصرف سیگار، تاریخ شروع ترک، هدف مالی، ثبت هوس، یادداشت‌ها، نام مستعار دیوار امید، تنظیمات برنامه و اطلاعات فرد مورد اعتماد باشد.',
          ),
          const _PolicySection(
            title: '۲. اطلاعات فعلی کجا نگهداری می‌شوند؟',
            body:
                'در این نسخه، داده‌های اصلی تجربه ترک به‌صورت محلی روی دستگاه نگهداری می‌شوند. تا زمانی که قابلیت حساب و همگام‌سازی ابری به‌صورت رسمی فعال نشده باشد، نفس این داده‌ها را برای پشتیبان‌گیری ابری ارسال نمی‌کند.',
          ),
          const _PolicySection(
            title: '۳. پشتیبانی و ایمیل',
            body:
                'اگر از داخل برنامه با پشتیبانی تماس بگیری، متن و اطلاعاتی که خودت در ایمیل وارد می‌کنی از طریق سرویس ایمیل انتخابی تو برای آدرس رسمی PULSE ارسال می‌شود. اطلاعات اضافی دستگاه یا داده‌های ترک بدون اقدام و رضایت تو به ایمیل اضافه نمی‌شوند.',
          ),
          const _PolicySection(
            title: '۴. تبلیغات و فروش داده',
            body:
                'نفس اطلاعات ترک، سلامت یا هویت خصوصی کاربران را برای تبلیغات هدفمند نمی‌فروشد و این اطلاعات را به‌صورت عمومی نمایش نمی‌دهد. هویت عمومی دیوار امید از اطلاعات خصوصی حساب جدا در نظر گرفته شده است.',
          ),
          const _PolicySection(
            title: '۵. حذف و کنترل داده‌ها',
            body:
                'کاربر باید بتواند داده‌های محلی خود را از داخل برنامه بازنشانی یا حذف کند. با فعال‌شدن حساب و همگام‌سازی ابری، امکان حذف حساب و داده‌های ابری نیز باید در خود برنامه در دسترس باشد و این سیاست قبل از فعال‌سازی آن قابلیت به‌روزرسانی خواهد شد.',
          ),
          const _PolicySection(
            title: '۶. اطلاعات سلامت',
            body:
                'نفس یک ابزار حمایتی و آموزشی برای مسیر ترک سیگار است. اطلاعات داخل برنامه جایگزین تشخیص، درمان یا توصیه پزشکی شخصی نیستند.',
          ),
          const _PolicySection(
            title: '۷. تغییرات این سیاست',
            body:
                'اگر نحوه جمع‌آوری، نگهداری یا انتقال داده‌ها تغییر کند، متن سیاست حریم خصوصی نیز متناسب با آن به‌روزرسانی می‌شود. نسخه جدید باید پیش از فعال‌شدن قابلیت‌هایی که داده بیشتری جمع‌آوری می‌کنند در دسترس کاربر قرار بگیرد.',
          ),
          const SizedBox(height: 6),
          _contact(context),
        ],
      ),
    );
  }

  Widget _intro() {
    return Container(
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
            'حریم خصوصی در نفس',
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.w900),
          ),
          SizedBox(height: 7),
          Text(
            'اصل ما ساده است: فقط داده‌ای که برای تجربه محصول لازم است نگهداری شود و درباره محل نگهداری و استفاده از آن شفاف باشیم.',
            style: TextStyle(height: 1.75, color: NafasColors.textSecondary),
          ),
          SizedBox(height: 8),
          Text(
            'آخرین بازبینی: ${NafasProductInfo.legalReview}',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }

  Widget _contact(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(19),
        border: Border.all(color: NafasColors.border),
      ),
      child: const Text(
        'برای پرسش درباره حریم خصوصی یا داده‌ها: ${NafasProductInfo.supportEmail}',
        style: TextStyle(height: 1.7, fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _PolicySection extends StatelessWidget {
  const _PolicySection({required this.title, required this.body});

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
