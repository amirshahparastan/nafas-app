# Privacy & Security Checklist

## Core
Local-first و بدون ثبت‌نام اجباری برای ترک/هدف/آمار.

## Community
- نام مستعار پیش‌فرض
- شماره/ایمیل/شناسه تماس در Feed نمایش داده نشود
- نمایش روزهای پاکی و مبلغ ذخیره اختیاری
- Badge تأییدشده از سرور/داده معتبر اپ ساخته شود
- Rate limit برای ارسال/Reaction/Report
- حذف پست توسط مالک
- امکان block/hide سمت کاربر در فاز بعد

## Backend
- HTTPS only
- secrets خارج repository
- auth token کوتاه‌عمر + refresh strategy در صورت استفاده
- moderation log immutable/auditable
- حداقل‌سازی retention داده شخصی

## Release
Privacy Policy باید Community data، moderation و analytics را شفاف توضیح دهد.
