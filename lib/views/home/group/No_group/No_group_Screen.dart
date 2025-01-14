import 'package:flutter/material.dart';
import '../widgets/bubble_print.dart';

import 'package:mwc/index.dart';

class NogroupScreen extends StatefulWidget {
  const NogroupScreen({Key? key}) : super(key: key);
  @override
  _NogroupScreenState createState() => _NogroupScreenState();
}

class _NogroupScreenState extends State<NogroupScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.Black,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(24, 0, 24, 0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 42, 0, 83),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                          height: 120,
                          decoration: BoxDecoration(
                            color: AppColors.Gray850,
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                                  child: Text(
                                      SetLocalizations.of(context).getText(
                                        'ckadue1uteze' /* 그룹이 없네요! */,
                                      ),
                                      style: AppFont.s18.overrides(fontSize: 16, color: AppColors.primaryBackground)),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
                                  child: Text(
                                      SetLocalizations.of(context).getText(
                                        'ckadurmfnqteze' /* 를 공유할 수 있 */,
                                      ),
                                      style: AppFont.r16.overrides(fontSize: 12, color: AppColors.Gray300)),
                                ),
                              ],
                            ),
                          )),
                    )
                  ],
                ),
              ),
              CustomPaint(
                painter: BubblePainter(),
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20.0, 15, 20, 25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '그룹 기능을 사용하려면',
                          style: AppFont.s12.overrides(color: AppColors.Black),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                      child: InkWell(
                        onTap: () {
                          context.pushNamed('Creategroup');
                        },
                        child: Container(
                          height: 232,
                          decoration: ShapeDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xFFFCFDFF).withOpacity(0.20), // 시작 색상
                                Color(0xFFFCFDFF).withOpacity(0.04), // 끝 색상
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
                            padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '그룹 생성하기',
                                  style: AppFont.b24.overrides(color: AppColors.primaryBackground, fontSize: 20),
                                ),
                                SvgPicture.asset('assets/icons/user.svg',
                                    colorFilter: ColorFilter.mode(AppColors.primaryBackground, BlendMode.srcIn)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: InkWell(
                        onTap: () {
                          context.pushNamed('Joingroup');
                        },
                        child: Container(
                          height: 232,
                          decoration: ShapeDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xFFFCFDFF).withOpacity(0.20), // 시작 색상
                                Color(0xFFFCFDFF).withOpacity(0.04), // 끝 색상
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
                            padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '그룹 참여\n신청하기',
                                  style: AppFont.b24.overrides(color: AppColors.primaryBackground, fontSize: 20),
                                ),
                                SvgPicture.asset('assets/icons/invite.svg',
                                    colorFilter: ColorFilter.mode(AppColors.primaryBackground, BlendMode.srcIn)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
