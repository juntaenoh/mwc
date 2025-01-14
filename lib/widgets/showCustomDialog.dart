import 'package:flutter/material.dart';
import 'package:aligned_dialog/aligned_dialog.dart';
import 'custom_dialog.dart';

Future<void> showCustomDialog({
  required String backGroundtype,
  required BuildContext context,
  required Color checkButtonColor,
  required String titleText,
  required String descriptionText,
  required String upperButtonText,
  required VoidCallback upperButtonFunction,
  String? lowerButtonText,
  VoidCallback? lowerButtonFunction,
  String? name,
}) async {
  await showAlignedDialog(
    context: context,
    isGlobal: true,
    avoidOverflow: false,
    targetAnchor: AlignmentDirectional(0, 0).resolve(Directionality.of(context)),
    followerAnchor: AlignmentDirectional(0, 0).resolve(Directionality.of(context)),
    builder: (dialogContext) {
      return Material(
        color: Colors.transparent,
        child: GestureDetector(
          child: CustomDialog(
            backGroundtype: backGroundtype,
            checkButtonColor: checkButtonColor,
            titleText: titleText,
            descriptionText: descriptionText,
            upperButtonText: upperButtonText,
            upperButtonFunction: upperButtonFunction,
            lowerButtonText: lowerButtonText,
            lowerButtonFunction: lowerButtonFunction,
            name: name,
          ),
        ),
      );
    },
  );
}
