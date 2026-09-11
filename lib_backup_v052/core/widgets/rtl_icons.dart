import 'package:flutter/material.dart';
import '../theme/nafas_colors.dart';

/// Directional icons in Nafas are intentionally forced to LTR rendering.
/// Flutter mirrors some Material icons automatically inside RTL contexts;
/// forcing textDirection here keeps the visual direction predictable.
class NafasBackButton extends StatelessWidget {
  const NafasBackButton({super.key, this.dark = false, this.onPressed});

  final bool dark;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final foreground = dark ? Colors.white : NafasColors.textPrimary;
    final background = dark ? Colors.white.withValues(alpha: .10) : Colors.white;
    final border = dark ? Colors.white.withValues(alpha: .10) : NafasColors.border;

    return Semantics(
      button: true,
      label: 'بازگشت',
      child: InkWell(
        onTap: onPressed ?? () => Navigator.maybePop(context),
        borderRadius: BorderRadius.circular(14),
        child: Container(
          width: 42,
          height: 42,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: border),
          ),
          child: Icon(
            Icons.arrow_forward_rounded,
            textDirection: TextDirection.ltr,
            color: foreground,
            size: 22,
          ),
        ),
      ),
    );
  }
}

/// In Persian RTL lists, entering a deeper page is visually toward the left.
class NafasDisclosureIcon extends StatelessWidget {
  const NafasDisclosureIcon({super.key, this.color = NafasColors.textMuted, this.size = 24});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.chevron_left_rounded,
      textDirection: TextDirection.ltr,
      color: color,
      size: size,
    );
  }
}

/// Calendar navigation: older/previous month is shown toward the right in RTL.
class NafasPreviousIcon extends StatelessWidget {
  const NafasPreviousIcon({super.key, this.color});
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.chevron_right_rounded,
      textDirection: TextDirection.ltr,
      color: color,
    );
  }
}

/// Calendar navigation: newer/next month is shown toward the left in RTL.
class NafasNextIcon extends StatelessWidget {
  const NafasNextIcon({super.key, this.color});
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.chevron_left_rounded,
      textDirection: TextDirection.ltr,
      color: color,
    );
  }
}
