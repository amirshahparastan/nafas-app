# Font Integration — Vazirmatn (Production)

از نسخه `0.3.1` فونت **Vazirmatn** به‌صورت local asset داخل خود اپ bundle شده است؛ بنابراین نمایش فونت به اینترنت، Google Fonts یا CDN وابسته نیست.

## مسیر فایل‌ها

```text
assets/fonts/
  Vazirmatn-Thin.ttf
  Vazirmatn-ExtraLight.ttf
  Vazirmatn-Light.ttf
  Vazirmatn-Regular.ttf
  Vazirmatn-Medium.ttf
  Vazirmatn-SemiBold.ttf
  Vazirmatn-Bold.ttf
  Vazirmatn-ExtraBold.ttf
  Vazirmatn-Black.ttf
```

## Weight mapping

- Thin = 100
- ExtraLight = 200
- Light = 300
- Regular = 400
- Medium = 500
- SemiBold = 600
- Bold = 700
- ExtraBold = 800
- Black = 900

`ThemeData.fontFamily` و تمام TextStyleهای مرکزی روی `Vazirmatn` تنظیم شده‌اند.

## قواعد Typography نفس

- Body: 400/500
- Label و Button: 600/700
- Card title: 600/700
- Page title: 700/800
- Hero numeric: 800/900 فقط در نقاط محدود
- استفاده بیش‌ازحد از Bold/Black ممنوع؛ hierarchy باید با size، spacing و color هم ساخته شود.
- تمام صفحات روی Android واقعی و اندازه‌های مختلف Font Scale تست شوند.

## نکته Release

فونت‌ها در APK/AAB بسته‌بندی می‌شوند و در حالت آفلاین نیز بدون تغییر ظاهر در دسترس هستند.
