import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';
import '/index.dart';

class YesDivice extends StatefulWidget {
  const YesDivice({Key? key}) : super(key: key);

  @override
  State<YesDivice> createState() => _YesDiviceState();
}

class _YesDiviceState extends State<YesDivice> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 327,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        gradient: LinearGradient(
          begin: Alignment.topCenter, // 그라데이션 시작 위치
          end: Alignment.bottomCenter, // 그라데이션 끝 위치
          colors: [
            AppColors.Gray700, AppColors.Gray850, // 아래쪽의 끝 색상
          ],
        ),
      ),
      child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 100,
                child: TextButton(
                    onPressed: () {
                      context.goNamed('Footprint', extra: 'main');
                    },
                    child: Text(
                      SetLocalizations.of(context).getText(
                        'scanPlantarPressureLabel' /*  */,
                      ),
                      style: AppFont.s12.overrides(fontSize: 16, color: AppColors.primaryBackground),
                      textAlign: TextAlign.center,
                    )),
              ),
              Padding(
                  padding: const EdgeInsets.fromLTRB(0, 18, 0, 16),
                  child: Dash(
                    direction: Axis.vertical,
                    length: 26, // 점선의 길이
                    dashLength: 2, // 각 점의 길이
                    dashColor: AppColors.primaryBackground, // 점선의 색상
                  )),
              Container(
                width: 100,
                child: TextButton(
                  onPressed: () {
                    context.goNamed('visionScan', extra: 'main');
                  },
                  child: Text(
                    SetLocalizations.of(context).getText(
                      'scanVisionLabel' /*  */,
                    ),
                    style: AppFont.s12.overrides(fontSize: 16, color: AppColors.primaryBackground),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            ],
          )),
    );
  }
}
