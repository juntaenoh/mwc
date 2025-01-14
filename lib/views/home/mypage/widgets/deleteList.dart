import 'package:flutter/material.dart';
import 'package:mwc/index.dart';
import 'package:flutter/widgets.dart';

class DeleteOptionsWidget extends StatefulWidget {
  final VoidCallback onDeleteAll;
  final VoidCallback onshow;

  DeleteOptionsWidget({Key? key, required this.onDeleteAll, required this.onshow}) : super(key: key);
  @override
  State<DeleteOptionsWidget> createState() => _DeleteOptionsWidgetState();
}

class _DeleteOptionsWidgetState extends State<DeleteOptionsWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            spreadRadius: 1,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          InkWell(
            onTap: () {
              widget.onshow();
              context.pop();
            },
            child: Container(
              height: 25,
              width: 200,
              child: Text(
                SetLocalizations.of(context).getText('historySelectDeleteLabel'),
                style: AppFont.r16.overrides(color: AppColors.Black),
              ),
            ),
          ),
          Divider(),
          InkWell(
            onTap: () {
              widget.onDeleteAll();
            },
            child: Container(
              height: 25,
              width: 200,
              child: Text(
                SetLocalizations.of(context).getText('historySelectDeleteAllLabel'),
                style: AppFont.r16.overrides(color: AppColors.Black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
