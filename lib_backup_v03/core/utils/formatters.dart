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
  final s = value.toString();
  final b = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) b.write('٬');
    b.write(s[i]);
  }
  return faDigits(b.toString());
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
