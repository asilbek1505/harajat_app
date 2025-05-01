import 'package:flutter/material.dart';
import 'package:harajat_app/pages/harajat_add.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:easy_localization/easy_localization.dart';

import '../Model/harajat_model.dart';
import '../servise/db_servsie.dart';
import '../widgetlar/harajatlar_sanasi.dart';
import 'Carousel.dart';

class HarajatPage extends StatefulWidget {
  final PageController pageController;
  final bool isDarkMode;

  const HarajatPage({
    super.key,
    required this.pageController,
    required this.isDarkMode,
  });

  @override
  State<HarajatPage> createState() => _HarajatPageState();
}

class _HarajatPageState extends State<HarajatPage> {
  List<HarajatModel> items = [];
  List<HarajatModel> filteredItems = [];
  String? selectedDate;
  bool _isMounted = false;

  @override
  void initState() {
    super.initState();
    _isMounted = true;
    initializeDateFormatting('uz', null);
    _apiLoadHarajat();
  }

  @override
  void dispose() {
    _isMounted = false;
    super.dispose();
  }

  void _apiLoadHarajat() async {
    final value = await DBServise.loadHarajat();
    if (_isMounted) {
      setState(() {
        items = value;
        filteredItems = _filterTodayExpenses(value);
      });
    }
  }

  void _sananiTanlash(DateTime date) {
    setState(() {
      selectedDate =
      "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
      filteredItems = items.where((item) {
        return item.sana?.startsWith(selectedDate!) ?? false;
      }).toList();
    });
  }

  List<HarajatModel> _filterTodayExpenses(List<HarajatModel> allItems) {
    DateTime today = DateTime.now();
    String todayStr =
        "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";
    return allItems.where((item) {
      return item.sana?.startsWith(todayStr) ?? false;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor =
    widget.isDarkMode ? const Color(0xFF121212) : Colors.grey[100];
    final textColor = widget.isDarkMode ? Colors.white : Colors.black;
    final cardColor = widget.isDarkMode ? const Color(0xFF1F1F1F) : Colors.white;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ReklamaCarousel(),
            HarajatlarSanasi(
              onDateSelected: _sananiTanlash,
              isDarkMode: widget.isDarkMode,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: filteredItems.isEmpty
                  ? Center(
                child: Text(
                  "no_expenses_today".tr(), // Tarjimasi
                  style: TextStyle(
                    fontSize: 16,
                    color: textColor.withOpacity(0.6),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              )
                  : ListView.builder(
                itemCount: filteredItems.length,
                itemBuilder: (ctx, index) {
                  return _expenseCard(
                      filteredItems[index], cardColor, textColor);
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green.shade600,
        shape: const CircleBorder(),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => HarajatAdd(isDarkMode: widget.isDarkMode),
            ),
          );
        },
        child: const Icon(Icons.add, size: 28),
      ),
    );
  }

  Widget _expenseCard(HarajatModel harajat, Color cardColor, Color textColor) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color:
            widget.isDarkMode ? Colors.black26 : Colors.grey.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        title: Text(
          harajat.malumot ?? 'unknown'.tr(),
          style: TextStyle(
            color: textColor,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            harajat.sana != null
                ? "📅 ${DateFormat('d MMMM, yyyy', context.locale.languageCode).format(DateTime.parse(harajat.sana!))}"
                : '',
            style: TextStyle(
              color: textColor.withOpacity(0.6),
              fontSize: 14,
            ),
          ),
        ),
        trailing: Text(
          "${harajat.price ?? '0'} ${'sum'.tr()}",
          style: TextStyle(
            color: Colors.greenAccent[400],
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
