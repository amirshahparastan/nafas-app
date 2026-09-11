import 'package:flutter/material.dart';
import '../theme/nafas_colors.dart';

class SectionTitle extends StatelessWidget {
  const SectionTitle({super.key, required this.title, this.action, this.onAction});
  final String title;
  final String? action;
  final VoidCallback? onAction;
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: NafasColors.textPrimary))),
      if (action != null) TextButton(onPressed: onAction, child: Text(action!)),
    ]);
  }
}
