import 'package:flutter/material.dart';
import '/index.dart';

class AddSchedulePopup extends StatelessWidget {
  final VoidCallback onAddMySchedule;
  final VoidCallback onAddGroupSchedule;

  const AddSchedulePopup({
    Key? key,
    required this.onAddMySchedule,
    required this.onAddGroupSchedule,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        height: 96,
        width: 200,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: onAddMySchedule,
              child: Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  SetLocalizations.of(context).getText('wldjrkdcj'), // 내 일정 추가하기
                  style: AppFont.r16.overrides(color: AppColors.Black),
                ),
              ),
            ),
            Divider(height: 1, color: Colors.grey),
            InkWell(
              onTap: onAddGroupSchedule,
              child: Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  SetLocalizations.of(context).getText('dudgnsrmfjrmfpdy'), // 그룹 멤버 일정 추가하기
                  style: AppFont.r16.overrides(color: AppColors.Black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
