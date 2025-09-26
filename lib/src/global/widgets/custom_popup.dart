import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CustomPopup extends StatelessWidget {
  final String title;
  final String message;
  final List<Widget> actions;
  final Widget child;

  const CustomPopup({
    super.key,
    required this.title,
    required this.message,
    required this.actions,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SizedBox(
        width: 100.w,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Text(message),
            // SizedBox(height: 16),
            Container(
              width: 308,
              // height: 270,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(21.0),
              ),
              child: Column(
                children: [
                  child,
                  Row(
                    mainAxisAlignment:actions.length>1? MainAxisAlignment.spaceAround:MainAxisAlignment.center,
                    children: actions,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
