import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class AddBudgetPage extends StatefulWidget {
  final bool isDarkMode;
  const AddBudgetPage({super.key, required this.isDarkMode});

  @override
  State<AddBudgetPage> createState() => _AddBudgetPageState();
}

class _AddBudgetPageState extends State<AddBudgetPage> {
  final TextEditingController _controller = TextEditingController();
  String currentMonth = DateFormat('yyyy-MM').format(DateTime.now());

  Future<void> saveBudget() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    int budget = int.tryParse(_controller.text) ?? 0;
    await FirebaseFirestore.instance
        .collection('budgets')
        .doc(userId)
        .set({currentMonth: budget}, SetOptions(merge: true));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final textColor = widget.isDarkMode ? Colors.white : Colors.black;
    return Scaffold(
      appBar: AppBar(title: Text('Add Monthly Budget', style: TextStyle(color: textColor))),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Enter budget for $currentMonth',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: saveBudget,
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
