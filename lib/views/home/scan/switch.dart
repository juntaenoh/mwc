import 'package:flutter/rendering.dart';
import 'package:loop_page_view/loop_page_view.dart';
import 'package:mwc/index.dart';
import 'package:mwc/models/FootData.dart';
import 'package:mwc/utils/service/Foot_Controller.dart';
import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';

class ToggleImageSwitch extends StatefulWidget {
  final dynamic footdata;
  final int selectedIndex;
  const ToggleImageSwitch({Key? key, required this.footdata, required this.selectedIndex}) : super(key: key);

  @override
  _ToggleImageSwitchState createState() => _ToggleImageSwitchState();
}

class _ToggleImageSwitchState extends State<ToggleImageSwitch> {
  late String gender;
  String image = '';
  List<List<String>> imageList = [];
  List<String> titleList = [];
  bool isLoading = true;

  bool main = true;

  final LoopPageController controller = LoopPageController(scrollMode: LoopScrollMode.shortest, activationMode: LoopActivationMode.immediate);
  int _currentIndex = 0;

  void nextPage() {
    final nextIndex = _currentIndex + 1;
    controller.animateToPage(
      nextIndex,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void previousPage() {
    final previousIndex = _currentIndex - 1;
    controller.animateToPage(
      previousIndex,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void initState() {
    super.initState();
    titleList = ['Back', 'Front', 'Left', 'Right'];
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setdata();
    });
  }

  void setdata() {
    try {
      if (widget.footdata == null) {
        print('스캔 데이터가 없습니다.');
        return;
      }

      setState(() {
        imageList = [
          [
            widget.footdata['combineFrontImageUrl'],
            widget.footdata['combineLeftImageUrl'],
            widget.footdata['combineRightImageUrl'],
            widget.footdata['combineBackImageUrl'],
          ],
          [
            widget.footdata['firstClassTypeFrontImageUrl'],
            widget.footdata['firstClassTypeLeftImageUrl'],
            widget.footdata['firstClassTypeRightImageUrl'],
            widget.footdata['firstClassTypeBackImageUrl'],
          ],
          [
            widget.footdata['secondClassTypeFrontImageUrl'],
            widget.footdata['secondClassTypeLeftImageUrl'],
            widget.footdata['secondClassTypeRightImageUrl'],
            widget.footdata['secondClassTypeBackImageUrl'],
          ],
          [
            widget.footdata['thirdClassTypeFrontImageUrl'],
            widget.footdata['thirdClassTypeLeftImageUrl'],
            widget.footdata['thirdClassTypeRightImageUrl'],
            widget.footdata['thirdClassTypeBackImageUrl'],
          ],
        ];

        isLoading = false; // 데이터 로드 완료
      });
    } catch (e) {
      print('데이터 설정 중 오류 발생: $e');
      setState(() {
        isLoading = false; // 에러 발생시에도 로딩 상태 해제
      });
    }
  }

  LoopScrollMode selectedScrollMode = LoopScrollMode.shortest;

  @override
  void dispose() {
    super.dispose();
    controller.dispose(); // 리소스 해제
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading || imageList.isEmpty) {
      return Center(
        child: Container(
          height: 460,
          child: Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),
        ),
      );
    }
    // final List<String> labels = [
    //   'Highlight',
    //   '1',
    //   '2',
    //   '3',
    // ];

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              left: 0,
              top: 0,
              child: Container(
                height: 32,
                width: 68,
                decoration: BoxDecoration(
                  color: AppColors.Gray100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(child: Text(titleList[(_currentIndex + 1) % 4], style: AppFont.s12.overrides(color: AppColors.Black))),
              ),
            ),

            Container(
              height: 460,
              child: LoopPageView.builder(
                controller: controller,
                itemCount: 4,
                itemBuilder: (_, index) {
                  return Image.network(
                    imageList[widget.selectedIndex][index],
                    fit: BoxFit.contain,
                  );
                },
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
              ),
            ),
            // 좌우 이동 버튼
            Positioned(
              left: 0,
              child: InkWell(
                onTap: previousPage,
                child: Row(
                  children: [
                    Icon(
                      Icons.arrow_back_ios,
                      color: AppColors.Gray700,
                    ),
                    Text(titleList[_currentIndex], style: AppFont.s12.overrides(color: AppColors.Black)),
                  ],
                ),
              ),
            ),
            Positioned(
              right: 0,
              child: InkWell(
                onTap: nextPage,
                child: Row(
                  children: [
                    Text(titleList[(_currentIndex + 2) % 4], style: AppFont.s12.overrides(color: AppColors.Black)),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: AppColors.Gray700,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        //Text(titleList[_currentIndex + 1].toString()),

        // Padding(
        //   padding: const EdgeInsets.only(top: 24.0),
        //   child: ToggleSwitch(
        //     minWidth: 147.0,
        //     minHeight: 36,
        //     initialLabelIndex: _currentIndex,
        //     cornerRadius: 20.0,
        //     activeFgColor: AppColors.primary,
        //     inactiveBgColor: AppColors.Gray200,
        //     inactiveFgColor: AppColors.Gray500,
        //     totalSwitches: totalSwitches,
        //     labels: labels,
        //     radiusStyle: true,
        //     activeBgColors: List.generate(totalSwitches, (_) => [AppColors.Black]),
        //     onToggle: (index) {
        //       setState(() {
        //         _currentIndex = index!;
        //         _pageController.animateToPage(
        //           _currentIndex,
        //           duration: Duration(milliseconds: 400),
        //           curve: Curves.easeInOut,
        //         );
        //       });
        //     },
        //   ),
        // ),
      ],
    );
  }
}
