import 'package:flutter/material.dart';
import '/index.dart';

class NoDivice extends StatefulWidget {
  const NoDivice({Key? key}) : super(key: key);

  @override
  State<NoDivice> createState() => _NoDiviceState();
}

class _NoDiviceState extends State<NoDivice> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 327,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
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
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 8, 0, 20),
                    child: Text(
                      SetLocalizations.of(context).getText(
                        'scanNoDeviceLabel',
                      ),
                      style: AppFont.s18.overrides(color: AppColors.primaryBackground, fontSize: 16),
                    ),
                  ),
                  Text(
                    SetLocalizations.of(context).getText(
                      'scanNoDeviceDescription',
                    ),
                    style: AppFont.r16.overrides(color: AppColors.Gray300, fontSize: 12),
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 12),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: double.infinity,
                    height: 56.0,
                    child: LodingButtonWidget(
                      onPressed: () async {
                        Navigator.pop(context);
                        context.pushNamed('FindBlue', extra: 'main');
                        //context.goNamed('visionScan', extra: 'main');
                      },
                      text: SetLocalizations.of(context).getText(
                        'scanNoDeviceButtonConfirmLabel' /* 확인 */,
                      ),
                      options: LodingButtonOptions(
                        height: 40.0,
                        padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                        iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                        color: AppColors.primaryBackground,
                        textStyle: AppFont.s18.overrides(fontSize: 16, color: AppColors.Black),
                        elevation: 0,
                        borderSide: BorderSide(
                          color: Colors.transparent,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
