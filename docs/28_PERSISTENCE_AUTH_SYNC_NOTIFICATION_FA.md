# Persistence, Auth, Sync & Notifications — v0.6

## وضعیت این Build

### Persistence
- لایه ذخیره‌سازی مرکزی اضافه شده است.
- روی Flutter Web، داده‌ها با LocalStorage واقعاً بین Refreshها حفظ می‌شوند.
- همه تغییرات اصلی State به‌صورت خودکار serialize و ذخیره می‌شوند.
- State در startup قبل از Gate اصلی hydrate می‌شود.
- Schema فعلی: `nafas_state_v2`.

### Android/iOS Persistence
برای Release موبایل باید adapter فعلی با storage production-grade مثل SharedPreferences/Isar/SQLite جایگزین شود. این کار بعد از پایدارشدن Android SDK و دسترسی pub.dev انجام می‌شود. قرارداد Storage از UI جداست تا تعویض adapter بدون بازنویسی صفحات انجام شود.

### Auth
- UI حساب، شماره موبایل و Google آماده است.
- Login جعلی انجام نمی‌شود.
- اتصال واقعی نیازمند Backend، OTP Provider و Google OAuth verification است.

### Cloud Sync
- UI و Data Model برای Sync آماده‌اند.
- Source of truth فعلی Local-first است.
- Backend باید conflict resolution، device/session management، refresh token و حذف حساب را پیاده کند.

### Notifications
- abstraction مرکزی Notification اضافه شده است.
- روی Web، permission واقعی مرورگر و اعلان آزمایشی کار می‌کند.
- زمان‌بندی اعلان Android نیازمند SDK و implementation پلتفرمی است.

## اصول
- Local-first: کاربر بدون ساخت حساب هم بتواند اپ را شروع کند.
- Offline-safe: ثبت هوس و لغزش نباید وابسته به اینترنت باشد.
- No fake auth: در Demo هیچ حساب جعلی به‌عنوان حساب واقعی نمایش داده نشود.
- Minimal data: فقط داده لازم برای تجربه و Sync جمع‌آوری شود.
