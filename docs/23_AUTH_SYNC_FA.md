# Auth & Sync — نسخه لانچ

## هدف
کاربر بتواند بدون حساب شروع کند، اما برای پشتیبان‌گیری و انتقال بین دستگاه‌ها حساب بسازد.

## روش‌های ورود
1. شماره موبایل + OTP
2. Google Sign-In

## معماری پیشنهادی
- Flutter: AuthRepository interface
- Backend: Laravel API
- OTP: Provider قابل تعویض
- Google: دریافت ID Token در کلاینت و Verify در Backend
- Session: Access Token کوتاه‌عمر + Refresh Token
- ذخیره Token: Secure Storage در دستگاه

## اصل مهم
Login ساختگی در Demo ممنوع است. تا زمان اتصال Backend، UI فقط وضعیت «آماده اتصال» را نشان می‌دهد.

## Sync
Local-first. تغییرات ابتدا محلی ثبت، سپس Sync می‌شوند. Backend منبع پشتیبان است نه مانع استفاده آفلاین.

## حریم خصوصی
- هویت خصوصی: نام/موبایل/ایمیل
- هویت عمومی: communityAlias
- هیچ داده خصوصی در Hope Wall نمایش داده نشود.
- Export و Delete Account قبل از Release باید فعال باشد.
