import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:mwc/index.dart';

class GroupWidget extends StatefulWidget {
  const GroupWidget({Key? key}) : super(key: key);

  @override
  _GroupWidgetState createState() => _GroupWidgetState();
}

class _GroupWidgetState extends State<GroupWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late AppStateNotifier _appStateNotifier;
  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    _appStateNotifier = AppStateNotifier.instance;
    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }

  Future<void> _refreshGroup() async {
    // 새로고침할 때 실행할 비동기 함수
    await GroupApi.findGroup();
    _refreshController.refreshCompleted();
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
      bool groif = appStateNotifier.isGroup;
      print(groif);
      return GestureDetector(
        child: Scaffold(
          key: scaffoldKey,
          backgroundColor: AppColors.Black,
          appBar: AppBar(
            backgroundColor: groif ? AppColors.Gray850 : Color(0x00CCFF8B),
            automaticallyImplyLeading: false,
            title: Text(
              SetLocalizations.of(context).getText('ze1uteze'),
              style: AppFont.s18.overrides(color: AppColors.primaryBackground),
            ),
            actions: <Widget>[
              if (_appStateNotifier.isGroup)
                IconButton(
                  icon: Icon(Icons.settings),
                  onPressed: () {
                    context.pushNamed(
                      'groupSetting',
                      extra: {
                        'authority': appStateNotifier.myAuthority,
                        'groupname': appStateNotifier.groupData!.first.groupName,
                      },
                    );
                  },
                ),
            ],
            centerTitle: false,
            elevation: 0.0,
          ),
          body: SmartRefresher(
            controller: _refreshController,
            onRefresh: _refreshGroup,
            child: _buildContent(),
          ),
        ),
      );
    });
  }

  Widget _buildContent() {
    print(_appStateNotifier.isGroup);
    print(_appStateNotifier.iswait);

    return _appStateNotifier.isGroup
        ? YesgroupScreen()
        : _appStateNotifier.iswait
            ? (_appStateNotifier.Groupstate != 'DECLINED')
                ? WaitgroupScreen()
                : NogroupScreen()
            : NogroupScreen();
  }
}
