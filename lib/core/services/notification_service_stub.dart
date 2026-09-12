import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

const bool supported = true;
const bool supportsScheduling = true;

const _legacyDailyReminderId = 1101;
const _testNotificationId = 1100;
const _dailyReminderBaseId = 1200;
const _scheduledDays = 60;
const _channelId = 'nafas_support';
const _channelName = 'یادآوری‌های حمایتی نفس';
const _channelDescription = 'یادآوری‌های کوتاه و اختیاری برای ادامه مسیر ترک';
const _settingsChannel = MethodChannel('ir.wearepulse.nafas/settings');

final FlutterLocalNotificationsPlugin _plugin =
    FlutterLocalNotificationsPlugin();
Future<void>? _initialization;

class _SupportMessage {
  const _SupportMessage(this.title, this.body);

  final String title;
  final String body;
}

// 40 hand-written, offline-first messages. Consecutive calendar days use a
// deterministic permutation of this list, so the same message is not repeated
// during a 40-day cycle. No server or internet connection is required.
const List<_SupportMessage> _supportMessages = [
  _SupportMessage('فقط امروز 🌿', 'قرار نیست همه‌چیز را یک‌جا حل کنی؛ فقط امروز را بدون سیگار ادامه بده.'),
  _SupportMessage('هوس می‌گذرد 🌱', 'هوس یک موج کوتاه است؛ چند دقیقه به خودت زمان بده تا آرام‌تر شود.'),
  _SupportMessage('این انتخاب برای توست', 'هر بار که نمی‌کشی، داری انتخابی را که برای خودت کرده‌ای محکم‌تر می‌کنی.'),
  _SupportMessage('یک قدم دیگر', 'همین قدم‌های کوچک‌اند که مسیر بزرگ را می‌سازند. ادامه بده.'),
  _SupportMessage('یادت نرفته 💚', 'دلیلی که برای ترک داشتی هنوز همان‌جاست؛ امروز دوباره به آن تکیه کن.'),
  _SupportMessage('سه دقیقه برای خودت', 'اگر هوس داری، سه دقیقه آب بخور، راه برو یا چند نفس آرام بکش؛ بعد دوباره تصمیم بگیر.'),
  _SupportMessage('پولت برای خودت می‌ماند', 'هر سیگاری که نمی‌خری، بخشی از پولت را به چیزی برمی‌گرداند که واقعاً برایت مهم است.'),
  _SupportMessage('مسیرت ارزش دارد', 'پیشرفت همیشه پرسر و صدا نیست؛ گاهی فقط یعنی امروز هم ادامه دادی.'),
  _SupportMessage('تو در حال ساختن عادتی تازه‌ای', 'به جای فکر کردن به همیشه، روی همین انتخاب بعدی تمرکز کن.'),
  _SupportMessage('یک نفس آرام', 'چند لحظه مکث کن. لازم نیست به هر هوسی پاسخ بدهی.'),
  _SupportMessage('امروز هم حساب می‌شود', 'حتی یک روز معمولی بدون سیگار، بخشی از پیشرفت توست.'),
  _SupportMessage('از خودت حمایت کن', 'با خودت همان‌قدر محترمانه حرف بزن که با یک دوست در همین مسیر حرف می‌زدی.'),
  _SupportMessage('تصمیمت را تازه کن', 'لازم نیست انگیزه‌ات همیشه زیاد باشد؛ کافی است انتخابت را دوباره یادآوری کنی.'),
  _SupportMessage('هوس فرمان نیست', 'هوس فقط یک احساس است، نه دستوری که مجبور باشی اجرا کنی.'),
  _SupportMessage('چیزی که می‌خواهی مهم‌تر است', 'فکر کن پول و انرژی این مسیر قرار است به کدام هدف واقعی زندگی‌ات برسد.'),
  _SupportMessage('ادامه، نه کمال', 'هدف بی‌نقص بودن نیست؛ هدف این است که مسیر را رها نکنی.'),
  _SupportMessage('یک برد کوچک 🟢', 'اگر امروز حتی یک بار در برابر هوس مقاومت کردی، همان یک بار ارزش ثبت کردن دارد.'),
  _SupportMessage('محیطت را عوض کن', 'اگر هوس شدید شد، چند دقیقه از موقعیت همیشگی سیگار فاصله بگیر.'),
  _SupportMessage('آب، حرکت، مکث', 'سه انتخاب ساده برای لحظه هوس: کمی آب، چند قدم راه رفتن، و چند دقیقه صبر.'),
  _SupportMessage('دلیل شخصی تو', 'مسیر ترک وقتی قوی‌تر می‌شود که یادت باشد برای چه کسی و برای چه چیزی شروعش کردی.'),
  _SupportMessage('امروز را ساده نگه دار', 'لازم نیست درباره هفته بعد تصمیم بگیری؛ تصمیم امروز کافی است.'),
  _SupportMessage('به پیشرفتت نگاه کن', 'به جای شمردن سختی‌ها، یک لحظه ببین تا اینجا چند انتخاب خوب انجام داده‌ای.'),
  _SupportMessage('یک انتخاب آزاد', 'هر بار که سیگار را رد می‌کنی، کمی بیشتر انتخاب را از عادت پس می‌گیری.'),
  _SupportMessage('از محرکت خبر بگیر', 'هوس امروز از کجا آمد؟ استرس، عادت، جمع دوستان یا بی‌حوصلگی؟ شناختنش کمک‌کننده است.'),
  _SupportMessage('برای خودت جایگزین بساز', 'یک کار کوتاه برای لحظه هوس داشته باش؛ چای، پیاده‌روی، موسیقی یا تماس با یک دوست.'),
  _SupportMessage('مسیر واقعی فراز و فرود دارد', 'روز سخت به معنی شکست نیست؛ فقط روز سخت است. ادامه مسیر هنوز ممکن است.'),
  _SupportMessage('هدف مالی‌ات را یادت هست؟', 'پولی که امروز خرج سیگار نمی‌شود، یک قدم دیگر به سمت هدفی است که انتخاب کرده‌ای.'),
  _SupportMessage('خودت را مشغول کن', 'هوس معمولاً وقتی تمام توجهت را می‌گیرد بزرگ‌تر به نظر می‌رسد؛ چند دقیقه کاری دیگر شروع کن.'),
  _SupportMessage('به خودت زمان بده', 'لازم نیست همین لحظه احساس عالی داشته باشی؛ کافی است از این چند دقیقه عبور کنی.'),
  _SupportMessage('تو فقط یک عدد نیستی', 'تعداد روزها مهم است، اما چیزی که می‌سازی مهم‌تر است: اعتماد دوباره به انتخاب خودت.'),
  _SupportMessage('امروز یک فرصت تازه است', 'مهم نیست دیروز چطور گذشت؛ انتخاب بعدی از همین لحظه شروع می‌شود.'),
  _SupportMessage('یک یادآوری کوتاه', 'سیگار قرار نیست استرس را حل کند؛ فقط این لحظه را با یک انتخاب قدیمی گره می‌زند.'),
  _SupportMessage('پیشرفتت را کوچک نشمار', 'هر بار مقاومت، هر مبلغ پس‌انداز و هر روز ادامه دادن بخشی از نتیجه است.'),
  _SupportMessage('فضا بده، واکنش نده', 'وقتی هوس آمد، قبل از هر کاری چند دقیقه فاصله ایجاد کن. همین مکث مهم است.'),
  _SupportMessage('به مسیر برگرد', 'اگر روز سختی داشتی، به جای سرزنش کردن خودت فقط به قدم بعدی فکر کن.'),
  _SupportMessage('بدنت را مشغول کن', 'چند حرکت ساده، شستن صورت یا یک پیاده‌روی کوتاه می‌تواند تمرکزت را از هوس جدا کند.'),
  _SupportMessage('ذهن تو هم یاد می‌گیرد', 'هر بار که یک محرک را بدون سیگار پشت سر می‌گذاری، یک الگوی تازه تمرین می‌کنی.'),
  _SupportMessage('یادآوری نفس 🌿', 'تو مجبور نیستی هر فکری را دنبال کنی. بعضی فکرها فقط می‌آیند و می‌روند.'),
  _SupportMessage('برای فردای خودت', 'انتخاب امروزت یک هدیه کوچک برای نسخه فردای خودت است.'),
  _SupportMessage('همین که ادامه می‌دهی', 'لازم نیست هر روز پرانرژی باشی؛ استمرار آرام هم پیشرفت واقعی است.'),
];

Future<bool> _ensureInitialized() async {
  try {
    _initialization ??= _initializeNotifications();
    await _initialization;
    return true;
  } catch (_) {
    _initialization = null;
    return false;
  }
}

Future<void> _initializeNotifications() async {
  tz_data.initializeTimeZones();
  try {
    final timezoneInfo = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timezoneInfo.identifier));
  } catch (_) {
    tz.setLocalLocation(tz.UTC);
  }

  const android = AndroidInitializationSettings('ic_notification');
  const settings = InitializationSettings(android: android);
  await _plugin.initialize(settings);

  final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>();
  await androidPlugin?.createNotificationChannel(
    const AndroidNotificationChannel(
      _channelId,
      _channelName,
      description: _channelDescription,
      importance: Importance.defaultImportance,
    ),
  );
}

Future<String> permissionStatus() async {
  try {
    final enabled =
        await _settingsChannel.invokeMethod<bool>('areNotificationsEnabled');
    return enabled == true ? 'granted' : 'denied';
  } catch (_) {
    try {
      final android = _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      if (android == null) return 'unsupported';
      final enabled = await android.areNotificationsEnabled();
      return enabled == true ? 'granted' : 'denied';
    } catch (_) {
      return 'denied';
    }
  }
}

Future<String> requestPermission() async {
  try {
    final granted = await _settingsChannel
        .invokeMethod<bool>('requestNotificationPermission');
    return granted == true ? 'granted' : 'denied';
  } catch (_) {
    try {
      final android = _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      if (android == null) return 'unsupported';
      final granted = await android.requestNotificationsPermission();
      return granted == true ? 'granted' : 'denied';
    } catch (_) {
      return 'denied';
    }
  }
}

_SupportMessage _messageForDate(tz.TZDateTime date) {
  final dayNumber = DateTime.utc(date.year, date.month, date.day)
      .difference(DateTime.utc(2020, 1, 1))
      .inDays;
  // 7 is coprime with 40, therefore 40 consecutive days traverse all 40
  // messages exactly once before the cycle repeats.
  final index = (dayNumber * 7).abs() % _supportMessages.length;
  return _supportMessages[index];
}

NotificationDetails _notificationDetails() => const NotificationDetails(
      android: AndroidNotificationDetails(
        _channelId,
        _channelName,
        channelDescription: _channelDescription,
        importance: Importance.defaultImportance,
        priority: Priority.defaultPriority,
        icon: 'ic_notification',
      ),
    );

Future<bool> showTestNotification() async {
  if (await permissionStatus() != 'granted') return false;
  if (!await _ensureInitialized()) return false;

  try {
    await _plugin.show(
      _testNotificationId,
      'نفس 🌱',
      'اعلان‌ها آماده‌اند؛ یادآوری روزانه‌ات از همین‌جا می‌رسد.',
      _notificationDetails(),
    );
    return true;
  } catch (_) {
    return false;
  }
}

Future<bool> scheduleDailySupportReminder({
  required int hour,
  required int minute,
}) async {
  if (await permissionStatus() != 'granted') return false;
  if (!await _ensureInitialized()) return false;

  try {
    // Remove the old repeating V1 reminder as well as the rolling schedule.
    await _plugin.cancel(_legacyDailyReminderId);
    for (var i = 0; i < _scheduledDays; i++) {
      await _plugin.cancel(_dailyReminderBaseId + i);
    }

    final now = tz.TZDateTime.now(tz.local);
    var first = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );
    if (!first.isAfter(now)) {
      final tomorrow = now.add(const Duration(days: 1));
      first = tz.TZDateTime(
        tz.local,
        tomorrow.year,
        tomorrow.month,
        tomorrow.day,
        hour,
        minute,
      );
    }

    // Keep a rolling 60-day offline schedule. App startup refreshes this
    // window whenever reminders are enabled, so it does not expire in normal
    // use while keeping pending Android alarms comfortably low.
    for (var i = 0; i < _scheduledDays; i++) {
      final roughDay = first.add(Duration(days: i));
      final scheduledAt = tz.TZDateTime(
        tz.local,
        roughDay.year,
        roughDay.month,
        roughDay.day,
        hour,
        minute,
      );
      final message = _messageForDate(scheduledAt);

      await _plugin.zonedSchedule(
        _dailyReminderBaseId + i,
        message.title,
        message.body,
        scheduledAt,
        _notificationDetails(),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      );
    }
    return true;
  } catch (_) {
    return false;
  }
}

Future<void> cancelDailySupportReminder() async {
  if (!await _ensureInitialized()) return;
  try {
    await _plugin.cancel(_legacyDailyReminderId);
    for (var i = 0; i < _scheduledDays; i++) {
      await _plugin.cancel(_dailyReminderBaseId + i);
    }
  } catch (_) {
    // Disabling reminders should never crash the settings screen.
  }
}

Future<bool> openNotificationSettings() async {
  try {
    return await _settingsChannel
            .invokeMethod<bool>('openNotificationSettings') ??
        false;
  } catch (_) {
    return false;
  }
}
