import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:easy_localization/easy_localization.dart';

import '../Model/harajat_model.dart';
import '../servise/db_servsie.dart';

class HarajatAdd extends StatefulWidget {
  final bool isDarkMode;

  const HarajatAdd({required this.isDarkMode, super.key});

  @override
  State<HarajatAdd> createState() => _HarajatAddState();
}

class _HarajatAddState extends State<HarajatAdd> {
  DateTime? rejaUchunSana;
  final _priceController = TextEditingController();
  final _malumotController = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // FormState qo'shildi
  bool isLoading = false;

  @override
  void dispose() {
    _priceController.dispose();
    _malumotController.dispose();
    super.dispose();
  }

  Future<void> rejaQushish() async {
    if (_formKey.currentState!.validate()) { // Formni tekshirish
      setState(() => isLoading = true);
      try {
        await DBServise.storeHarajat(
          HarajatModel(
            price: _priceController.text,
            malumot: _malumotController.text,
            sana: rejaUchunSana?.toIso8601String() ?? "",
          ),
        );
        if (mounted) {
          Navigator.of(context).pop();
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("error_occurred".tr(args: [e.toString()]))),
        );
      } finally {
        setState(() => isLoading = false);
      }
    }
  }

  TextInputFormatter _priceFormatter() {
    return TextInputFormatter.withFunction((oldValue, newValue) {
      String digitsOnly = newValue.text.replaceAll(RegExp(r'\D'), '');
      if (digitsOnly.length > 7) digitsOnly = digitsOnly.substring(0, 7);
      String formatted = digitsOnly.replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
            (match) => '${match[1]} ',
      );
      return newValue.copyWith(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    });
  }

  void _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2035),
    );
    if (picked != null) {
      setState(() => rejaUchunSana = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDarkMode;
    final backgroundColor = isDark ? const Color(0xFF121212) : Colors.white;
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;
    final iconColor = isDark ? Colors.orangeAccent : Colors.deepOrange;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text("add_expense".tr(), style: TextStyle(color: textColor)),
        centerTitle: true,
        backgroundColor: backgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: iconColor),
      ),
      body: Stack(
        children: [
          if (!isDark)
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.white, Color(0xFFFFF3E0)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ListView(
            padding: const EdgeInsets.fromLTRB(20, 100, 20, 30),
            children: [
              Column(
                children: [
                  Card(
                    color: cardColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 8,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _priceController,
                              keyboardType: TextInputType.number,
                              style: TextStyle(color: textColor),
                              inputFormatters: [_priceFormatter()],
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "please_enter_price".tr();
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                labelText: "price_som".tr(),
                                labelStyle: TextStyle(color: textColor),
                                prefixIcon: Icon(Icons.attach_money, color: iconColor),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: iconColor),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: iconColor, width: 2),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _malumotController,
                              style: TextStyle(color: textColor),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "please_enter_note".tr();
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                labelText: "note".tr(),
                                labelStyle: TextStyle(color: textColor),
                                prefixIcon: Icon(Icons.edit_note_sharp, color: iconColor),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: iconColor),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: iconColor, width: 2),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  rejaUchunSana == null
                                      ? "no_date".tr()
                                      : DateFormat('d MMM yyyy').format(rejaUchunSana!),
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: iconColor),
                                ),
                                ElevatedButton.icon(
                                  onPressed: _selectDate,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.orange,
                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  ),
                                  icon: const Icon(Icons.date_range, color: Colors.white),
                                  label: Text("select_date".tr(), style: const TextStyle(color: Colors.white)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: iconColor,
                          side: BorderSide(color: iconColor),
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Text("cancel".tr(), style: const TextStyle(fontSize: 16)),
                      ),
                      ElevatedButton(
                        onPressed: isLoading ? null : rejaQushish,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepOrange,
                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : Text("submit".tr(), style: const TextStyle(fontSize: 16, color: Colors.white)),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
