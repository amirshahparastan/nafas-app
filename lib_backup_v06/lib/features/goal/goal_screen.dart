import 'package:flutter/material.dart';
import '../../core/state/app_state.dart';
import '../../core/theme/nafas_colors.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/nafas_card.dart';
import '../../core/widgets/nature_backdrop.dart';
import '../../core/widgets/nafas_money_field.dart';

class GoalScreen extends StatelessWidget {
  const GoalScreen({super.key});
  @override Widget build(BuildContext context) {
    final state = NafasScope.of(context);
    return SafeArea(child: SingleChildScrollView(padding: const EdgeInsets.fromLTRB(18,18,18,120), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children:[
      Row(children:[Expanded(child: Column(crossAxisAlignment:CrossAxisAlignment.start, children:[Text('هدف من', style: Theme.of(context).textTheme.headlineMedium), const SizedBox(height:4), Text('پول سیگارت، قدم‌به‌قدم تبدیل می‌شه به چیزی که می‌خوای.', style: Theme.of(context).textTheme.bodyMedium)])), IconButton.filledTonal(onPressed:()=>_edit(context,state), icon:const Icon(Icons.edit_outlined))]),
      const SizedBox(height:20),
      if(!state.hasGoal) _empty(context,state) else ...[
        Stack(children:[const NatureBackdrop(height:235), Positioned.fill(child: Padding(padding:const EdgeInsets.all(22), child: Column(crossAxisAlignment:CrossAxisAlignment.start, children:[const Icon(Icons.flag_rounded,color:NafasColors.primary,size:34), const Spacer(), Text(state.goalTitle, style:const TextStyle(fontSize:25,fontWeight:FontWeight.w900,color:NafasColors.textPrimary)), const SizedBox(height:5), Text('${formatToman(state.moneySaved)} از ${formatToman(state.goalAmountToman.toDouble())}', style:Theme.of(context).textTheme.bodyMedium)])))]),
        const SizedBox(height:18), NafasCard(child:Column(children:[Row(children:[_Metric(label:'پیشرفت',value:'${formatInt((state.goalProgress*100).round())}٪'), const _Divider(), _Metric(label:'باقی‌مانده',value:formatToman((state.goalAmountToman-state.moneySaved).clamp(0,double.infinity).toDouble())), const _Divider(), _Metric(label:'تخمین',value:'${formatInt(state.estimatedGoalDaysRemaining)} روز')]), const SizedBox(height:18), ClipRRect(borderRadius:BorderRadius.circular(99),child:LinearProgressIndicator(value:state.goalProgress,minHeight:12,backgroundColor:NafasColors.surfaceSoft,color:NafasColors.success))])),
        const SizedBox(height:16), NafasCard(backgroundColor:NafasColors.moneySoft, child:Row(children:[const Icon(Icons.insights_rounded,color:NafasColors.money), const SizedBox(width:12), Expanded(child:Text('با الگوی قبلی مصرف، هر روز تقریباً ${formatToman(state.dailySpend)} به هدفت نزدیک می‌شی.', style:const TextStyle(fontWeight:FontWeight.w800,color:NafasColors.textPrimary))) ])),
      ]
    ])));
  }
  Widget _empty(BuildContext context, NafasAppState state) => NafasCard(child:Column(children:[const Icon(Icons.flag_outlined,size:52,color:NafasColors.primary), const SizedBox(height:12), const Text('هنوز هدفی تعیین نکردی',style:TextStyle(fontSize:18,fontWeight:FontWeight.w900)), const SizedBox(height:6), Text('یک هدف واقعی انتخاب کن تا پول ذخیره‌شده برات معنی‌دارتر بشه.',textAlign:TextAlign.center,style:Theme.of(context).textTheme.bodyMedium), const SizedBox(height:18), FilledButton(onPressed:()=>_edit(context,state),child:const Text('ساخت هدف'))]));
  void _edit(BuildContext context, NafasAppState state) {
    final title=TextEditingController(text:state.hasGoal?state.goalTitle:''); final amount=TextEditingController(text:state.hasGoal?formatInt(state.goalAmountToman):'۱۰٬۰۰۰٬۰۰۰');
    showModalBottomSheet(context:context,isScrollControlled:true,backgroundColor:Colors.white,shape:const RoundedRectangleBorder(borderRadius:BorderRadius.vertical(top:Radius.circular(28))),builder:(ctx)=>Padding(padding:EdgeInsets.fromLTRB(18,20,18,MediaQuery.of(ctx).viewInsets.bottom+24),child:Column(mainAxisSize:MainAxisSize.min,crossAxisAlignment:CrossAxisAlignment.start,children:[const Text('ویرایش هدف',style:TextStyle(fontSize:20,fontWeight:FontWeight.w900)),const SizedBox(height:16),TextField(controller:title,decoration:const InputDecoration(labelText:'نام هدف')),const SizedBox(height:10),NafasMoneyField(controller:amount,label:'مبلغ هدف',presetAmounts:const [5000000,10000000,20000000,50000000]),const SizedBox(height:16),FilledButton(onPressed:(){state.updateGoal(title.text,NafasMoneyField.parse(amount,fallback:10000000));Navigator.pop(ctx);},child:const Text('ذخیره هدف')),if(state.hasGoal) TextButton(onPressed:(){state.removeGoal();Navigator.pop(ctx);},child:const Text('حذف هدف',style:TextStyle(color:NafasColors.danger))) ])));
  }
}
class _Metric extends StatelessWidget{const _Metric({required this.label,required this.value});final String label,value;@override Widget build(BuildContext context)=>Expanded(child:Column(children:[Text(value,textAlign:TextAlign.center,style:const TextStyle(fontSize:14,fontWeight:FontWeight.w900,color:NafasColors.textPrimary)),const SizedBox(height:3),Text(label,style:Theme.of(context).textTheme.bodySmall)]));}
class _Divider extends StatelessWidget{const _Divider();@override Widget build(BuildContext context)=>Container(width:1,height:38,color:NafasColors.border);}
