# 1.0.0+10 — Launch Candidate

- آیکن نهایی نفس (اتود سوم) برای Android/Web/Store assets
- Package ID نهایی `ir.wearepulse.nafas`
- ذخیره‌سازی محلی پایدار Android و غیرفعال‌کردن Auto Backup
- اعلان محلی Android با زمان‌بندی روزانه اختیاری
- Health Timeline پویا با منبع رسمی WHO
- دیوار امید به حالت شفاف «به‌زودی» تا آماده‌شدن Backend و moderation
- پاک‌سازی UI حساب/حریم خصوصی از قابلیت‌های نمایشی
- آماده‌سازی Release Signing و GitHub workflow امضاشده

# v1.0.0 — Product Identity, Support & Legal

- هویت رسمی محصول: تیم توسعه PULSE و امیرمحمد شاه‌پرستان.
- کانال رسمی پشتیبانی: info@wearepulse.ir.
- اضافه‌شدن صفحات درباره نفس، تماس با پشتیبانی، سیاست حریم خصوصی و قوانین استفاده.
- بازطراحی بازخورد برای آماده‌سازی ایمیل واقعی به پشتیبانی به‌جای پیام ساختگی اتصال Backend.
- نام نمایشی Android/Web به «نفس» تغییر کرد.
- نسخه پروژه: 1.0.0+9.

# Changelog

## 0.7.0
- Redesign ورودی‌های پولی با `NafasMoneyField`
- حذف مخفف «م» از نمایش مبلغ صفحه شروع
- نمایش جدا و خوانای واحد تومان
- Preset مبلغ با عنوان کامل «میلیون»
- اضافه شدن secondary accent palette کنترل‌شده
- Warm visual pass روی Onboarding، Dashboard، Goal و Startup
- رنگ معنایی برای ابزارهای مسیر و کارت‌های مالی/جامعه/سلامت
- حفظ Fix اعلان Web از 0.6.1
- اضافه شدن اسناد Visual Polish و Launch Blocker


## 0.6.1
- Fixed nullable Web Notification permission values on newer Dart/Flutter web bindings.
- `permissionStatus()` and `requestPermission()` now safely fall back to `default`.

# v0.6.0 — Launch Foundation & First Impression

- بازطراحی کامل صفحه اول Onboarding با Hero حرفه‌ای، توضیح واضح ارزش محصول و سه Metric ملموس.
- CTA اصلی «شروع مسیر من» + CTA ثانویه سفید برای «ورود / بازیابی اطلاعات».
- اضافه‌شدن Startup Gate حرفه‌ای هنگام بازیابی داده محلی.
- اضافه‌شدن Persistence مرکزی و Auto-save واقعی روی Flutter Web با LocalStorage.
- بازیابی خودکار State بعد از Refresh مرورگر.
- serialization برای مصرف، هدف، هوس‌ها، لغزش‌ها، ژورنال، حساب، تنظیمات، دیوار امید و بازخورد.
- صفحه حساب اکنون وضعیت ذخیره خودکار محلی را شفاف نشان می‌دهد.
- صفحه Privacy وضعیت واقعی Persistence را نمایش می‌دهد.
- اضافه‌شدن abstraction اعلان؛ روی Web مجوز واقعی Browser Notification و Test Notification قابل اجراست.
- Auth با موبایل/Google و Cloud Sync همچنان بدون Backend جعلی نشده و قرارداد Production آن مستند شده است.
- Vazirmatn، RTL مرکزی و تقویم جلالی حفظ شده‌اند.
- نسخه پروژه: 0.6.0+7.

## باقی‌مانده برای Production Android
- Storage adapter موبایل (SharedPreferences/Isar/SQLite).
- Backend Laravel/API.
- OTP واقعی + Google OAuth.
- Cloud Sync + conflict handling.
- Android local notifications / exact scheduling / Quiet Hours.
- تست integration و release build APK/AAB.
