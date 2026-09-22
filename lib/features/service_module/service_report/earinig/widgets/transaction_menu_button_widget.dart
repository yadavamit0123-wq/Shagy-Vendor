import 'package:flutter/material.dart';
import 'package:sixam_mart_store/util/dimensions.dart';

class TransactionsMenuButton extends StatelessWidget {
  final String label;
  final int count;
  final bool isSelected;
  final VoidCallback onTap;

  const TransactionsMenuButton({
    super.key,
    required this.label,
    required this.count,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return const SizedBox();
  }
}
