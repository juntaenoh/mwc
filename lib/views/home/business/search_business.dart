import 'package:mwc/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Searchbusiness extends StatefulWidget {
  const Searchbusiness({Key? key}) : super(key: key);

  @override
  State<Searchbusiness> createState() => _SearchbusinessState();
}

class _SearchbusinessState extends State<Searchbusiness> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateNotifier>(
      builder: (context, AppStateNotifier, child) {
        return Scaffold(
          key: scaffoldKey,
          backgroundColor: AppColors.Black,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(98.0),
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
            child: Container(),
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
        children: [],
      ),
    );
  }
}
