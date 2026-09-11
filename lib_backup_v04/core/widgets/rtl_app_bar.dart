import 'package:flutter/material.dart';
import '../theme/nafas_colors.dart';

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
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    final color = dark ? Colors.white : NafasColors.textPrimary;
    return SafeArea(
      bottom: false,
      child: SizedBox(
        height: 60,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              if (showBack)
                IconButton(
                  tooltip: 'بازگشت',
                  onPressed: () => Navigator.maybePop(context),
                  icon: Icon(Icons.arrow_forward_rounded, color: color),
                )
              else
                const SizedBox(width: 48),
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
              ...actions,
            ],
          ),
        ),
      ),
    );
  }
}
