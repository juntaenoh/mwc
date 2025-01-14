import 'package:mwc/utils/form_field_controller.dart';
import 'package:mwc/views/home/group/widgets/member_more.dart';
import 'package:mwc/models/GroupData.dart';
import 'package:mwc/widgets/flutter_drop_down.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mwc/index.dart';
import 'package:provider/provider.dart';

class SettingLang extends StatefulWidget {
  const SettingLang({Key? key}) : super(key: key);

  @override
  _SettingLangState createState() => _SettingLangState();
}

class _SettingLangState extends State<SettingLang> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  FormFieldController<String>? dropDownValueController;
  String? dropDownValue;

  @override
  void initState() {
    super.initState();

    Locale? locale = SetLocalizations.getStoredLocale();
    if (locale != null) {
      dropDownValue = '${locale.languageCode}' == 'ko' ? '한국어' : 'English';
      print('Stored locale: ${locale.languageCode}_${locale.countryCode}');
    } else {
      print('No locale stored');
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
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
      return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
              key: scaffoldKey,
              backgroundColor: AppColors.primaryBackground,
              appBar: AppBar(
                actions: [
                  AppIconButton(
                    borderColor: Colors.transparent,
                    borderRadius: 30.0,
                    borderWidth: 1.0,
                    buttonSize: 40.0,
                    icon: Icon(
                      Icons.close,
                      color: AppColors.Black,
                      size: 24.0,
                    ),
                    onPressed: () async {
                      context.pop();
                    },
                  ),
                ],
                backgroundColor: Color(0x00CCFF8B),
                automaticallyImplyLeading: false,
                title: Text(SetLocalizations.of(context).getText('elqlkdl'), style: AppFont.s18.overrides(color: AppColors.primaryBackground)),
                centerTitle: false,
                elevation: 0.0,
              ),
              body: SafeArea(
                  child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    _buildLanguageDropDown(context),
                  ],
                ),
              ))));
    });
  }

  Widget _buildLanguageDropDown(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text('Language', style: TextStyle(fontSize: 12)),
        const SizedBox(height: 8),
        FlutterDropDown<String>(
          controller: dropDownValueController ??= FormFieldController<String>(dropDownValue),
          options: [
            '한국어',
            'English',
            //'日本語',
          ],
          onChanged: (val) async {
            setState(() => dropDownValue = val);
            if (val == '한국어') {
              setAppLanguage(context, 'ko');
            } else if (val == 'English') {
              setAppLanguage(context, 'en');
            }
            // else if (val == '日本語') {
            //   setAppLanguage(context, 'ja');
            // }
          },
          width: double.infinity,
          height: 38.0,
          textStyle: AppFont.r16.overrides(color: AppColors.Gray500),
          hintText: '한국어',
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppColors.Gray500,
            size: 20.0,
          ),
          elevation: 2.0,
          borderColor: AppColors.Gray200,
          borderWidth: 1.0,
          borderRadius: 8.0,
          borderStyle: 'all',
          margin: EdgeInsetsDirectional.fromSTEB(16.0, 4.0, 16.0, 4.0),
          hidesUnderline: true,
          isSearchable: false,
          isMultiSelect: false,
        ),
        // Include your Dropdown code here
      ],
    );
  }

  Widget _buildnoDevice(BuildContext context) {
    return Container(
        height: 76,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: AppColors.Gray850,
        ),
        child: Center(
            child: Text(SetLocalizations.of(context).getText('emdfhrsh'), style: AppFont.r16.overrides(color: AppColors.Gray500, fontSize: 12))));
  }

  Widget _buildaddDevice(BuildContext context) {
    return InkWell(
      onTap: () {
        context.goNamed('FindBlue', extra: 'main');
      },
      child: Container(
          height: 76,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(width: 1, color: AppColors.primaryBackground),
            color: AppColors.Black,
          ),
          child: Center(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add_circle_outline_outlined,
                color: AppColors.primaryBackground,
              ),
              SizedBox(
                width: 12,
              ),
              Text(SetLocalizations.of(context).getText('ecnrk'), style: AppFont.s18.overrides(color: AppColors.primaryBackground, fontSize: 16)),
            ],
          ))),
    );
  }

  Widget _buildcaliDevice(BuildContext context) {
    return InkWell(
      onTap: () {
        context.goNamed('DeviceCalibration');
      },
      child: Container(
          height: 76,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(width: 1, color: AppColors.primaryBackground),
            color: AppColors.Black,
          ),
          child: Center(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add_circle_outline_outlined,
                color: AppColors.primaryBackground,
              ),
              SizedBox(
                width: 12,
              ),
              Text('Calibration', style: AppFont.s18.overrides(color: AppColors.primaryBackground, fontSize: 16)),
            ],
          ))),
    );
  }

  Widget _buildDevice(BuildContext context) {
    return Container(
        height: 84,
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
          padding: const EdgeInsets.all(22.0),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Column(children: [
              Text(
                AppStateNotifier.instance.device!,
                style: AppFont.s18.overrides(fontSize: 16, color: AppColors.primaryBackground),
              )
            ]),
            InkWell(
              onTap: () {
                AppStateNotifier.instance.removedevice();
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.red, width: 1),
                ),
                child: Icon(
                  Icons.close,
                  color: AppColors.red,
                  size: 25,
                ),
              ),
            )
          ]),
        ));
  }

  Widget _buildyesDevice(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
          height: 76,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(width: 1, color: AppColors.Gray500),
            color: AppColors.Black,
          ),
          child: Center(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add_circle_outline_outlined,
                color: AppColors.Gray500,
              ),
              SizedBox(
                width: 12,
              ),
              Text(SetLocalizations.of(context).getText('ecnrk'), style: AppFont.s18.overrides(color: AppColors.Gray500, fontSize: 16)),
            ],
          ))),
    );
  }
}
