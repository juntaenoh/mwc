import 'package:mwc/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class visionselect extends StatefulWidget {
  const visionselect({Key? key}) : super(key: key);

  @override
  State<visionselect> createState() => _visionselectState();
}

class _visionselectState extends State<visionselect> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateNotifier>(
      builder: (context, AppStateNotifier, child) {
        return Scaffold(
          key: scaffoldKey,
          backgroundColor: AppColors.Black,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(54.0),
            child: AppBar(
              elevation: 0,
              titleSpacing: 10,
              backgroundColor: AppColors.Black,
              automaticallyImplyLeading: false,
              flexibleSpace: Padding(
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 12),
                child: _buildappheader(context),
              ),
            ),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 350,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            'Plantar pressure measurement\nhas been completed.',
                            style: AppFont.b24.overrides(fontSize: 24, color: AppColors.Gray200),
                          ),
                          Text(
                            'For Vision Analysis, a video of your body is filmed. The data being photographed is protected as in the previous terms and conditions.',
                            style: AppFont.r16.overrides(color: AppColors.Gray200),
                          ),
                          Text(
                            'If you would like to proceed with the accurate measurement experience, please press the Start Vision analysis button below to continue the experience.',
                            style: AppFont.r16.overrides(color: AppColors.Gray200),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Column(
                      children: [
                        Container(
                          width: double.infinity,
                          height: 56.0,
                          decoration: BoxDecoration(),
                          child: LodingButtonWidget(
                            onPressed: () {
                              context.pushNamed('testFootresult', extra: 'tester');
                            },
                            text: 'Look only plantar pressure results',
                            options: LodingButtonOptions(
                              height: 40.0,
                              padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                              iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                              color: AppColors.Black,
                              textStyle: AppFont.s18.overrides(fontSize: 16, color: AppColors.primaryBackground),
                              elevation: 0,
                              borderSide: BorderSide(
                                color: AppColors.primaryBackground,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: double.infinity,
                          height: 56.0,
                          decoration: BoxDecoration(),
                          child: LodingButtonWidget(
                            onPressed: () {
                              context.pushNamed('vison');
                            },
                            text: 'Start Vision analysis',
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
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildappheader(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Scan Complete',
            style: AppFont.s12.overrides(color: AppColors.primaryBackground, fontSize: 18),
          )
        ],
      ),
    );
  }
}
