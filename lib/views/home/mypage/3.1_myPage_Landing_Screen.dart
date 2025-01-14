import 'package:mwc/models/FootData.dart';
import 'package:mwc/models/GroupHistory.dart';
import 'package:mwc/models/UserData.dart';
import 'package:mwc/models/WeightData.dart';
import 'package:mwc/models/testuser.dart';
import 'package:mwc/utils/TypeManager.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:mwc/index.dart';
import 'package:provider/provider.dart';

class MyPageLanding extends StatefulWidget {
  const MyPageLanding({Key? key}) : super(key: key);

  @override
  _MyPageLandingState createState() => _MyPageLandingState();
}

class _MyPageLandingState extends State<MyPageLanding> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  TestUser? testuser;
  List<FootData>? foot;
  List<TestUserRecord>? testfoot;
  List<FootData> footdata = [];
  List<WeightData> weightdata = [];
  List<dynamic> historyData = [];

  late int agedata = 0;
  DateTime currentDate = DateTime.now(); // 현재 날짜 및 시간

  int calculateAge(dynamic birthDateString) {
    if (birthDateString == null) {
      return 0;
    } else {
      DateTime birthDate = DateTime.parse(birthDateString);
      DateTime currentDate = DateTime.now();
      int age = currentDate.year - birthDate.year;
      if (currentDate.month < birthDate.month || (currentDate.month == birthDate.month && currentDate.day < birthDate.day)) {
        age--;
      }
      return age;
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isiOS) {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarBrightness: Theme.of(context).brightness,
          systemStatusBarContrastEnforced: true,
        ),
      );
    }

    return Consumer<AppStateNotifier>(builder: (context, AppStateNotifier, child) {
      testuser = AppStateNotifier.testUser;
      testfoot = AppStateNotifier.testUser?.TestUserRecords ?? [];

      weightdata = AppStateNotifier.weightData ?? [];
      historyData = [...testfoot!, ...weightdata];

      return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          key: scaffoldKey,
          backgroundColor: AppColors.Gray850,
          appBar: AppBar(
            backgroundColor: AppColors.Gray850,
            automaticallyImplyLeading: false,
            title: Text(
              SetLocalizations.of(context).getText(
                'profileLabel' /* Page Title */,
              ),
              style: AppFont.s18.overrides(color: AppColors.primaryBackground),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: IconButton(
                  icon: Icon(
                    Icons.settings,
                    color: AppColors.primaryBackground,
                  ),
                  onPressed: () {
                    context.pushNamed(
                      'MySetting',
                    );
                  },
                ),
              )
            ],
            centerTitle: false,
            elevation: 0.0,
          ),
          body: SafeArea(
              top: true,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildUserInfo(context),
                          SizedBox(
                            height: 16,
                          ),
                          _buildBodyData(context)
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.Black,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0),
                        ),
                      ),
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(24, 12, 24, 12),
                          child: Column(
                            children: [
                              _buildHistroytitle(context),
                              _buildHistroy(context, AppStateNotifier),
                              //_buildPlantitle(context),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              )),
        ),
      );
    });
  }

  Widget _buildUserInfo(BuildContext context) {
    print(testuser?.gender);
    return Container(
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: ClipOval(
              child: Container(
                width: 60.0,
                height: 60.0,
                color: Colors.black,
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Text(
                    '${testuser?.firstName}  ${testuser?.lastName}',
                    style: AppFont.b24.overrides(color: AppColors.primaryBackground),
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            SetLocalizations.of(context).getText('profileage', values: {'age': '${calculateAge(testuser?.birthday)}'}) + ' | ',
                            style: AppFont.s12.overrides(color: AppColors.Gray300),
                          ),
                          Text(
                            (testuser?.gender == 'MALE')
                                ? SetLocalizations.of(context).getText('signupUserInfoButtonGenderMaleLabel')
                                : SetLocalizations.of(context).getText('signupUserInfoButtonGenderFemaleLabel'),
                            style: AppFont.s12.overrides(color: AppColors.Gray300),
                          ),
                        ],
                      ),
                      _buildButtons(context),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButtons(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Container(
            width: 112,
            height: 26.0,
            child: LodingButtonWidget(
              onPressed: () async {
                context.pushNamed('Modiinfo');
              },
              text: SetLocalizations.of(context).getText(
                'profileSettingLabel' /* 프로필 편집 */,
              ),
              options: LodingButtonOptions(
                padding: EdgeInsetsDirectional.fromSTEB(17.0, 0.0, 17.0, 0.0),
                iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                color: Colors.transparent,
                textStyle: AppFont.s18.overrides(fontSize: 16, color: AppColors.Gray300),
                elevation: 0,
                borderSide: BorderSide(
                  color: AppColors.Gray300,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(0, 4, 0, 0),
          child: Container(
            width: 112,
            height: 26.0,
            child: LodingButtonWidget(
              onPressed: () async {
                context.pushNamed('Myavata');
              },
              text: SetLocalizations.of(context).getText(
                'profileButtonAvatarLabel' /* 아바타 보기 */,
              ),
              options: LodingButtonOptions(
                padding: EdgeInsetsDirectional.fromSTEB(17.0, 0.0, 17.0, 0.0),
                iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                color: AppColors.primary,
                textStyle: AppFont.s18.overrides(fontSize: 16, color: AppColors.Black),
                elevation: 0,
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBodyData(BuildContext context) {
    return Container(
      height: 76,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppColors.Black,
      ),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                SetLocalizations.of(context).getText(
                  'profileHeightLabel',
                ),
                style: AppFont.s12.overrides(fontSize: 10, color: AppColors.Gray500),
              ),
              SizedBox(
                height: 2,
              ),
              Text(
                '${testuser?.height.toString()}cm',
                style: AppFont.s12.overrides(fontSize: 16, color: AppColors.primaryBackground),
              )
            ],
          ),
        ),
        Container(
          height: 44, // 높이 설정
          child: VerticalDivider(
            color: AppColors.Gray700, // 선의 색상을 설정합니다.
            thickness: 1, // 실제 선의 두께를 설정합니다.
          ),
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                SetLocalizations.of(context).getText(
                  'profileWeightLabel',
                ),
                style: AppFont.s12.overrides(fontSize: 10, color: AppColors.Gray500),
              ),
              SizedBox(
                height: 2,
              ),
              Text(
                testuser?.weight != null ? '${(testuser!.weight! * 2.20462).toStringAsFixed(2)}lbs' : 'na',
                style: AppFont.s12.overrides(fontSize: 16, color: AppColors.primaryBackground),
              )
            ],
          ),
        )
      ]),
    );
  }

  Widget _buildHistroytitle(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          SetLocalizations.of(context).getText('profileHistoryLabel'),
          style: AppFont.b24.overrides(fontSize: 20, color: AppColors.primaryBackground),
        ),
        AppIconButton(
          borderColor: Colors.transparent,
          borderRadius: 20.0,
          borderWidth: 1.0,
          buttonSize: 40.0,
          icon: Icon(
            Icons.chevron_right_rounded,
            color: AppColors.primaryBackground,
            size: 20.0,
          ),
          onPressed: () async {
            context.pushNamed('history');
          },
        ),
      ],
    );
  }

  Widget _buildHistroy(BuildContext context, AppStateNotifier AppStateNotifier) {
    return Container(
        height: 144,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: historyData.length,
          itemBuilder: (context, index) {
            final item = historyData[index];
            final TypeManager typeManager = TypeManager();
            if (item is TestUserRecord) {
              typeManager.setType(context, item.classType);
              print(item.classType);
            }
            return Row(
              children: [
                Container(
                  decoration: BoxDecoration(color: AppColors.Gray850, borderRadius: BorderRadius.all(Radius.circular(16))),
                  width: 144,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: item is WeightData
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    SetLocalizations.of(context).getText('historyPlantarPressureDetailWeightLabel'),
                                    style: AppFont.s12.overrides(color: AppColors.primary),
                                  ),
                                  Text(
                                    item.weight != null ? '${(item.weight * 2.20462).toStringAsFixed(2)} lbs' : 'na',
                                    style: AppFont.s18.overrides(color: AppColors.Gray100),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    FootData.timeElapsedSince(context, item.measuredTime),
                                    style: AppFont.r16.overrides(color: AppColors.Gray200, fontSize: 10),
                                  ),
                                ],
                              ),
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Footprint',
                                    style: AppFont.s12.overrides(color: AppColors.primary),
                                  ),
                                  Text(
                                    typeManager.type,
                                    style: AppFont.s18.overrides(color: AppColors.Gray100),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    FootData.timeElapsedSince(context, item.measuredTime),
                                    style: AppFont.r16.overrides(color: AppColors.Gray200, fontSize: 10),
                                  ),
                                ],
                              ),
                            ],
                          ),
                  ),
                ),
                SizedBox(
                  width: 16,
                )
              ],
            );
          },
        ));
  }

  Widget _buildPlantitle(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          SetLocalizations.of(context).getText('dmmldlfwjd'),
          style: AppFont.b24.overrides(fontSize: 20, color: AppColors.primaryBackground),
        ),
        AppIconButton(
          borderColor: Colors.transparent,
          borderRadius: 20.0,
          borderWidth: 1.0,
          buttonSize: 40.0,
          icon: Icon(
            Icons.chevron_right_rounded,
            color: AppColors.primaryBackground,
            size: 20.0,
          ),
          onPressed: () async {},
        ),
      ],
    );
  }
}
