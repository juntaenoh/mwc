import 'package:flutter/widgets.dart';
import 'package:mwc/index.dart';
import 'package:flutter/material.dart';
import 'package:mwc/models/FootData.dart';
import 'package:mwc/models/UserData.dart';
import 'package:mwc/models/WeightData.dart';
import 'package:mwc/utils/service/webrtc/service/webrtc_controller.dart';
import 'package:mwc/views/webrtc/role_selection_view.dart';
import 'package:provider/provider.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({Key? key}) : super(key: key);

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  late AppStateNotifier appState;
  final TextEditingController _urlController = TextEditingController(); // URL을 관리하는 컨트롤러
  final TextEditingController _serverController = TextEditingController(); // URL을 관리하는 컨트롤러

  String savedUrl = ''; // 완료된 URL을 저장하는 변수
  String currentInput = ''; // 임시로 입력 중인 URL을 저장하는 변수
  String servsavedUrl = ''; // 완료된 URL을 저장하는 변수
  String servcurrentInput = ''; // 임시로 입력 중인 URL을 저장하는 변수
  String defaultUrl = '15.165.125.100:8085';
  String serdefaultUrl = 'webrtc.carencoinc.com:9000';
  bool _expertAvailable = true;
  bool _clientAvailable = true;
  @override
  void initState() {
    super.initState();
    appState = AppStateNotifier.instance;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        await appState.initController();
        appState.userListNotifier.addListener(_updateRoleAvailability);
      } catch (e) {
        print('Error during initController: $e');
      }
    });
  }

  @override
  void dispose() {
    appState.userListNotifier.removeListener(_updateRoleAvailability);
    super.dispose();
  }

  final scaffoldKey = GlobalKey<ScaffoldState>();

  List<WeightData> weightDataList = [
    WeightData(
      weightId: 'W001',
      measuredDate: DateTime(2024, 10, 1),
      measuredTime: DateTime(2024, 10, 1, 14, 30),
      weight: 70.5,
      weightChange: -0.5,
      weightType: 'Normal',
    ),
    WeightData(
      weightId: 'W002',
      measuredDate: DateTime(2024, 9, 28),
      measuredTime: DateTime(2024, 9, 28, 16, 45),
      weight: 68.0,
      weightChange: 1.0,
      weightType: 'Gain',
    ),
    WeightData(
      weightId: 'W003',
      measuredDate: DateTime(2024, 8, 15),
      measuredTime: DateTime(2024, 8, 15, 10, 0),
      weight: 80.0,
      weightChange: -2.0,
      weightType: 'Loss',
    ),
    WeightData(
      weightId: 'W004',
      measuredDate: DateTime(2024, 7, 10),
      measuredTime: DateTime(2024, 7, 10, 9, 30),
      weight: 75.4,
      weightChange: 0.0,
      weightType: 'Stable',
    ),
    WeightData(
      weightId: 'W005',
      measuredDate: DateTime(2024, 6, 5),
      measuredTime: DateTime(2024, 6, 5, 13, 15),
      weight: 72.3,
      weightChange: -1.5,
      weightType: 'Loss',
    ),
    WeightData(
      weightId: 'W006',
      measuredDate: DateTime(2024, 5, 1),
      measuredTime: DateTime(2024, 5, 1, 11, 0),
      weight: 69.0,
      weightChange: -0.3,
      weightType: 'Normal',
    ),
    WeightData(
      weightId: 'W007',
      measuredDate: DateTime(2024, 4, 15),
      measuredTime: DateTime(2024, 4, 15, 9, 30),
      weight: 67.8,
      weightChange: 0.2,
      weightType: 'Gain',
    ),
    WeightData(
      weightId: 'W008',
      measuredDate: DateTime(2024, 3, 28),
      measuredTime: DateTime(2024, 3, 28, 14, 15),
      weight: 78.2,
      weightChange: -1.0,
      weightType: 'Loss',
    ),
    WeightData(
      weightId: 'W009',
      measuredDate: DateTime(2024, 2, 5),
      measuredTime: DateTime(2024, 2, 5, 8, 0),
      weight: 73.9,
      weightChange: 0.4,
      weightType: 'Gain',
    ),
    WeightData(
      weightId: 'W010',
      measuredDate: DateTime(2024, 1, 20),
      measuredTime: DateTime(2024, 1, 20, 12, 0),
      weight: 76.3,
      weightChange: 0.0,
      weightType: 'Stable',
    ),
    WeightData(
      weightId: 'W011',
      measuredDate: DateTime(2023, 12, 15),
      measuredTime: DateTime(2023, 12, 15, 10, 30),
      weight: 74.5,
      weightChange: -0.7,
      weightType: 'Loss',
    ),
    WeightData(
      weightId: 'W012',
      measuredDate: DateTime(2023, 11, 1),
      measuredTime: DateTime(2023, 11, 1, 16, 0),
      weight: 71.8,
      weightChange: 0.1,
      weightType: 'Normal',
    ),
    WeightData(
      weightId: 'W013',
      measuredDate: DateTime(2023, 10, 10),
      measuredTime: DateTime(2023, 10, 10, 14, 45),
      weight: 79.1,
      weightChange: -1.2,
      weightType: 'Loss',
    ),
    WeightData(
      weightId: 'W014',
      measuredDate: DateTime(2023, 9, 5),
      measuredTime: DateTime(2023, 9, 5, 9, 30),
      weight: 66.5,
      weightChange: 0.5,
      weightType: 'Gain',
    ),
    WeightData(
      weightId: 'W015',
      measuredDate: DateTime(2023, 8, 20),
      measuredTime: DateTime(2023, 8, 20, 10, 15),
      weight: 68.9,
      weightChange: -0.3,
      weightType: 'Normal',
    ),
  ];

  void _updateRoleAvailability() {
    bool expertExists = false;
    bool clientExists = false;

    for (var user in appState.userListNotifier.value) {
      if (user['role'] == 'expert') {
        expertExists = true;
      } else if (user['role'] == 'client') {
        clientExists = true;
      }
    }

    setState(() {
      _expertAvailable = !expertExists;
      _clientAvailable = !clientExists;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateNotifier>(
      builder: (context, AppStateNotifier, child) {
        return Scaffold(
          key: scaffoldKey,
          backgroundColor: AppColors.Black,
          appBar: AppBar(
            backgroundColor: AppColors.Black,
          ),
          body: SafeArea(
              child: Container(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        'assets/images/Fisica.png',
                        color: AppColors.primaryBackground,
                        width: 128,
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        'Demo version',
                        style: AppFont.r16.overrides(color: AppColors.primaryBackground),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          appState.updatetesturl(defaultUrl);
                          context.pushNamed(
                            'Test_guide',
                          );
                        },
                        child: Container(
                          height: 184,
                          width: double.infinity,
                          decoration: ShapeDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xFFFCFDFF).withOpacity(0.20),
                                Color(0xFFFCFDFF).withOpacity(0.04),
                              ],
                            ),
                            shape: RoundedRectangleBorder(
                              side: BorderSide(width: 0.50, color: Color(0x33FBFCFF)),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            shadows: [
                              BoxShadow(
                                color: Color(0xB2121212),
                                blurRadius: 8,
                                offset: Offset(0, 0),
                                spreadRadius: 0,
                              )
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Scan',
                                  style: AppFont.b24w,
                                ),
                                Text(
                                  'for measurement & Report',
                                  style: AppFont.r16.overrides(color: AppColors.Gray500, fontSize: 12),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          if (_expertAvailable)
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  appState.updatetesturl(defaultUrl);
                                  AppStateNotifier.updateClientState(false);
                                  appState.setRole("expert");
                                  context.pushNamed(
                                    'home',
                                  );
                                },
                                child: Container(
                                  height: 184,
                                  decoration: ShapeDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Color(0xFFFCFDFF).withOpacity(0.20),
                                        Color(0xFFFCFDFF).withOpacity(0.04),
                                      ],
                                    ),
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(width: 0.50, color: Color(0x33FBFCFF)),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    shadows: [
                                      BoxShadow(
                                        color: Color(0xB2121212),
                                        blurRadius: 8,
                                        offset: Offset(0, 0),
                                        spreadRadius: 0,
                                      )
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Experts',
                                          style: AppFont.b24w,
                                        ),
                                        Text(
                                          'For demonstration\nof B2B functionality',
                                          style: AppFont.r16.overrides(color: AppColors.Gray500, fontSize: 12),
                                        ),
                                        SizedBox(
                                          height: 58,
                                        ),
                                        Text(
                                          'For recipients',
                                          style: AppFont.r16.overrides(color: AppColors.Gray500, fontSize: 12),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          if (_clientAvailable && !_expertAvailable)
                            Expanded(
                              child: GestureDetector(
                                onTap: () {},
                                child: Container(
                                  height: 184,
                                  decoration: ShapeDecoration(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      color: AppColors.Gray850),
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Experts',
                                          style: AppFont.b24w.overrides(color: AppColors.Gray500),
                                        ),
                                        Text(
                                          'For demonstration\nof B2B functionality',
                                          style: AppFont.r16.overrides(color: AppColors.Gray700, fontSize: 12),
                                        ),
                                        SizedBox(
                                          height: 58,
                                        ),
                                        Text(
                                          'For recipients',
                                          style: AppFont.r16.overrides(color: AppColors.Gray700, fontSize: 12),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          SizedBox(
                            width: 20,
                          ),
                          if (!_clientAvailable && _expertAvailable)
                            Expanded(
                              child: GestureDetector(
                                onTap: () {},
                                child: Container(
                                  height: 184,
                                  width: 200,
                                  decoration: ShapeDecoration(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      color: AppColors.Gray850),
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Clients',
                                          style: AppFont.b24w.overrides(color: AppColors.Gray500),
                                        ),
                                        Text(
                                          'For demonstration\nof B2B functionality',
                                          style: AppFont.r16.overrides(color: AppColors.Gray700, fontSize: 12),
                                        ),
                                        SizedBox(
                                          height: 58,
                                        ),
                                        Text(
                                          'For Callers',
                                          style: AppFont.r16.overrides(color: AppColors.Gray700, fontSize: 12),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          if (_clientAvailable)
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  appState.updatetesturl(defaultUrl);
                                  AppStateNotifier.updateClientState(true);
                                  AppStateNotifier.UpWeightHistory(weightDataList);
                                  appState.setRole("client");
                                  UserController.gettestuser();
                                  context.pushNamed(
                                    'home',
                                  );
                                },
                                child: Container(
                                  height: 184,
                                  width: 200,
                                  decoration: ShapeDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Color(0xFFFCFDFF).withOpacity(0.20),
                                        Color(0xFFFCFDFF).withOpacity(0.04),
                                      ],
                                    ),
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(width: 0.50, color: Color(0x33FBFCFF)),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    shadows: [
                                      BoxShadow(
                                        color: Color(0xB2121212),
                                        blurRadius: 8,
                                        offset: Offset(0, 0),
                                        spreadRadius: 0,
                                      )
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Clients',
                                          style: AppFont.b24w,
                                        ),
                                        Text(
                                          'For demonstration\nof B2B functionality',
                                          style: AppFont.r16.overrides(color: AppColors.Gray500, fontSize: 12),
                                        ),
                                        SizedBox(
                                          height: 58,
                                        ),
                                        Text(
                                          'For Callers',
                                          style: AppFont.r16.overrides(color: AppColors.Gray500, fontSize: 12),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Text(
                      '* Please refer to the manual for instructions on \n   how to use the demo version',
                      style: AppFont.r16.overrides(color: AppColors.primaryBackground, fontSize: 12),
                    ),
                  )
                ],
              ),
            ),
          )),
        );
      },
    );
  }
}
