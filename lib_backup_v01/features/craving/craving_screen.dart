import 'package:flutter/material.dart';
import '../../core/theme/nafas_colors.dart';

class CravingScreen extends StatefulWidget {
  const CravingScreen({super.key});

  @override
  State<CravingScreen> createState() => _CravingScreenState();
}

class _CravingScreenState extends State<CravingScreen> {
  int intensity = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NafasColors.forest,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text('الان هوس کردم'),
      ),
      body: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            children: [
              const Spacer(),
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white24, width: 14),
                ),
                child: const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('03:00', style: TextStyle(color: Colors.white, fontSize: 33, fontWeight: FontWeight.w900)),
                      SizedBox(height: 4),
                      Text('فقط همین چند دقیقه', style: TextStyle(color: Colors.white70, fontSize: 11)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 34),
              const Text('این حس موقتیه.', style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w900)),
              const SizedBox(height: 10),
              const Text('شدت هوس رو مشخص کن و بعد با هم ازش رد می‌شیم.', textAlign: TextAlign.center, style: TextStyle(color: Colors.white70, height: 1.7)),
              const SizedBox(height: 28),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  final value = index + 1;
                  final selected = value == intensity;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: InkWell(
                      onTap: () => setState(() => intensity = value),
                      borderRadius: BorderRadius.circular(99),
                      child: Container(
                        width: 44,
                        height: 44,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: selected ? NafasColors.accent : Colors.white10,
                          shape: BoxShape.circle,
                          border: Border.all(color: selected ? NafasColors.accent : Colors.white24),
                        ),
                        child: Text('$value', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
                      ),
                    ),
                  );
                }),
              ),
              const Spacer(),
              FilledButton(
                onPressed: () => _showPassed(context),
                style: FilledButton.styleFrom(backgroundColor: NafasColors.accent),
                child: const Text('شروع تمرین ۳ دقیقه‌ای'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPassed(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      builder: (context) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 6, 20, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircleAvatar(
              radius: 30,
              backgroundColor: NafasColors.surfaceSoft,
              child: Icon(Icons.check_rounded, color: NafasColors.success, size: 30),
            ),
            const SizedBox(height: 14),
            const Text('ازش رد شدی 🌱', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: NafasColors.textPrimary)),
            const SizedBox(height: 8),
            const Text('این Session بعداً در آمار هوس‌ها ثبت میشه.', textAlign: TextAlign.center, style: TextStyle(color: NafasColors.textSecondary)),
            const SizedBox(height: 18),
            FilledButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('برگشت به خانه'),
            ),
          ],
        ),
      ),
    );
  }
}
