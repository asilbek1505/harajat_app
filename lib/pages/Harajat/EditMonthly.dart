import 'package:flutter/material.dart';

class EditMonthly extends StatefulWidget {
  final double initialBudget;

  const EditMonthly({super.key, required this.initialBudget});

  @override
  State<EditMonthly> createState() =>
      _EditMonthlyState();
}

class _EditMonthlyState extends State<EditMonthly> {
  late TextEditingController _controller;

  @override
  void initState() {
    _controller =
        TextEditingController(text: widget.initialBudget.toStringAsFixed(0));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Byudjetni tahrirlash"),
      content: TextField(
        controller: _controller,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(labelText: "Oylik byudjet"),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Bekor qilish"),
        ),
        TextButton(
          onPressed: () {
            final amount = double.tryParse(_controller.text) ?? 0;
            Navigator.pop(context, amount);
          },
          child: const Text("Saqlash"),
        ),
      ],
    );
  }
}
