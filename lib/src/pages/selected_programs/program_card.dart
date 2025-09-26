// src/widgets/program_card.dart

import 'package:flutter/material.dart';
import 'package:lexxi/domain/item_dynamic/model/item.dart';
import 'package:lexxi/src/global/colors_custom.dart';

class ProgramCard extends StatelessWidget {
  final Item programa;
  final bool isSelected;
  final VoidCallback onTap;

  const ProgramCard({
    Key? key,
    required this.programa,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0), // Añade un poco de padding
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected
              ? ColorPalette.secondary
              : Colors.transparent, // Fondo transparente
          elevation: 0, // Sin sombra
          side: BorderSide(
            color: isSelected
                ? AppColors.blueDark
                : ColorPalette.secondary, // Borde azul claro
            width: 2, // Grosor del borde
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30), // Bordes redondeados
          ),
        ),
        onPressed: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
          child: Text(
            programa.value ?? '',
            style: TextStyle(
              color: isSelected ? AppColors.blueDark : Colors.white,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
