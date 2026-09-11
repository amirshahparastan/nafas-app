import 'package:flutter/material.dart';
import '../theme/nafas_colors.dart';
import '../theme/nafas_radius.dart';

class NafasCard extends StatelessWidget {
  const NafasCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(18),
    this.backgroundColor = NafasColors.surface,
    this.onTap,
    this.elevated = true,
  });

  final Widget child;
  final EdgeInsets padding;
  final Color backgroundColor;
  final VoidCallback? onTap;
  final bool elevated;

  @override
  Widget build(BuildContext context) {
    final box = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(NafasRadius.card),
        border: Border.all(color: NafasColors.border.withValues(alpha: .68)),
        boxShadow: elevated
            ? const [
                BoxShadow(color: Color(0x0D083B34), blurRadius: 26, offset: Offset(0, 10)),
                BoxShadow(color: Color(0x08FFFFFF), blurRadius: 3, offset: Offset(0, -1)),
              ]
            : null,
      ),
      child: child,
    );
    if (onTap == null) return box;
    return InkWell(onTap: onTap, borderRadius: BorderRadius.circular(NafasRadius.card), child: box);
  }
}
