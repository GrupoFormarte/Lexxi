import 'package:flutter/material.dart';
import 'package:lexxi/src/global/extensions/build_context_ext.dart';
import 'package:lexxi/src/global/utils/change_colors.dart';

Widget textExample(BuildContext context) {
  return Text(
    'Lorem Ipsum is simply\ndummy text of the printing and \ntypesetting industry. Lorem Ipsum\nhas been the industry’s standard \ndummy text ever since the 1500s\nwhen an unknown printer took a \ngalley of type and scrambled it to\nmake a type specimen book. \nIt has survived not only five \ncenturies, ',
    style: context.textTheme.titleMedium!.copyWith(fontSize: 20, color: blackToWhite(context)),
  );
}
