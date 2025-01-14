import 'package:mwc/components/check_cancel_invite.dart';
import 'package:mwc/models/GroupData.dart';

import 'package:flutter/material.dart';

import 'package:mwc/index.dart';
import 'package:http/http.dart';

class RemoveMembers extends StatefulWidget {
  final List<Member> selectedmember;

  const RemoveMembers({Key? key, required this.selectedmember}) : super(key: key);

  @override
  _RemoveMembersState createState() => _RemoveMembersState();
}

class _RemoveMembersState extends State<RemoveMembers> {
  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
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
                    color: AppColors.red,
                    size: 16,
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 8, 0, 20),
                    child: Text(
                      SetLocalizations.of(context).getText('doaqjqkdcnf'),
                      style: AppFont.s18.overrides(color: AppColors.primaryBackground),
                    ),
                  ),
                  if (widget.selectedmember.length == 1) ...[
                    Text(
                      ' \'${widget.selectedmember.first.firstName} ${widget.selectedmember.first.lastName}\' 님을 \'${AppStateNotifier.instance.groupData!.first.groupName}\' 에서\n 방출 하시겠습니까?\n그룹에서 방출하면 \'${widget.selectedmember.first.firstName} ${widget.selectedmember.first.lastName}\'님의 건강 관리를 도울 수 없습니다.',
                      style: AppFont.r16.overrides(color: AppColors.Gray300),
                      textAlign: TextAlign.center,
                    ),
                  ] else ...[
                    Text(
                      ' \'${widget.selectedmember.first.firstName} ${widget.selectedmember.first.lastName}\' 님외 ${widget.selectedmember.length}명을 \'${AppStateNotifier.instance.groupData!.first.groupName}\' 에서\n 방출 하시겠습니까?\n그룹에서 방출하면 \'${widget.selectedmember.first.firstName} ${widget.selectedmember.first.lastName}\'님의 건강 관리를 도울 수 없습니다.',
                      style: AppFont.r16.overrides(color: AppColors.Gray300),
                      textAlign: TextAlign.center,
                    ),
                  ]
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
                          for (var userId in widget.selectedmember) {
                            await GroupApi.KickGroup(userId.memberId);
                          }
                          context.goNamed('home');
                        },
                        text: SetLocalizations.of(context).getText('aoqqjwkdcnf'),
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
