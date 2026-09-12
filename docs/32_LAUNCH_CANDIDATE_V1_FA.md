# نفس 1.0 — Launch Candidate

## وضعیت فنی بسته‌شده در این مرحله

- هسته برنامه Offline-first است و مسیر ترک، هوس، هدف، ژورنال، آمار و Health Timeline بدون اینترنت کار می‌کنند.
- ذخیره‌سازی Android از حافظه موقت به SharedPreferences پایدار منتقل شده است.
- اعلان محلی Android با مجوز کاربر و یک یادآوری روزانه قابل تنظیم فعال شده است.
- Push سروری، ورود، حساب و Cloud Sync در 1.0 فعال نیستند و UI ادعای فعال‌بودن آن‌ها ندارد.
- دیوار امید از محتوای نمونه/دمو خارج شده و تا آماده‌شدن Backend + moderation به حالت «به‌زودی» درآمده است.
- Health Timeline بر اساس streak واقعی کاربر وضعیت هر مرحله را نمایش می‌دهد و منبع WHO داخل برنامه لینک شده است.
- App ID نهایی Android: `ir.wearepulse.nafas`
- App icon نهایی از اتود سوم انتخابی نصب شده و فایل 512/1024 برای استورها در `store_assets/` قرار دارد.
- Privacy/Terms/Account/Settings با رفتار واقعی نسخه 1.0 هماهنگ شده‌اند.
- Release signing در Gradle و GitHub Actions آماده است اما کلید خصوصی باید توسط مالک برنامه ساخته شود.

## کارهای انسانی باقی‌مانده قبل از انتشار عمومی

1. اجرای `tools/create_release_keystore_mac.sh` و بکاپ امن Keystore.
2. قراردادن چهار GitHub Secret مربوط به signing و اجرای Workflow دستی `Nafas Signed Release`.
3. نصب APK امضاشده روی گوشی و Smoke Test کامل، هم آنلاین و هم Airplane Mode.
4. تست حداقل روی Android 13/14/15 یا چند گوشی با اندازه نمایش متفاوت؛ Galaxy A04 یکی از دستگاه‌های تست باشد.
5. تست permission و زمان‌بندی Notification و ماندگاری آن بعد از reboot.
6. ساخت URL عمومی Privacy Policy روی دامنه PULSE برای فرم فروشگاه (پیشنهاد: `wearepulse.ir/nafas/privacy`).
7. تهیه اسکرین‌شات‌های واقعی، توضیحات فروشگاه، رده‌بندی سنی و فرم Data Safety/Privacy بازار و مایکت.
8. قبل از فعال‌شدن دیوار امید در نسخه بعدی: Backend، احراز هویت، moderation، report flow، rate limit و قوانین جامعه باید عملیاتی شوند.

## سیاست اینترنت V1

Core برنامه بدون اینترنت کار می‌کند. تنها بازکردن لینک منبع WHO، ارسال ایمیل پشتیبانی و قابلیت‌های آنلاین آینده به اینترنت نیاز دارند.
