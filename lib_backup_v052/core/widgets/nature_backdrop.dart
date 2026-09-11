import 'package:flutter/material.dart';
import '../theme/nafas_colors.dart';

class NatureBackdrop extends StatelessWidget {
  const NatureBackdrop({super.key, this.dark = false, this.height = 220});
  final bool dark;
  final double height;
  @override
  Widget build(BuildContext context) {
    return SizedBox(height: height, width: double.infinity, child: CustomPaint(painter: _NaturePainter(dark: dark)));
  }
}

class _NaturePainter extends CustomPainter {
  _NaturePainter({required this.dark});
  final bool dark;
  @override
  void paint(Canvas canvas, Size size) {
    final bg = Paint()..shader = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: dark ? const [Color(0xFF0B4F43), Color(0xFF083B34)] : const [Color(0xFFE7F5EF), Color(0xFFF8FBF9)],
    ).createShader(Offset.zero & size);
    canvas.drawRRect(RRect.fromRectAndRadius(Offset.zero & size, const Radius.circular(30)), bg);
    final far = Paint()..color = (dark ? Colors.white : NafasColors.primary).withValues(alpha: dark ? .08 : .08);
    final mid = Paint()..color = (dark ? Colors.white : NafasColors.primary).withValues(alpha: dark ? .10 : .12);
    final p1 = Path()..moveTo(0, size.height*.72)..lineTo(size.width*.23,size.height*.35)..lineTo(size.width*.42,size.height*.66)..lineTo(size.width*.62,size.height*.28)..lineTo(size.width,size.height*.70)..lineTo(size.width,size.height)..lineTo(0,size.height)..close();
    canvas.drawPath(p1, far);
    final p2 = Path()..moveTo(0,size.height*.82)..lineTo(size.width*.28,size.height*.58)..lineTo(size.width*.48,size.height*.77)..lineTo(size.width*.72,size.height*.50)..lineTo(size.width,size.height*.78)..lineTo(size.width,size.height)..lineTo(0,size.height)..close();
    canvas.drawPath(p2, mid);
    final sun = Paint()..color = (dark ? const Color(0xFFFFE9A8) : const Color(0xFFFFD996)).withValues(alpha: dark ? .22 : .45);
    canvas.drawCircle(Offset(size.width*.78, size.height*.24), size.width*.08, sun);
  }
  @override bool shouldRepaint(covariant _NaturePainter oldDelegate) => oldDelegate.dark != dark;
}
