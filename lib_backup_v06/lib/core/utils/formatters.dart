import 'jalali.dart';

String faDigits(Object value) {
  const en = '0123456789';
  const fa = '۰۱۲۳۴۵۶۷۸۹';
  var text = value.toString();
  for (var i = 0; i < en.length; i++) {
    text = text.replaceAll(en[i], fa[i]);
  }
  return text;
}

String formatInt(int value) {
  final negative = value < 0;
  final s = value.abs().toString();
  final b = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) b.write('٬');
    b.write(s[i]);
  }
  return '${negative ? '−' : ''}${faDigits(b.toString())}';
}

String formatToman(double value) {
  if (value >= 1000000) {
    final m = value / 1000000;
    final digits = m >= 10 || m == m.roundToDouble() ? 0 : 1;
    return '${faDigits(m.toStringAsFixed(digits))} میلیون تومان';
  }
  return '${formatInt(value.round())} تومان';
}

String formatDurationDays(int days) {
  if (days <= 0) return 'روز اول';
  return '${faDigits(days)} روز';
}

String formatJalaliNumeric(DateTime date) {
  final j = JalaliDate.fromDateTime(date);
  return '${faDigits(j.year)}/${faDigits(j.month.toString().padLeft(2, '0'))}/${faDigits(j.day.toString().padLeft(2, '0'))}';
}

String formatJalaliDate(DateTime date, {bool includeWeekday = true}) {
  final j = JalaliDate.fromDateTime(date);
  final body = '${faDigits(j.day)} ${j.monthName} ${faDigits(j.year)}';
  return includeWeekday ? '${persianWeekdayName(date)}، $body' : body;
}

String formatJalaliMonth(DateTime date) {
  final j = JalaliDate.fromDateTime(date);
  return '${j.monthName} ${faDigits(j.year)}';
}

String formatRelativePersianTime(DateTime date) {
  final difference = DateTime.now().difference(date);
  if (difference.inMinutes < 1) return 'همین الان';
  if (difference.inMinutes < 60) return '${faDigits(difference.inMinutes)} دقیقه پیش';
  if (difference.inHours < 24) return '${faDigits(difference.inHours)} ساعت پیش';
  if (difference.inDays < 7) return '${faDigits(difference.inDays)} روز پیش';
  return formatJalaliDate(date, includeWeekday: false);
}
