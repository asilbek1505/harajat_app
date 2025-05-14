// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// class BudgetCard extends StatefulWidget {
//   Color textColor;
//   Color cardColor;
//   Color accentColor;
//   double percentage;
//   String selectedDate;
//   double remainingBudget;
//   DateTime currentMonth;
//   final double monthlyBudget;
//   Function buildBudgetInfo;
//   void updateFilteredItems;
//    BudgetCard({super.key,required this.textColor,required this.cardColor,required this.currentMonth,required this.accentColor,required this.percentage,required this.remainingBudget,required this.monthlyBudget,required this.buildBudgetInfo,required this.selectedDate,required this.updateFilteredItems});
//
//   @override
//   State<BudgetCard> createState() => _BudgetCardState();
// }
//
// class _BudgetCardState extends State<BudgetCard> {
//   void _prevMonth() {
//     setState(() {
//       widget.currentMonth = DateTime(widget.currentMonth.year, widget.currentMonth.month - 1);
//       widget.selectedDate=null;
//       widget.updateFilteredItems();
//     });
//   }
//
//   void _nextMonth() {
//     setState(() {
//       widget.currentMonth = DateTime(widget.currentMonth.year, widget.currentMonth.month + 1);
//       widget.selectedDate = null;
//       widget.updateFilteredItems();
//     });
//   }
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     final progressColor = widget.percentage > 100
//         ? Colors.redAccent
//         : widget.percentage > 80
//         ? Colors.orange
//         : widget.accentColor;
//
//     return Card(
//       color: widget.cardColor,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//       elevation: 4,
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             Text(
//               DateFormat('MMMM, yyyy').format(widget.currentMonth),
//               style: TextStyle(fontSize: 20, color:widget. textColor),
//             ),
//             const SizedBox(height: 12),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 IconButton(onPressed: _prevMonth, icon: Icon(Icons.arrow_left, color:widget. textColor)),
//                 Flexible(
//                   child: FittedBox(
//                     child: Text(
//                       "${NumberFormat('#,##0', 'en_US').format(widget.monthlyBudget)} so'm",
//                       style: TextStyle(fontSize: 30, color: widget.textColor, fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                 ),
//                 IconButton(onPressed: _nextMonth, icon: Icon(Icons.arrow_right, color:widget. textColor)),
//               ],
//             ),
//             const SizedBox(height: 12),
//             widget.buildBudgetInfo(widget.textColor),
//             const SizedBox(height: 10),
//             ClipRRect(
//               borderRadius: BorderRadius.circular(10),
//               child: LinearProgressIndicator(
//                 value: (widget.percentage / 100).clamp(0, 1),
//                 color: progressColor,
//                 backgroundColor:widget. textColor.withOpacity(0.2),
//                 minHeight: 10,
//               ),
//             ),
//             const SizedBox(height: 10),
//             Text(
//               "${'remaining_budget'.tr()}: ${NumberFormat('#,##0', 'en_US').format(widget.remainingBudget)} so'm",
//               style: TextStyle(
//                 color: widget.remainingBudget < 0 ? Colors.redAccent : widget. accentColor,
//                 fontSize: 16,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
