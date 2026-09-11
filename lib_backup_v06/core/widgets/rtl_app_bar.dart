import 'package:flutter/material.dart';
import '../theme/nafas_colors.dart';
import 'rtl_icons.dart';

class RtlAppBar extends StatelessWidget implements PreferredSizeWidget {
  const RtlAppBar({
    super.key,
    required this.title,
    this.actions = const [],
    this.dark = false,
    this.showBack = true,
  });

  final String title;
  final List<Widget> actions;
  final bool dark;
  final bool showBack;

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    final color = dark ? Colors.white : NafasColors.textPrimary;

    return SafeArea(
      bottom: false,
      child: SizedBox(
        height: 64,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Row(
            textDirection: TextDirection.rtl,
            children: [
              if (showBack) NafasBackButton(dark: dark) else const SizedBox(width: 42),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: color,
                    fontSize: 19,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              if (actions.isNotEmpty) ...[
                const SizedBox(width: 8),
                ...actions,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
