# Backend API Contract — Hope Wall

این Contract با Laravel یا Backend مشابه قابل پیاده‌سازی است.

## Auth strategy
Core اپ بدون حساب کار می‌کند. برای Community یک installation/user key ناشناس یا login اختیاری می‌تواند استفاده شود. تصمیم نهایی قبل از پیاده‌سازی Backend قفل شود.

## Endpoints

### GET /api/v1/hope-posts
Query: cursor, verified_only
Response: items + next_cursor

### POST /api/v1/hope-posts
body: alias, body, share_progress, share_savings
Server باید verified stats را خودش از پروفایل معتبر استخراج کند.

### DELETE /api/v1/hope-posts/{id}
فقط مالک.

### POST /api/v1/hope-posts/{id}/hope
Toggle reaction یا idempotent PUT بهتر است.

### POST /api/v1/hope-posts/{id}/reports
body: reason enum, details?

## Admin
GET moderation queue
POST moderation decision
GET report history

## Security
- rate limit
- profanity/spam heuristic
- body length max 280
- sanitize all text
- no HTML
- pagination cursor-based
- audit log

## v0.5 auth/sync endpoints پیشنهادی
- `POST /auth/otp/request`
- `POST /auth/otp/verify`
- `POST /auth/google`
- `POST /auth/refresh`
- `POST /auth/logout`
- `GET /me`
- `PATCH /me`
- `DELETE /me`
- `GET /sync/pull`
- `POST /sync/push`
- `POST /feedback`

Google ID token باید سمت Backend verify شود. OTP باید rate limit، expiry و abuse protection داشته باشد.
