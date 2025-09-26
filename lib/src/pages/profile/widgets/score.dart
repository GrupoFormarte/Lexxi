import 'package:flutter/material.dart';
import 'package:lexxi/src/global/utils/change_colors.dart';
import 'package:sizer/sizer.dart';

class Score extends StatelessWidget {
  const Score({super.key, required this.score, required this.title});

  final String score;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          constraints: BoxConstraints(minWidth: 25.w),
          decoration: BoxDecoration(
            // color: const Color(0xffffffff),
            borderRadius: BorderRadius.circular(23.0),
            gradient: whiteToGradienGreen(context)
          ),
          child:  Center(
            child: Text(
              score,
              style: const TextStyle(
                fontFamily: 'Open Sans',
                fontSize: 16,
                color: Color(0xff2c314a),
                fontWeight: FontWeight.w800,
              ),
              softWrap: false,
            ),
          ),
        ),

          Padding(
           padding: const EdgeInsets.all(8.0),
           child: Text(
             title,
             style:  TextStyle(
               fontFamily: 'Open Sans',
               fontSize: 17,
               color: blackToWhite(context),
               fontWeight: FontWeight.w700,
             ),
             softWrap: false,
           ),
         )
      ],
    );
  }
}
