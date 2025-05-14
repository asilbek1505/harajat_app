// lib/pages/Harajat/harajatList.dart

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

class HarajatList extends StatefulWidget {
  final List filteredItems;
  final Color cardColor;
  final Color textColor;
  final Widget Function(dynamic, Color, Color) buildExpenseCard;

  const HarajatList({
    super.key,
    required this.filteredItems,
    required this.cardColor,
    required this.textColor,
    required this.buildExpenseCard,
  });

  @override
  State<HarajatList> createState() => _HarajatListState();
}

class _HarajatListState extends State<HarajatList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.filteredItems.length,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemBuilder: (ctx, index) {
        return FadeInUp(
          delay: Duration(milliseconds: 100 * index),
          child: widget.buildExpenseCard(
            widget.filteredItems[index],
            widget.cardColor,
            widget.textColor,
          ),
        );
      },
    );
  }
}
