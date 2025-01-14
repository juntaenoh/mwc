import 'package:flutter/material.dart';
import 'package:mwc/index.dart';
import 'package:mwc/utils/fisica_theme.dart';

class out extends StatelessWidget {
  const out({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.Black,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: GestureDetector(
            onTap: () {
              AppStateNotifier.instance.logout();
              context.replaceNamed('LandingScreen');
            },
            child: Container(
              height: 184,
              width: double.infinity,
              decoration: ShapeDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFFCFDFF).withOpacity(0.20),
                    Color(0xFFFCFDFF).withOpacity(0.04),
                  ],
                ),
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 0.50, color: Color(0x33FBFCFF)),
                  borderRadius: BorderRadius.circular(16),
                ),
                shadows: [
                  BoxShadow(
                    color: Color(0xB2121212),
                    blurRadius: 8,
                    offset: Offset(0, 0),
                    spreadRadius: 0,
                  )
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Log out',
                      style: AppFont.b24w,
                    ),
                    Text(
                      'Go back to the landing screen',
                      style: AppFont.r16.overrides(color: AppColors.Gray500, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
