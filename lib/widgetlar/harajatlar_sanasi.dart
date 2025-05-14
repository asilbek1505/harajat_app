import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HarajatlarSanasi extends StatefulWidget {
  final Function(DateTime) onDateSelected;
  final bool isDarkMode;

  const HarajatlarSanasi({
    super.key,
    required this.onDateSelected,
    required this.isDarkMode,
  });

  @override
  State<HarajatlarSanasi> createState() => _HarajatlarSanasiState();
}

class _HarajatlarSanasiState extends State<HarajatlarSanasi> {
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final Color bgColor = widget.isDarkMode ? const Color(0xFF2C2C2C) : Colors.white;
    final Color textColor = widget.isDarkMode ? Colors.white : Colors.black;
    final Color borderColor = widget.isDarkMode ? Colors.tealAccent : Colors.blue;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: InkWell(
        onTap: _pickDate,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor.withOpacity(0.6), width: 1.2),
            boxShadow: [
              BoxShadow(
                color: widget.isDarkMode
                    ? Colors.black.withOpacity(0.3)
                    : Colors.grey.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.calendar_today, size: 22, color: Colors.orange),
              const SizedBox(width: 12),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "${DateFormat.EEEE('uz').format(selectedDate)}, ",
                      style: TextStyle(
                        color: textColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextSpan(
                      text: DateFormat('d MMMM', 'uz').format(selectedDate),
                      style: TextStyle(
                        color: textColor.withOpacity(0.85),
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: widget.isDarkMode ? Colors.orange : Colors.blue,
              onPrimary: Colors.white,
              surface: widget.isDarkMode ? Colors.grey[900]! : Colors.white,
              onSurface: widget.isDarkMode ? Colors.white : Colors.black,
            ),
            dialogBackgroundColor: widget.isDarkMode ? Colors.grey[850] : Colors.white,
          ),
          child: child!,
        );
      },
    );

    if (date != null) {
      setState(() {
        selectedDate = date;
      });
      widget.onDateSelected(date);
    }
  }
}
