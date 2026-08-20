import 'package:flutter/material.dart';
import 'package:lexxi/src/global/design_system/typography.dart';

class SelectableChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const SelectableChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        decoration: BoxDecoration(
          color: selected
              ? Colors.white
              : Colors.white.withOpacity(0.12),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? Colors.white : Colors.white.withOpacity(0.3),
            width: 1.4,
          ),
        ),
        child: Text(
          label,
          style: AppTypography.button.copyWith(
            color: selected ? const Color(0xFF151F6D) : Colors.white,
          ),
        ),
      ),
    );
  }
}