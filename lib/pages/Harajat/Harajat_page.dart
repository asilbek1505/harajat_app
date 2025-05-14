// lib/pages/Harajat/harajatPage.dart

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../../Model/harajat_model.dart';
import '../../servise/db_servsie.dart';
import '../../widgetlar/harajatlar_sanasi.dart';
import 'harajat_add.dart';
import 'harajatList.dart';

class HarajatPage extends StatefulWidget {
  final PageController pageController;
  final bool isDarkMode;
  final double monthlyBudget;
  final Function(BuildContext) onEditMonthlyBudget;

  const HarajatPage({
    super.key,
    required this.pageController,
    required this.isDarkMode,
    required this.monthlyBudget,
    required this.onEditMonthlyBudget,
  });

  @override
  State<HarajatPage> createState() => _HarajatPageState();
}

class _HarajatPageState extends State<HarajatPage> {
  List<HarajatModel> items = [];
  List<HarajatModel> dailyFilteredItems = [];
  String? selectedDate;
  late DateTime currentMonth;
  double monthlyExpense = 0.0;
  double dailyExpense = 0.0;
  double percentage = 0.0;
  double remainingBudget = 0.0;
  final Color accentColor = Colors.greenAccent;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    currentMonth = DateTime.now();
    selectedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    initializeDateFormatting('uz', null).then((_) {
      _loadHarajatlar();
    });
  }

  Future<void> _loadHarajatlar() async {
    setState(() => _isLoading = true);
    try {
      final loadedItems = await DBServise.loadHarajat();
      setState(() {
        items = loadedItems;
        _updateMonthlyExpense();
        _updateDailyFilteredItems();
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('error_loading_expenses'.tr())),
      );
    }
  }

  void _updateMonthlyExpense() {
    monthlyExpense = _filterCurrentMonthExpenses(items)
        .fold(0.0, (sum, item) => sum + (double.tryParse(item.price.toString()) ?? 0));
    _calculateBudgetMetrics();
  }

  void _updateDailyFilteredItems() {
    dailyFilteredItems = items
        .where((item) => item.sana?.startsWith(selectedDate!) ?? false)
        .toList();
    dailyExpense = dailyFilteredItems
        .fold(0.0, (sum, item) => sum + (double.tryParse(item.price.toString()) ?? 0));
  }

  void _calculateBudgetMetrics() {
    percentage = widget.monthlyBudget > 0
        ? (monthlyExpense / widget.monthlyBudget) * 100
        : 0.0;
    remainingBudget = widget.monthlyBudget - monthlyExpense;
  }

  void _oldingiOy() {
    setState(() {
      currentMonth = DateTime(currentMonth.year, currentMonth.month - 1);
      _updateMonthlyExpense();
    });
  }

  void _keyingiOy() {
    setState(() {
      currentMonth = DateTime(currentMonth.year, currentMonth.month + 1);
      _updateMonthlyExpense();
    });
  }

  List<HarajatModel> _filterCurrentMonthExpenses(List<HarajatModel> allItems) {
    final monthStr =
        "${currentMonth.year}-${currentMonth.month.toString().padLeft(2, '0')}";
    return allItems
        .where((item) => item.sana?.startsWith(monthStr) ?? false)
        .toList();
  }

  void _sananiTanlash(DateTime date) {
    setState(() {
      selectedDate = DateFormat('yyyy-MM-dd').format(date);
      _updateDailyFilteredItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor =
    widget.isDarkMode ? const Color(0xFF121212) : Colors.grey[100]!;
    final textColor = widget.isDarkMode ? Colors.white : Colors.black;
    final cardColor =
    widget.isDarkMode ? const Color(0xFF1F1F1F) : Colors.white;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
            child: Column(
              children: [
                FadeInDown(
                  child: _buildOylikBudgetCard(textColor, cardColor),
                ),
                const SizedBox(height: 12),
                HarajatlarSanasi(
                  onDateSelected: _sananiTanlash,
                  isDarkMode: widget.isDarkMode,
                ),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : (dailyFilteredItems.isEmpty
                ? _buildHarajatList(textColor)
                : HarajatList(
              filteredItems: dailyFilteredItems,
              cardColor: cardColor,
              textColor: textColor,
              buildExpenseCard: (harajat, cColor, tColor) =>
                  _buildExpenseCard(
                      harajat as HarajatModel, cColor, tColor),
            )),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green.shade600,
        elevation: 8,
        shape: const CircleBorder(),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => HarajatAdd(isDarkMode: widget.isDarkMode),
            ),
          );
          _loadHarajatlar();
        },
        child: const Icon(Icons.add, size: 28),
      ),
    );
  }

  Widget _buildOylikBudgetCard(Color textColor, Color cardColor) {
    final progressColor = percentage > 90
        ? Colors.redAccent
        : percentage > 70
        ? Colors.orangeAccent
        : accentColor;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)),
      color: cardColor,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              DateFormat('MMMM, yyyy', context.locale.toString())
                  .format(currentMonth),
              style: TextStyle(
                  color: textColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_left,
                      color: textColor, size: 30),
                  onPressed: _oldingiOy,
                ),
                Flexible(
                  child: FittedBox(
                    child: Text(
                      "${NumberFormat('#,##0', 'en_US').format(monthlyExpense)} so'm",
                      style: TextStyle(
                          color: textColor,
                          fontSize: 32,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.arrow_right,
                      color: textColor, size: 30),
                  onPressed: _keyingiOy,
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildBudgetInfoRow(textColor),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: percentage / 100 > 1.0
                    ? 1.0
                    : percentage / 100,
                backgroundColor: textColor.withOpacity(0.2),
                valueColor:
                AlwaysStoppedAnimation<Color>(progressColor),
                minHeight: 10,
              ),
            ),
            const SizedBox(height: 10),
            _buildRemainingBudgetText(textColor),
          ],
        ),
      ),
    );
  }

  Widget _buildBudgetInfoRow(Color textColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            IconButton(
              icon: Icon(Icons.edit,
                  color: accentColor, size: 20),
              onPressed: () => widget.onEditMonthlyBudget(context),
            ),
            Text(
              'monthly_budget'.tr(),
              style: TextStyle(
                  color: textColor, fontSize: 16),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          runSpacing: 8,
          spacing: 12,
          children: [
            Text(
              "${NumberFormat('#,##0', 'en_US').format(widget.monthlyBudget)} so'm",
              style: TextStyle(
                  color: textColor, fontSize: 16),
            ),
            Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: percentage > 100
                    ? Colors.redAccent.withOpacity(0.2)
                    : percentage > 80
                    ? Colors.orangeAccent.withOpacity(0.2)
                    : accentColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                "${percentage.toStringAsFixed(0)}%",
                style: TextStyle(
                  color: percentage > 100
                      ? Colors.redAccent
                      : percentage > 80
                      ? Colors.orangeAccent
                      : accentColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRemainingBudgetText(Color textColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'remaining_budget'.tr(),
          style:
          TextStyle(color: textColor, fontSize: 16),
        ),
        const SizedBox(width: 8),
        Text(
          "${NumberFormat('#,##0', 'en_US').format(remainingBudget)} so'm",
          style: TextStyle(
            color:
            remainingBudget < 0 ? Colors.redAccent : accentColor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildHarajatList(Color textColor) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.money_off,
            size: 64,
            color: textColor.withOpacity(0.4),
          ),
          const SizedBox(height: 16),
          Text(
            dailyFilteredItems.isEmpty && selectedDate != null
                ? 'no_expenses_selected_date'.tr()
                : 'no_expenses_found'.tr(),
            style: TextStyle(
              fontSize: 16,
              color: textColor.withOpacity(0.6),
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildExpenseCard(
      HarajatModel harajat, Color cardColor, Color textColor) {
    final price = double.tryParse(harajat.price.toString()) ?? 0;
    DateTime? sana;
    if (harajat.sana is String) {
      sana = DateTime.tryParse(harajat.sana as String);
    } else if (harajat.sana is DateTime) {
      sana = harajat.sana as DateTime;
    }

    return Card(
      elevation: 2,
      shape:
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: cardColor,
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
            horizontal: 20, vertical: 12),
        title: Text(
          harajat.malumot ?? 'unknown'.tr(),
          style: TextStyle(
            color: textColor,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          sana != null
              ? DateFormat('d MMM yyyy', context.locale.toString())
              .format(sana)
              : 'Noma\'lum sana',
          style: TextStyle(color: textColor.withOpacity(0.7)),
        ),
        trailing: Text(
          "${NumberFormat('#,##0', 'en_US').format(price)} so'm",
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
