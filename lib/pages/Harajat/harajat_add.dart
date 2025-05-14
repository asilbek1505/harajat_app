import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:animate_do/animate_do.dart';

import '../../Model/harajat_model.dart';
import '../../servise/db_servsie.dart';

class HarajatAdd extends StatefulWidget {
  final bool isDarkMode;
  final HarajatModel? harajat; // Tahrirlash uchun

  const HarajatAdd({required this.isDarkMode, this.harajat, super.key});

  @override
  State<HarajatAdd> createState() => _HarajatAddState();
}

class _HarajatAddState extends State<HarajatAdd> {
  DateTime? _selectedDate;
  final _priceController = TextEditingController();
  final _malumotController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  String? _selectedCategory = 'Food';

  final List<String> _categories = ['Food', 'Transport', 'Entertainment', 'Other'];

  @override
  void initState() {
    super.initState();
    if (widget.harajat != null) {
      _priceController.text = widget.harajat!.price ?? '';
      _malumotController.text = widget.harajat!.malumot ?? '';
      _selectedDate = widget.harajat!.sana != null
          ? DateTime.tryParse(widget.harajat!.sana!) ?? DateTime.now()
          : DateTime.now();
    } else {
      _selectedDate = DateTime.now();
    }
  }

  @override
  void dispose() {
    _priceController.dispose();
    _malumotController.dispose();
    super.dispose();
  }

  Future<void> _saveExpense() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);
      try {
        HarajatModel harajat = HarajatModel(
          id: widget.harajat?.id ?? '',
          price: _priceController.text.replaceAll(' ', ''),
          malumot: _malumotController.text,
          sana: _selectedDate?.toIso8601String() ?? DateTime.now().toIso8601String(),
        );
        if (widget.harajat == null) {
          await DBServise.storeHarajat(harajat);
        } else {
          await DBServise.updateHarajat(harajat);
        }
        if (mounted) {
          Navigator.of(context).pop();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("error_occurred".tr(args: [e.toString()]))),
          );
        }
      } finally {
        if (mounted) {
          setState(() => isLoading = false);
        }
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

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: widget.isDarkMode ? Colors.orange : Colors.deepOrange,
              onPrimary: Colors.white,
              surface: widget.isDarkMode ? const Color(0xFF303030) : Colors.white,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: widget.isDarkMode ? Colors.orange : Colors.deepOrange,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && mounted) {
      setState(() => _selectedDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDarkMode;
    final backgroundColor = isDark ? const Color(0xFF121212) : Colors.white;
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;
    final accentColor = isDark ? Colors.tealAccent : Colors.deepOrange;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          widget.harajat == null ? "add_expense".tr() : "edit_expense".tr(),
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: accentColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [Colors.black, Colors.grey[900]!]
                : [Colors.blue[50]!, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: FadeIn(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
            children: [
              Center(
                child: Card(
                  color: cardColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 10,
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            widget.harajat == null
                                ? "add_expense".tr()
                                : "edit_expense".tr(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: accentColor,
                            ),
                          ),
                          const SizedBox(height: 20),
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
                              labelStyle:
                              TextStyle(color: textColor.withOpacity(0.7)),
                              prefixIcon:
                              Icon(Icons.attach_money, color: accentColor),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(color: accentColor),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide:
                                BorderSide(color: accentColor.withOpacity(0.5)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(color: accentColor, width: 2),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
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
                              labelStyle:
                              TextStyle(color: textColor.withOpacity(0.7)),
                              prefixIcon: Icon(Icons.edit_note, color: accentColor),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide:
                                BorderSide(color: accentColor.withOpacity(0.5)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(color: accentColor, width: 2),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _selectedDate == null
                                    ? "no_date".tr()
                                    : DateFormat('d MMM yyyy').format(_selectedDate!),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: accentColor,
                                ),
                              ),
                              ElevatedButton.icon(
                                onPressed: _selectDate,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: accentColor,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                icon: const Icon(Icons.calendar_today,
                                    color: Colors.white),
                                label: Text("select_date".tr(),
                                    style: const TextStyle(color: Colors.white)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              OutlinedButton(
                                onPressed: () => Navigator.of(context).pop(),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: accentColor,
                                  side: BorderSide(color: accentColor),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24, vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                child: Text("cancel".tr(),
                                    style: TextStyle(
                                        fontSize: 16, color: textColor)),
                              ),
                              ElevatedButton(
                                onPressed: isLoading ? null : _saveExpense,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: accentColor,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30, vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                child: isLoading
                                    ? const CircularProgressIndicator(
                                    color: Colors.white)
                                    : Text("submit".tr(),
                                    style: const TextStyle(
                                        fontSize: 16, color: Colors.white)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}