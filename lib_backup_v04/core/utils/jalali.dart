class JalaliDate {
  const JalaliDate(this.year, this.month, this.day);

  final int year;
  final int month;
  final int day;

  static const monthNames = <String>[
    'فروردین',
    'اردیبهشت',
    'خرداد',
    'تیر',
    'مرداد',
    'شهریور',
    'مهر',
    'آبان',
    'آذر',
    'دی',
    'بهمن',
    'اسفند',
  ];

  String get monthName => monthNames[month - 1];

  static JalaliDate fromDateTime(DateTime date) {
    var gy = date.year - 1600;
    final gm = date.month - 1;
    final gd = date.day - 1;

    final gDays = <int>[31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
    var gDayNo = 365 * gy + (gy + 3) ~/ 4 - (gy + 99) ~/ 100 + (gy + 399) ~/ 400;
    for (var i = 0; i < gm; i++) {
      gDayNo += gDays[i];
    }
    if (gm > 1 && ((gy + 1600) % 4 == 0 && ((gy + 1600) % 100 != 0 || (gy + 1600) % 400 == 0))) {
      gDayNo++;
    }
    gDayNo += gd;

    var jDayNo = gDayNo - 79;
    final jNp = jDayNo ~/ 12053;
    jDayNo %= 12053;

    var jy = 979 + 33 * jNp + 4 * (jDayNo ~/ 1461);
    jDayNo %= 1461;

    if (jDayNo >= 366) {
      jy += (jDayNo - 1) ~/ 365;
      jDayNo = (jDayNo - 1) % 365;
    }

    final jDays = <int>[31, 31, 31, 31, 31, 31, 30, 30, 30, 30, 30, 29];
    var jm = 0;
    while (jm < 11 && jDayNo >= jDays[jm]) {
      jDayNo -= jDays[jm];
      jm++;
    }
    return JalaliDate(jy, jm + 1, jDayNo + 1);
  }

  DateTime toDateTime() {
    var jy = year - 979;
    final jm = month - 1;
    final jd = day - 1;

    final jDays = <int>[31, 31, 31, 31, 31, 31, 30, 30, 30, 30, 30, 29];
    var jDayNo = 365 * jy + (jy ~/ 33) * 8 + ((jy % 33) + 3) ~/ 4;
    for (var i = 0; i < jm; i++) {
      jDayNo += jDays[i];
    }
    jDayNo += jd;

    var gDayNo = jDayNo + 79;
    var gy = 1600 + 400 * (gDayNo ~/ 146097);
    gDayNo %= 146097;

    var leap = true;
    if (gDayNo >= 36525) {
      gDayNo--;
      gy += 100 * (gDayNo ~/ 36524);
      gDayNo %= 36524;
      if (gDayNo >= 365) {
        gDayNo++;
      } else {
        leap = false;
      }
    }

    gy += 4 * (gDayNo ~/ 1461);
    gDayNo %= 1461;

    if (gDayNo >= 366) {
      leap = false;
      gDayNo--;
      gy += gDayNo ~/ 365;
      gDayNo %= 365;
    }

    final gDays = <int>[31, leap ? 29 : 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
    var gm = 0;
    while (gm < 11 && gDayNo >= gDays[gm]) {
      gDayNo -= gDays[gm];
      gm++;
    }

    return DateTime(gy, gm + 1, gDayNo + 1);
  }

  int get daysInMonth {
    if (month <= 6) return 31;
    if (month <= 11) return 30;
    final first = JalaliDate(year, 1, 1).toDateTime();
    final next = JalaliDate(year + 1, 1, 1).toDateTime();
    return next.difference(first).inDays == 366 ? 30 : 29;
  }

  JalaliDate nextMonth() => month == 12 ? JalaliDate(year + 1, 1, 1) : JalaliDate(year, month + 1, 1);
  JalaliDate previousMonth() => month == 1 ? JalaliDate(year - 1, 12, 1) : JalaliDate(year, month - 1, 1);
}

const persianWeekdayNamesSaturdayFirst = <String>[
  'شنبه',
  'یکشنبه',
  'دوشنبه',
  'سه‌شنبه',
  'چهارشنبه',
  'پنجشنبه',
  'جمعه',
];

String persianWeekdayName(DateTime date) {
  switch (date.weekday) {
    case DateTime.monday:
      return 'دوشنبه';
    case DateTime.tuesday:
      return 'سه‌شنبه';
    case DateTime.wednesday:
      return 'چهارشنبه';
    case DateTime.thursday:
      return 'پنجشنبه';
    case DateTime.friday:
      return 'جمعه';
    case DateTime.saturday:
      return 'شنبه';
    default:
      return 'یکشنبه';
  }
}

int saturdayFirstWeekdayIndex(DateTime date) => (date.weekday + 1) % 7;

bool sameCalendarDay(DateTime a, DateTime b) => a.year == b.year && a.month == b.month && a.day == b.day;
