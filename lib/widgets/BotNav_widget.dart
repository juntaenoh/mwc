import 'package:mwc/components/No_device.dart';
import 'package:mwc/components/Yes_device.dart';
import 'package:mwc/views/home/business/business_home.dart';
import 'package:mwc/views/home/home_page/home_b2b.dart';
import 'package:flutter/material.dart';
import 'package:mwc/views/landingScreen.dart';
import 'package:mwc/widgets/dev.dart';
import 'package:mwc/widgets/out.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import '../index.dart';

class BotNav extends StatefulWidget {
  const BotNav({Key? key}) : super(key: key);

  @override
  State<BotNav> createState() => _BotNavState();
}

class _BotNavState extends State<BotNav> {
  late PersistentTabController _controller;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    _controller = PersistentTabController(initialIndex: 2);
  }

  Future<void> noshow(BuildContext context) async {
    showAlignedDialog(
      context: context,
      isGlobal: true,
      avoidOverflow: false,
      targetAnchor: AlignmentDirectional(0, 0).resolve(Directionality.of(context)),
      followerAnchor: AlignmentDirectional(0, 0.5).resolve(Directionality.of(context)),
      builder: (dialogContext) {
        return Material(
          color: Colors.transparent,
          child: GestureDetector(
            child: Container(
              height: 200,
              width: 327,
              child: NoDivice(),
            ),
          ),
        );
      },
    );
  }

  Future<void> yesshow(BuildContext context) async {
    showAlignedDialog(
      context: context,
      isGlobal: true,
      avoidOverflow: false,
      targetAnchor: AlignmentDirectional(0, 0).resolve(Directionality.of(context)),
      followerAnchor: AlignmentDirectional(0, 0.5).resolve(Directionality.of(context)),
      builder: (dialogContext) {
        return Material(
          color: Colors.transparent,
          child: GestureDetector(
            child: Container(
              height: 60,
              width: 327,
              child: YesDivice(),
            ),
          ),
        );
      },
    );
  }

  final List<Widget> _widgetOptions = <Widget>[
    dev(),
    dev(),
    AppStateNotifier.instance.isClient ? HomePageWidget() : b2bhome(),
    AppStateNotifier.instance.isClient ? BusinessHome() : dev(),
    //MyPageLanding(),
    out(),
  ];

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: _buildSvgIcon("assets/icons/user.svg", AppColors.primaryBackground),
        inactiveIcon: _buildSvgIcon("assets/icons/user.svg", AppColors.Gray500),
        activeColorPrimary: AppColors.primaryBackground,
        inactiveColorPrimary: AppColors.Gray500,
        title: "group",
        activeColorSecondary: AppColors.primaryBackground,
      ),
      PersistentBottomNavBarItem(
        icon: _buildSvgIcon("assets/icons/calendar.svg", AppColors.primaryBackground),
        inactiveIcon: _buildSvgIcon("assets/icons/calendar.svg", AppColors.Gray500),
        activeColorPrimary: AppColors.primaryBackground,
        inactiveColorPrimary: AppColors.Gray500,
        title: "calendar",
        activeColorSecondary: AppColors.primaryBackground,
      ),
      // PersistentBottomNavBarItem(
      //   icon: _buildSvgIcon('assets/icons/scan.svg'),
      //   activeColorPrimary: AppColors.DarkenGreen,
      //   inactiveColorPrimary: Colors.grey,
      //   onPressed: (context) async {
      //     // Here context is not used directly
      //     if (_scaffoldKey.currentContext == null) {
      //       print('Error: scaffoldKey.currentContext is null');
      //       return;
      //     }
      //     if (!AppStateNotifier.instance.isdevice) {
      //       noshow(_scaffoldKey.currentContext!); // Use scaffoldKey.currentContext
      //     } else {
      //       yesshow(_scaffoldKey.currentContext!); // Use scaffoldKey.currentContext
      //     }
      //   },
      // ),

      PersistentBottomNavBarItem(
        icon: _buildSvgIcon("assets/icons/home.svg", AppColors.primaryBackground),
        inactiveIcon: _buildSvgIcon("assets/icons/home.svg", AppColors.Gray500),
        activeColorPrimary: AppColors.primaryBackground,
        inactiveColorPrimary: AppColors.Gray500,
        title: "Home",
        activeColorSecondary: AppColors.primaryBackground,
      ),

      PersistentBottomNavBarItem(
        icon: _buildSvgIcon("assets/icons/hash.svg", AppColors.primaryBackground),
        inactiveIcon: _buildSvgIcon("assets/icons/hash.svg", AppColors.Gray500),
        activeColorPrimary: AppColors.primaryBackground,
        inactiveColorPrimary: AppColors.Gray500,
        title: "hash",
        activeColorSecondary: AppColors.primaryBackground,
      ),

      PersistentBottomNavBarItem(
        icon: _buildSvgIcon("assets/icons/Group 1000006934.svg", AppColors.primaryBackground),
        inactiveIcon: _buildSvgIcon("assets/icons/Group 1000006934.svg", AppColors.Gray500),
        activeColorPrimary: AppColors.primaryBackground,
        inactiveColorPrimary: AppColors.Gray500,
        title: "my",
        activeColorSecondary: AppColors.primaryBackground,
        // onPressed: (context) async {
        //   await AppStateNotifier.instance.logout();
        //   context.pushNamed(
        //     '/',
        //   );
        // },
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: PersistentTabView(_scaffoldKey.currentContext ?? context,
          controller: _controller,
          screens: _widgetOptions,
          items: _navBarsItems(),
          //confineInSafeArea: true,
          backgroundColor: AppColors.Gray850,
          handleAndroidBackButtonPress: true,
          resizeToAvoidBottomInset: true,
          stateManagement: true,
          navBarHeight: 70,
          navBarStyle: NavBarStyle.style12,
          floatingActionButton: Container()),
    );
  }
}

Widget _buildSvgIcon(String assetName, Color color) {
  return SvgPicture.asset(
    assetName,
    width: 24.0,
    height: 24.0,
    colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
  );
}
