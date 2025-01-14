import 'package:mwc/components/check_cancel_invite.dart';
import 'package:mwc/models/GroupData.dart';

import 'package:flutter/material.dart';

import 'package:mwc/index.dart';

class ChangeLeaderpop extends StatefulWidget {
  final Member member;
  const ChangeLeaderpop({Key? key, required this.member}) : super(key: key);

  @override
  _ChangeLeaderpopState createState() => _ChangeLeaderpopState();
}

class _ChangeLeaderpopState extends State<ChangeLeaderpop> {
  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  void showCustomSnackBar(BuildContext context, String type, String name) {
    final snackBar = SnackBar(
      backgroundColor: AppColors.primary,

      content: Text(
        (type == 'ok') ? name + SetLocalizations.of(context).getText('rmfqnekdlwjs') : name + SetLocalizations.of(context).getText('rjwjdehla'),
        style: AppFont.s12.overrides(
          color: AppColors.Black,
          fontSize: 16,
        ),
        textAlign: TextAlign.center,
      ),
      duration: Duration(seconds: 3), // Set the duration to 3 seconds
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28),
      ),
      behavior: SnackBarBehavior.floating,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 327,
      height: 432,
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
                    color: AppColors.primary,
                    size: 16,
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 8, 0, 20),
                    child: Text(
                      SetLocalizations.of(context).getText('rmfwnqkddlwjs'),
                      style: AppFont.s18.overrides(color: AppColors.primaryBackground),
                    ),
                  ),
                  Text(
                    widget.member.firstName +
                        widget.member.lastName +
                        '님에게' +
                        AppStateNotifier.instance.groupData!.first.groupName +
                        '그룹의 권한을 이전할까요?',
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
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 3, 0, 12),
                    child: Container(
                      width: double.infinity,
                      height: 56.0,
                      child: LodingButtonWidget(
                        onPressed: () async {
                          await GroupApi.updateGroupLeader(widget.member.uid).then((value) {
                            if (value) {
                              showCustomSnackBar(
                                context,
                                'ok',
                                widget.member.firstName + widget.member.lastName,
                              );
                            }

                            context.goNamed('home');
                          });
                        },
                        text: SetLocalizations.of(context).getText('rmfnqwk'),
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
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 56.0,
                    child: LodingButtonWidget(
                      onPressed: () async {
                        context.safePop();
                      },
                      text: SetLocalizations.of(context).getText('cnlth'),
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
                        borderRadius: BorderRadius.circular(12.0),
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
