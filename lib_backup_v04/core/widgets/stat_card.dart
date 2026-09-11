import 'package:flutter/material.dart';
import '../theme/nafas_colors.dart';

class StatCard extends StatelessWidget {
  const StatCard({super.key, required this.icon, required this.value, required this.label});
  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(21),
          border: Border.all(color: NafasColors.border.withValues(alpha: .75)),
          boxShadow: const [BoxShadow(color: Color(0x0B083B34), blurRadius: 22, offset: Offset(0, 9))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(color: NafasColors.surfaceSoft, borderRadius: BorderRadius.circular(11)),
              child: Icon(icon, color: NafasColors.primary, size: 18),
            ),
            const SizedBox(height: 13),
            Text(value, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 16.5, fontWeight: FontWeight.w900, color: NafasColors.textPrimary)),
            const SizedBox(height: 3),
            Text(label, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}
