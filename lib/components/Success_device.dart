import 'package:flutter/material.dart';
import '/index.dart';

class SuccessDevice extends StatefulWidget {
  final String name;
  final String mode;
  const SuccessDevice({Key? key, required this.name, required this.mode}) : super(key: key);

  @override
  State<SuccessDevice> createState() => _SuccessDeviceState();
}

class _SuccessDeviceState extends State<SuccessDevice> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 327,
      height: 366,
      decoration: BoxDecoration(
        color: AppColors.Gray850,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(12, 0, 12, 0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 77, 0, 0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle_outline_rounded,
                    color: AppColors.DarkenGreen,
                    size: 16,
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 8, 0, 20),
                    child: Text(
                      SetLocalizations.of(context).getText(
                        'popupCompleteAddDeviceLabel' /* Hello World */,
                      ),
                      style: AppFont.s18.overrides(color: AppColors.primaryBackground),
                    ),
                  ),
                  Text(
                    SetLocalizations.of(context).getText('popupCompleteAddDeviceDescription' /* Hello World */, values: {'name': widget.name}),
                    style: AppFont.r16.overrides(color: AppColors.Gray300),
                    textAlign: TextAlign.center,
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
                        if (widget.mode == 'main') {
                          context.goNamed('Footprint', extra: 'main');
                        } else if (widget.mode == 'tester') {
                          context.goNamed('testFootprint', extra: 'tester');
                        } else if (widget.mode == 'cali') {
                          context.goNamed('DeviceCalibration');
                        }
                      },
                      text: SetLocalizations.of(context).getText(
                        'popupCompleteAddDeviceButtonScanLabel' /*  */,
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
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: Container(
                      width: double.infinity,
                      height: 56.0,
                      child: LodingButtonWidget(
                        onPressed: () async {
                          context.goNamed('home');
                        },
                        text: SetLocalizations.of(context).getText(
                          'popupCompleteAddDeviceButtonConfirmLabel' /*  */,
                        ),
                        options: LodingButtonOptions(
                          height: 40.0,
                          padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                          iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                          color: Colors.transparent,
                          textStyle: AppFont.s18.overrides(fontSize: 16, color: AppColors.primaryBackground),
                          elevation: 0,
                          borderSide: BorderSide(
                            color: AppColors.primaryBackground,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
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
