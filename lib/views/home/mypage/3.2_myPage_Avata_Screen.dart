import 'package:mwc/models/FootData.dart';
import 'package:mwc/views/home/home_page/unity_widget.dart';
import 'package:mwc/views/home/mypage/widgets/3.2.1_my_scandata.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mwc/index.dart';
import 'package:provider/provider.dart';

class Myavata extends StatefulWidget {
  const Myavata({Key? key}) : super(key: key);
  @override
  _MyavataState createState() => _MyavataState();
}

class _MyavataState extends State<Myavata> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  double rightPosition = 0;
  bool detailstate = false;
  bool detailinfo = false;

  var mydata;

  void togglePositionAndControls() {
    setState(() {
      rightPosition = rightPosition == 0 ? -150 : 0;
      detailstate = !detailstate;
    });
  }

  void toggleddata() {
    setState(() {
      detailinfo = !detailinfo;
    });
  }

  late List<FootData>? foot;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }

  Future<void> showModalBottomSheetWithStates(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.transparent,
      builder: (context) => MyScanData(),
    );
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
    return Consumer<AppStateNotifier>(builder: (context, appStateNotifier, child) {
      foot = appStateNotifier.footdata;
      double screenHeight = MediaQuery.of(context).size.height;
      double screenWidth = MediaQuery.of(context).size.width;
      double containerHeight = screenHeight * 0.5;

      return GestureDetector(
        child: Scaffold(
            key: scaffoldKey,
            backgroundColor: AppColors.Black,
            appBar: AppBar(
              elevation: 0,
              titleSpacing: 10,
              backgroundColor: AppColors.Black,
              automaticallyImplyLeading: false,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 15, 0, 5),
                    child: Text(
                      SetLocalizations.of(context).getText('profileAvatarLabel',
                          values: {'name': '${appStateNotifier.userdata!.firstName}${appStateNotifier.userdata!.lastName}'}),
                      style: AppFont.s18.overrides(color: AppColors.primaryBackground),
                    ),
                  ),
                ],
              ),
              actions: [
                IconButton(
                  icon: Icon(
                    Icons.close,
                    color: AppColors.primaryBackground,
                    size: 20,
                  ),
                  onPressed: () {
                    context.pop();
                  },
                ),
              ],
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 100.0),
                  child: Platform.isIOS
                      ? UnityWidgetWrapper(
                          height: containerHeight,
                          type: AppStateNotifier.instance.testUser!.TestUserRecords.first.classType,
                        )
                      : Avata(
                          height: containerHeight,
                        ),
                ),
                MyScanData(),
              ],
            )),
      );
    });
  }
}
