import 'package:flutter/material.dart';
import '../theme/nafas_colors.dart';

class NafasLogo extends StatelessWidget {
  const NafasLogo({super.key, this.compact = false, this.light = false});
  final bool compact;
  final bool light;

  @override
  Widget build(BuildContext context) {
    final color = light ? Colors.white : NafasColors.primaryDark;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: compact ? 34 : 42,
          height: compact ? 34 : 42,
          decoration: BoxDecoration(color: light ? const Color(0x22FFFFFF) : NafasColors.surfaceSoft, borderRadius: BorderRadius.circular(14)),
          child: Icon(Icons.eco_rounded, color: light ? Colors.white : NafasColors.primary, size: compact ? 21 : 27),
        ),
        const SizedBox(width: 9),
        Text('نفس', style: TextStyle(color: color, fontSize: compact ? 20 : 26, fontWeight: FontWeight.w900, letterSpacing: -.8)),
      ],
    );
  }
}
