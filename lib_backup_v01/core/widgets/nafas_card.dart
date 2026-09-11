import 'package:flutter/material.dart';
import '../theme/nafas_colors.dart';
import '../theme/nafas_radius.dart';

class NafasCard extends StatelessWidget {
  const NafasCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.backgroundColor = NafasColors.surface,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(NafasRadius.card),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D083B34),
            blurRadius: 24,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }
}
