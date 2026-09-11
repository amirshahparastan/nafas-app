import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/nafas_colors.dart';
import '../utils/formatters.dart';

class NafasMoneyField extends StatelessWidget {
  const NafasMoneyField({
    super.key,
    required this.controller,
    required this.label,
    this.helperText,
    this.presetAmounts = const <int>[],
  });

  final TextEditingController controller;
  final String label;
  final String? helperText;
  final List<int> presetAmounts;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.titleMedium),
        if (helperText != null) ...[
          const SizedBox(height: 4),
          Text(helperText!, style: Theme.of(context).textTheme.bodySmall),
        ],
        const SizedBox(height: 9),
        Container(
          padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: NafasColors.border),
            boxShadow: const [BoxShadow(color: Color(0x08083B34), blurRadius: 18, offset: Offset(0, 7))],
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.right,
                  inputFormatters: const [_TomanInputFormatter()],
                  style: const TextStyle(
                    fontFamily: 'Vazirmatn',
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: NafasColors.textPrimary,
                  ),
                  decoration: const InputDecoration(
                    isDense: true,
                    filled: false,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 11),
                    hintText: '۰',
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
                decoration: BoxDecoration(
                  color: NafasColors.moneySoft,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'تومان',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w900,
                    color: NafasColors.money,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (presetAmounts.isNotEmpty) ...[
          const SizedBox(height: 10),
          Wrap(
            spacing: 7,
            runSpacing: 7,
            children: presetAmounts
                .map(
                  (amount) => ActionChip(
                    avatar: const Icon(Icons.add_rounded, size: 15, color: NafasColors.money),
                    backgroundColor: NafasColors.moneySoft,
                    side: BorderSide.none,
                    label: Text(_presetLabel(amount)),
                    onPressed: () => controller.text = _groupDigits(amount.toString()),
                  ),
                )
                .toList(),
          ),
        ],
      ],
    );
  }

  static int parse(TextEditingController controller, {int fallback = 0}) {
    final normalized = _latinDigits(controller.text).replaceAll(RegExp(r'[^0-9]'), '');
    return int.tryParse(normalized) ?? fallback;
  }

  static String _presetLabel(int amount) {
    if (amount >= 1000000 && amount % 1000000 == 0) {
      return '${faDigits((amount ~/ 1000000).toString())} میلیون';
    }
    return formatToman(amount.toDouble());
  }
}

class _TomanInputFormatter extends TextInputFormatter {
  const _TomanInputFormatter();

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final digits = _latinDigits(newValue.text).replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.isEmpty) return const TextEditingValue(text: '');
    final grouped = _groupDigits(digits);
    return TextEditingValue(text: grouped, selection: TextSelection.collapsed(offset: grouped.length));
  }
}

String _latinDigits(String input) {
  const fa = '۰۱۲۳۴۵۶۷۸۹';
  const ar = '٠١٢٣٤٥٦٧٨٩';
  var out = input;
  for (var i = 0; i < 10; i++) {
    out = out.replaceAll(fa[i], '$i').replaceAll(ar[i], '$i');
  }
  return out;
}

String _groupDigits(String digits) {
  final clean = digits.replaceFirst(RegExp(r'^0+(?=\d)'), '');
  final buffer = StringBuffer();
  for (var i = 0; i < clean.length; i++) {
    if (i > 0 && (clean.length - i) % 3 == 0) buffer.write('٬');
    buffer.write(clean[i]);
  }
  return faDigits(buffer.toString());
}
