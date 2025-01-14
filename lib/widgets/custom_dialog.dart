import 'package:flutter/material.dart';
import 'package:mwc/index.dart';

class CustomDialog extends StatelessWidget {
  final String backGroundtype;

  final Color checkButtonColor;
  final String titleText;
  final String descriptionText;
  final String upperButtonText;
  final VoidCallback upperButtonFunction;
  final String? lowerButtonText;
  final VoidCallback? lowerButtonFunction;
  final String? name;

  const CustomDialog({
    Key? key,
    required this.backGroundtype,
    required this.checkButtonColor,
    required this.titleText,
    required this.descriptionText,
    required this.upperButtonText,
    required this.upperButtonFunction,
    this.lowerButtonText,
    this.lowerButtonFunction,
    this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color backGroundColor = backGroundtype == 'black' ? AppColors.Gray850 : AppColors.primaryBackground;
    final Color fontColor = backGroundtype == 'black' ? AppColors.primaryBackground : AppColors.Black;
    return Container(
      width: 327,
      height: lowerButtonText != null ? 432 : 366,
      decoration: BoxDecoration(
        color: backGroundColor,
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
                    color: checkButtonColor,
                    size: 16,
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 8, 0, 20),
                    child: Text(
                      titleText,
                      style: AppFont.s18.overrides(color: fontColor),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Text(
                    descriptionText,
                    style: AppFont.r16.overrides(color: AppColors.Gray300),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Column(
              children: [
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
                            upperButtonFunction();
                          },
                          text: upperButtonText,
                          options: LodingButtonOptions(
                            padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                            iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                            color: fontColor,
                            textStyle: AppFont.s18.overrides(fontSize: 16, color: backGroundColor),
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
                if (lowerButtonText != null || lowerButtonFunction != null)
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
                              lowerButtonFunction!();
                            },
                            text: lowerButtonText!,
                            options: LodingButtonOptions(
                              height: 40.0,
                              padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                              iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                              color: Colors.transparent,
                              textStyle: AppFont.s18.overrides(fontSize: 16, color: fontColor),
                              elevation: 0,
                              borderSide: BorderSide(
                                color: fontColor,
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
          ],
        ),
      ),
    );
  }
}
