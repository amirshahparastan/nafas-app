import 'package:flutter/material.dart';
import '../theme/nafas_colors.dart';

class NafasPrimaryButton extends StatelessWidget {
  const NafasPrimaryButton({super.key, required this.label, required this.onPressed, this.icon});
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[Icon(icon, size: 20), const SizedBox(width: 8)],
          Text(label),
        ],
      ),
    );
  }
}

class NafasSecondaryButton extends StatelessWidget {
  const NafasSecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.selected = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor: selected ? NafasColors.surfaceSoft : Colors.white,
        foregroundColor: selected ? NafasColors.primary : NafasColors.textPrimary,
        side: BorderSide(color: selected ? NafasColors.primary.withValues(alpha: .35) : NafasColors.border),
        shadowColor: const Color(0x18083B34),
        elevation: selected ? 1 : 0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[Icon(icon, size: 20), const SizedBox(width: 8)],
          Text(label),
        ],
      ),
    );
  }
}

class NafasAccentButton extends StatelessWidget {
  const NafasAccentButton({super.key, required this.label, required this.onPressed, this.icon});
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: NafasColors.accent,
        foregroundColor: Colors.white,
        shadowColor: NafasColors.accent.withValues(alpha: .28),
        elevation: 5,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[Icon(icon, size: 20), const SizedBox(width: 8)],
          Text(label),
        ],
      ),
    );
  }
}
