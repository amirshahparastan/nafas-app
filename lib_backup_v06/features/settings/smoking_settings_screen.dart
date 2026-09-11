import 'package:flutter/material.dart';
import '../../core/state/app_state.dart';
import '../../core/widgets/nafas_buttons.dart';
import '../../core/widgets/rtl_app_bar.dart';

class SmokingSettingsScreen extends StatefulWidget {
  const SmokingSettingsScreen({super.key});

  @override
  State<SmokingSettingsScreen> createState() => _SmokingSettingsScreenState();
}

class _SmokingSettingsScreenState extends State<SmokingSettingsScreen> {
  bool _initialized = false;
  late final TextEditingController dailyController;
  late final TextEditingController perPackController;
  late final TextEditingController priceController;
  late final TextEditingController reasonController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;
    final state = NafasScope.of(context);
    dailyController = TextEditingController(text: state.cigarettesPerDay.toString());
    perPackController = TextEditingController(text: state.cigarettesPerPack.toString());
    priceController = TextEditingController(text: state.packPriceToman.toString());
    reasonController = TextEditingController(text: state.personalQuitReason);
  }

  @override
  void dispose() {
    dailyController.dispose();
    perPackController.dispose();
    priceController.dispose();
    reasonController.dispose();
    super.dispose();
  }

  int _number(TextEditingController controller, int fallback) => int.tryParse(controller.text.replaceAll(RegExp(r'[^0-9]'), '')) ?? fallback;

  @override
  Widget build(BuildContext context) {
    final state = NafasScope.of(context);
    return Scaffold(
      appBar: const RtlAppBar(title: 'اطلاعات مصرف و انگیزه'),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 30),
        children: [
          TextField(controller: dailyController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'تعداد نخ در روز')),
          const SizedBox(height: 10),
          TextField(controller: perPackController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'تعداد نخ در هر پاکت')),
          const SizedBox(height: 10),
          TextField(controller: priceController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'قیمت پاکت (تومان)')),
          const SizedBox(height: 18),
          Text('چرا می‌خوای ترک کنی؟', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 5),
          Text('این متن خصوصی می‌مونه و در لحظه‌های هوس به خودت یادآوری میشه.', style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 10),
          TextField(controller: reasonController, maxLines: 4, decoration: const InputDecoration(hintText: 'مثلاً برای سلامتی، خانواده، آرامش، هزینه‌ها...')),
          const SizedBox(height: 16),
          NafasPrimaryButton(
            label: 'ذخیره تغییرات',
            onPressed: () {
              state.updateSmokingProfile(
                perDay: _number(dailyController, state.cigarettesPerDay),
                perPack: _number(perPackController, state.cigarettesPerPack),
                packPrice: _number(priceController, state.packPriceToman),
                quitReason: reasonController.text,
              );
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('اطلاعات مصرف و انگیزه ذخیره شد.')));
            },
          ),
        ],
      ),
    );
  }
}
