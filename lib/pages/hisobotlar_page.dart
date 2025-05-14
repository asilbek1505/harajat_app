import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:harajat_app/widgetlar/Carousel.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';

import '../Model/harajat_model.dart';
import '../servise/db_servsie.dart';
import 'Oylik_Hisobot.dart';

class HisobotlarPage extends StatefulWidget {
  final bool isDarkMode;
  final Function(BuildContext) onEditMonthlyBudget; // Callback qo'shiladi

  const HisobotlarPage({
    super.key,
    required this.isDarkMode,
    required this.onEditMonthlyBudget,
  });

  @override
  State<HisobotlarPage> createState() => _HisobotlarPageState();
}

class _HisobotlarPageState extends State<HisobotlarPage> {
  Map<String, int> monthlyTotals = {};
  Map<String, int> monthlyBudgets = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _loadData() async {
    await _loadBudgets();
    await _loadHarajatlar();
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _loadBudgets() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();

    Map<String, int> budgets = {};
    for (String key in keys) {
      if (key.startsWith("budget_")) {
        final value = prefs.getInt(key) ?? 0;
        final oyKey = key.replaceFirst("budget_", "");
        budgets[oyKey] = value;
      }
    }
    if (mounted) {
      setState(() {
        monthlyBudgets = budgets;
      });
    }
  }

  Future<void> _saveBudget(String monthKey, int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt("budget_$monthKey", value);
    if (mounted) {
      setState(() {
        monthlyBudgets[monthKey] = value;
      });
    }
  }

  Future<void> _loadHarajatlar() async {
    List<HarajatModel> harajatlar = await DBServise.loadHarajat();
    Map<String, int> tempTotals = {};

    for (var item in harajatlar) {
      if (item.sana != null && item.price != null) {
        try {
          DateTime sana = DateTime.parse(item.sana!);
          String oyKey = DateFormat("yyyy-MM").format(sana);

          String priceStr = item.price! as String;
          int price = int.tryParse(priceStr) ?? 0;

          tempTotals.update(oyKey, (value) => value + price, ifAbsent: () => price);
        } catch (e) {
          print('Xato: sana format noto\'g\'ri: ${item.sana}');
        }
      }
    }
    if (mounted) {
      setState(() {
        monthlyTotals = tempTotals;
      });
    }
  }

  void _showSetBudgetDialog(String oyKey) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: widget.isDarkMode ? const Color(0xFF1F1F1F) : Colors.white,
        title: Text(
          "Oylik limitni kiriting",
          style: TextStyle(color: widget.isDarkMode ? Colors.white : Colors.black),
        ),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          style: TextStyle(color: widget.isDarkMode ? Colors.white : Colors.black),
          decoration: InputDecoration(
            hintText: "Masalan: 1000000",
            hintStyle: TextStyle(color: widget.isDarkMode ? Colors.grey : Colors.grey),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        actions: [
          TextButton(
            child: Text(
              "Bekor qilish",
              style: TextStyle(color: widget.isDarkMode ? Colors.redAccent : Colors.red),
            ),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text(
              "Saqlash",
              style: TextStyle(color: widget.isDarkMode ? Colors.greenAccent : Colors.green),
            ),
            onPressed: () {
              final entered = int.tryParse(controller.text.replaceAll(" ", ""));
              if (entered != null) {
                _saveBudget(oyKey, entered);
              }
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void _editMonthlyBudget() {
    widget.onEditMonthlyBudget(context); // Callback orqali chaqirish
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = widget.isDarkMode ? const Color(0xFF121212) : Colors.grey[100];
    final cardColor = widget.isDarkMode ? const Color(0xFF1F1F1F) : Colors.white;
    final textColor = widget.isDarkMode ? Colors.white : Colors.black;
    final accentColor = widget.isDarkMode ? Colors.tealAccent : const Color(0xFFFF5722);

    List<String> sortedKeys = monthlyTotals.keys.toList()..sort();

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: widget.isDarkMode
                ? [Colors.black, Colors.grey[900]!]
                : [Colors.blue[50]!, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            ReklamaCarousel(),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
                child: ListView.builder(
                  itemCount: sortedKeys.length,
                  itemBuilder: (context, index) {
                    String oy = sortedKeys[index];
                    int total = monthlyTotals[oy] ?? 0;
                    int budget = monthlyBudgets[oy] ?? 0;
                    int qolgan = budget - total;
                    DateTime parsedDate = DateFormat("yyyy-MM").parse(oy);
                    String oyNomi = DateFormat("MMMM yyyy", "uz_UZ").format(parsedDate);

                    return FadeInUp(
                      delay: Duration(milliseconds: index * 100),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => OyHisobotiPage(
                                oy: oy,
                                title: oyNomi,
                                isDarkMode: widget.isDarkMode,
                                onEditMonthlyBudget: widget.onEditMonthlyBudget,
                              ),
                            ),
                          );
                        },
                        onLongPress: () => _showSetBudgetDialog(oy),
                        child: Card(
                          color: cardColor,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          elevation: 4,
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.green.shade100,
                              child: Icon(Icons.calendar_today, color: Colors.green),
                            ),
                            title: Text(
                              oyNomi,
                              style: TextStyle(color: textColor, fontWeight: FontWeight.w600),
                            ),
                            subtitle: budget > 0
                                ? Text(
                              "Limit: ${NumberFormat.decimalPattern('uz').format(budget)} so‘m\nQolgan: ${NumberFormat.decimalPattern('uz').format(qolgan)} so‘m",
                              style: TextStyle(
                                color: qolgan < 0 ? Colors.red : textColor.withOpacity(0.6),
                                fontWeight: FontWeight.w500,
                              ),
                            )
                                : Text(
                              "Limit o‘rnatilmagan",
                              style: TextStyle(color: textColor.withOpacity(0.6)),
                            ),
                            trailing: Text(
                              "${NumberFormat.decimalPattern('uz').format(total)} so‘m",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: accentColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}