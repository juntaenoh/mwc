import 'package:flutter/material.dart';
import 'package:mwc/index.dart';

class dev extends StatelessWidget {
  const dev({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.Black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'This feature isn’t provided\nby beta version.',
              style: AppFont.b24w,
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Please wait for the service release!',
              style: AppFont.r16.overrides(color: AppColors.primaryBackground),
            ),
          ],
        ),
      ),
    );
  }
}
