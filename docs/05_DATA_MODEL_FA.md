# Data Model پیشنهادی

## UserSettings
cigarettesPerDay, cigarettesPerPack, packPriceToman, quitJourneyStartedAt, currentStreakStartedAt, remindersEnabled, communityAlias

## Goal
id, title, targetAmount, createdAt, completedAt?, archived

## CravingLog
id, at, intensityBefore, intensityAfter?, trigger, durationSec, result

## SlipLog
id, at, count, reason

## HopePost
id, userId?, aliasSnapshot, body, verifiedSmokeFreeDays?, savedMoneySnapshot?, goalTitleSnapshot?, status, createdAt, moderatedAt?

## HopeReaction
id, postId, userKey, type=hope, createdAt

## HopeReport
id, postId, reporterKey, reason, details?, createdAt, status

## اصول
- Journey start از Current streak جدا باشد.
- لغزش تاریخچه Journey را پاک نکند.
- Badge تأییدشده از داده سیستم ساخته شود، نه ورودی دستی کاربر.
- پست Snapshot باشد تا تغییر بعدی پروفایل، تاریخچه پست را تحریف نکند.
- Schema version و migration از روز اول در persistence واقعی وجود داشته باشد.

## افزوده v0.4
JournalEntry: at(DateTime), mood, note.
TrustedContact: name, phone (در release باید امن ذخیره شود).
JourneyDayStatus از eventهای واقعی مشتق می‌شود و در دیتابیس ذخیره جداگانه نمی‌شود.

## v0.5 additions
- `CravingLog.intervention`: راهکاری که کاربر در لحظه هوس انتخاب یا خودش وارد کرده است.
- `UserProfile`: displayName, mobile, email, communityAlias, accountProvider.
- `UserFeedback`: category, message, optionalContact, createdAt.
- `customTriggers[]` و `customInterventions[]` برای شخصی‌سازی سریع تجربه.
- `personalQuitReason` خصوصی است و فقط برای خود کاربر نمایش داده می‌شود.
