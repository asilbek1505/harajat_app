import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../Model/harajat_model.dart';
import '../servise/db_servsie.dart';
import 'Oylik_Hisobot.dart';

class HisobotlarPage extends StatefulWidget {
  final bool isDarkMode;

  const HisobotlarPage({super.key, required this.isDarkMode});

  @override
  State<HisobotlarPage> createState() => _HisobotlarPageState();
}

class _HisobotlarPageState extends State<HisobotlarPage> {
  Map<String, int> monthlyTotals = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHarajatlar();
  }

  Future<void> _loadHarajatlar() async {
    List<HarajatModel> harajatlar = await DBServise.loadHarajat();
    Map<String, int> tempTotals = {};

    for (var item in harajatlar) {
      if (item.sana != null && item.price != null) {
        try {
          DateTime sana = DateTime.parse(item.sana!);  // Sana formatini tekshiramiz
          String oyKey = DateFormat("yyyy-MM").format(sana);

          String priceStr = item.price!.replaceAll(" ", "");
          int price = int.tryParse(priceStr) ?? 0;

          tempTotals.update(oyKey, (value) => value + price, ifAbsent: () => price);
        } catch (e) {
          print('Xato: sana format noto\'g\'ri: ${item.sana}');
        }
      }
    }

    setState(() {
      monthlyTotals = tempTotals;
      isLoading = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    final backgroundColor = widget.isDarkMode ? const Color(0xFF121212) : Colors.white;
    final cardColor = widget.isDarkMode ? const Color(0xFF1F1F1F) : Colors.white;
    final textColor = widget.isDarkMode ? Colors.white : Colors.black;

    List<String> sortedKeys = monthlyTotals.keys.toList()..sort();

    return Scaffold(
      backgroundColor: backgroundColor,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: sortedKeys.length,
        itemBuilder: (context, index) {
          String oy = sortedKeys[index];
          int summa = monthlyTotals[oy]!;
          DateTime parsedDate = DateFormat("yyyy-MM").parse(oy);
          String oyNomi = DateFormat("MMMM yyyy", "uz_UZ").format(parsedDate);

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => OyHisobotiPage(
                    oy: oy,
                    title: oyNomi, isDarkMode: widget.isDarkMode,

                  ),
                ),
              );
            },
            child: Card(
              color: cardColor,
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
              child: ListTile(
                leading: Icon(Icons.calendar_today, color: widget.isDarkMode ? Colors.orangeAccent : Colors.deepOrange),
                title: Text(
                  oyNomi,
                  style: TextStyle(color: textColor),
                ),
                trailing: Text(
                  "${NumberFormat.decimalPattern('uz').format(summa)} so‘m",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: widget.isDarkMode ? Colors.greenAccent : Colors.green[700],
                  ),
                ),

              ),
            ),
          );
        },
      ),
    );
  }
}
