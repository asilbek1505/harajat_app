import 'dart:ui';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:easy_localization/easy_localization.dart';

import '../Model/harajat_model.dart';
import '../servise/db_servsie.dart';

class OyHisobotiPage extends StatefulWidget {
  final String oy;
  final String title;
  final bool isDarkMode;

  const OyHisobotiPage({
    super.key,
    required this.oy,
    required this.title,
    required this.isDarkMode, // default false
  });

  @override
  State<OyHisobotiPage> createState() => _OyHisobotiPageState();
}

class _OyHisobotiPageState extends State<OyHisobotiPage> {
  List<HarajatModel> oyHarajatlar = [];
  bool isLoading = true;
  List<FlSpot> lineChartData = [];
  double maxY = 0;

  @override
  void initState() {
    super.initState();
    _loadOyHarajatlar();
  }

  Future<void> _loadOyHarajatlar() async {
    List<HarajatModel> all = await DBServise.loadHarajat();
    List<HarajatModel> filtered = all.where((item) {
      return item.sana.startsWith(widget.oy) ;
    }).toList();

    Map<int, int> kunlik = {};
    for (var item in filtered) {
      DateTime sana = DateTime.parse(item.sana);
      int kun = sana.day;
      int price = int.tryParse(item.price.replaceAll(" ", "")) ?? 0;
      kunlik.update(kun, (v) => v + price, ifAbsent: () => price);
        }

    List<int> kunlar = kunlik.keys.toList()..sort();

    List<FlSpot> spots = kunlar.map((kun) {
      double value = kunlik[kun]!.toDouble();
      if (value > maxY) maxY = value;
      return FlSpot(kun.toDouble(), value);
    }).toList();

    setState(() {
      oyHarajatlar = filtered;
      lineChartData = spots;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = widget.isDarkMode ? const Color(0xFF121212) : Colors.grey.shade100;
    final cardColor = widget.isDarkMode ? const Color(0xFF1F1F1F) : Colors.white;
    final textColor = widget.isDarkMode ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text("monthly_report".tr(), style: TextStyle(color: textColor)), // Translate title
        backgroundColor: widget.isDarkMode ? Colors.black : Colors.white,
        iconTheme: IconThemeData(color: textColor),
        centerTitle: true,
        elevation: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
              color: cardColor,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "daily_expenses_chart".tr(), // Translate label
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: textColor),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(height: 220, child: dialogOylik()),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Icon(Icons.list_alt, color: widget.isDarkMode ? Colors.orangeAccent : Colors.orange),
                const SizedBox(width: 8),
                Text(
                  "daily_expenses_list".tr(), // Translate label
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: ListView.builder(
                itemCount: oyHarajatlar.length,
                itemBuilder: (_, i) {
                  var h = oyHarajatlar[i];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    color: cardColor,
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                    child: ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: Colors.green,
                        child: Icon(Icons.attach_money, color: Colors.white),
                      ),
                      title: Text(
                        h.malumot ?? 'expense'.tr(), // Translate expense text
                        style: TextStyle(fontWeight: FontWeight.w600, color: textColor),
                      ),
                      subtitle: Text(
                        h.sana != null
                            ? DateFormat("d MMMM", "uz")
                            .format(DateTime.parse(h.sana))
                            : '',
                        style: TextStyle(color: textColor.withOpacity(0.6)),
                      ),
                      trailing: Text(
                        "${h.price} so‘m",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
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
    );
  }

  Widget dialogOylik() {
    return LineChart(
      LineChartData(
        maxY: maxY + 10000,
        minY: 0,
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: (value, _) {
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    value.toInt().toString(),
                    style: TextStyle(
                      fontSize: 10,
                      color: widget.isDarkMode ? Colors.white70 : Colors.black87,
                    ),
                  ),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, _) {
                return Text(
                  value.toInt().toString(),
                  style: TextStyle(
                    fontSize: 10,
                    color: widget.isDarkMode ? Colors.white70 : Colors.black87,
                  ),
                );
              },
            ),
          ),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (value) {
            return FlLine(color: Colors.grey, strokeWidth: 0.5);
          },
        ),
        lineBarsData: [
          LineChartBarData(
            spots: lineChartData,
            isCurved: true,
            color: Colors.blue,
            barWidth: 4,
            belowBarData: BarAreaData(show: false),
          ),
        ],
      ),
    );
  }
}
