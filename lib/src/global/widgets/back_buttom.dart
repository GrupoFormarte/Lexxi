import 'package:flutter/material.dart';
import 'package:lexxi/src/global/colors_custom.dart';

class BackButtom extends StatelessWidget {
  const BackButtom({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: const CircleAvatar(
          backgroundColor: AppColors.grey,
          child: Icon(
            Icons.arrow_back,
            color: AppColors.blueDark,
          ),
        ));
  }
}
