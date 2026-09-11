# RTL + Accessibility Rules

## RTL
- Back icon: سمت راست، `arrow_forward_rounded`
- AppBar title راست‌چین
- Disclosure row: chevron در سمت انتهایی محتوا
- order عناصر بر اساس معنا، نه فقط mirror خودکار
- اعداد تایمر LTR نمایش داده شوند

## Accessibility
- touch target حداقل 44px
- contrast متن اصلی با پس‌زمینه روشن مناسب باشد
- رنگ تنها نشانه status نباشد؛ icon/text هم اضافه شود
- textScale 1.3 بدون overflow
- semantic label برای icon-only buttons
- motion حساس قابل کاهش در فاز production

## Craving
در لحظه اضطرار تعداد انتخاب‌ها محدود و متن کوتاه باشد؛ هیچ modal تبلیغاتی یا paywall نمایش داده نشود.
