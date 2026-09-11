# Release Blockers — Nafas v0.7

## Blockerهای واقعی قبل از لانچ
1. Android SDK و build واقعی APK/AAB
2. Persistence موبایل durable با adapter مناسب
3. Backend production برای OTP، Google sign-in و Sync
4. Token lifecycle + logout-all-devices + account deletion
5. Android local notifications و زمان‌بندی قابل کنترل
6. Remote community feed + moderation/report pipeline
7. Privacy Policy و Terms قابل دسترسی از داخل اپ
8. QA روی چند نسخه Android و چند اندازه صفحه
9. Crash/error logging بدون جمع‌آوری داده حساس
10. بررسی نهایی ادعاهای سلامت و منابع محتوایی

## چیزهایی که نباید فیک شوند
- ورود موفق بدون backend
- Sync ابری بدون API
- تماس/اعلان Android بدون permission و platform integration
- badge تأییدشده community بدون داده معتبر سمت سرور

## اولویت Sprint بعد
Persistence Android → Auth/Sync API → Notifications → Community backend → Release QA.
